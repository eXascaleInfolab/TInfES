#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
\descr: Convert RDF N-Tripple dataset to CNL cluster members ids
	Convert RDD dataset or resulting types in the RDF format to the ids mapping or CNL clustering
\author: Artem Lutov <artem@exascale.info>
\organizations: eXascale lab <http://exascale.info/>
"""
from __future__ import print_function, division  # Required for stderr output, must be the first import
from future.utils import viewvalues  #, viewitems
import argparse
import sys
import glob
import os


def parseArgs(args=None):
	"""Parse the terminal arguments

	args  - arguments list to be parsed, None means sys.argv
	"""
	# formatter_class=argparse.ArgumentDefaultsHelpFormatter
	parser = argparse.ArgumentParser(description='  Convert input RDF N-Tripple dataset to the id-URI mapping'
		' or resulting types to the .cnl clustering format.'
		, formatter_class=argparse.RawDescriptionHelpFormatter
		, epilog="""Examples:
{0} -o ./cnl/ opengov/*.types'
python3 {0} -t restypes/country.types -o rescnl ../country.rdf
"""
		.format(sys.argv[0]))
	parser.add_argument('-t', '--type-file'  #, metavar='FILE_NAME'
		, help='Resulting type file in RDF N-Tripple format to be converted into CNL format using suppotring RDF input file')
	parser.add_argument('-p', '--purify-types', action='store_true'  #, metavar='FILE_NAME'
		, help='Omit resulting types that are not in the supporing RDF file on the CNL formation'
			', otherwise warn about the existence of such added types')
	parser.add_argument('-o', '--output-dir', dest='outp_dir'
		, help='Output directory to store .imap or .cnl conversion results')
	parser.add_argument('rdfname', metavar='RDF_FILENAME'  #, dest='bar'
		, help='Input RDF N-Tripple files specified by the wildcard or supporting rdf input file for the type file')

	return parser.parse_args(args)


def makeSubjIds(rdfname, mapfile=None, types=None):
	"""Map subjects to ids

	rdfname  - input RDF N-Tripples file name
	mapname  - output id mapping file object or None
	types  - set of accumulated types if not None
	return
		subjstp  - name: id mapping for the typed subjects
		idend  - end of the original ids
	"""
	tprop = '<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>'  # Type property
	subjstp = {}  # Typed subjects to be returned
	sbis = {}  # Original subject ids
	with open(rdfname) as frdf:
		sid = 0  # Subject id
		for ln in frdf:
			# Consider comments as leading # and empty lines (at least the ending )
			if not ln or ln[0] == '#':
				continue
			if ln.startswith(' '):
				raise ValueError('N-Tripple format is invalid: ' + ln)
			name, pred, obj = ln.split(' ', 2)
			# Update typped subjects
			if pred == tprop:
				subjstp[name] = sbis.get(name, sid)
				if types is not None:
					types.add(obj.rstrip('\n. \t'))
			# Note: initially unique subjects should be added to retain original ids
			if sbis.setdefault(name, sid) == sid:
				if mapfile:
					mapfile.write('{}\t{}\n'.format(sid, name))
				sid += 1  # This item has just been added
	print('The number of typed subjects in {}: {} / {} ({:.2%})'.format(os.path.split(rdfname)[1]
		, len(subjstp), sid, len(subjstp) / sid))
	return subjstp, sid


def convert(opts):
	"""Convert RDF to .imap or .cnl according to the specified options

	opts  - converison options
	"""
	# Create output directories if they do not exist
	if opts.outp_dir and not os.path.exists(opts.outp_dir):
		os.makedirs(opts.outp_dir)

	# Perfoem wildcard resolution if the type file is not specified
	if not opts.type_file:
		#rext = '.imap'  # Extension of the result
		for fname in glob.iglob(opts.rdfname):
			outpname = os.path.splitext(fname)[0] + '.imap'
			if opts.outp_dir:
				outpname = os.path.join(opts.outp_dir, os.path.split(outpname)[1])
			with open(outpname, 'w') as fout:
				print('Forming {} ...'.format(outpname))
				makeSubjIds(fname, fout)
		return

	# Convert type result to the .cnl format
	tprop = '<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>'  # Type property
	cls = {}  # Resulting classes of member ids in the format "type: ids"
	with open(opts.type_file) as finp:
		types = None if not opts.purify_types else set()
		sbis, sidx = makeSubjIds(opts.rdfname, None, types)
		xtypes = False  # Converting types contain subj ids that were not present or did not have types in the RDF dataset
		print('Loading types from {} using the base {} ...'.format(opts.type_file, opts.rdfname))
		for ln in finp:
			# Consider comments and empty lines (at least the ending one)
			if not ln or ln.startswith('#'):
				continue
			subj, pred, obj = ln.split(' ', 2)
			obj = obj.rstrip('\n. \t')
			if pred != tprop:
				raise ValueError('Unexpected predicate (rdf:type is exptected): ' + ln)
			# Omit extra types if required
			if types and obj not in types:
				xtypes = True
				continue  # Omit
			mbs = cls.setdefault(obj, [])
			sid = sbis.get(subj)
			if sid is None:
				xtypes = True
				if opts.purify_types:
					# The subject does not have any types in the supporting RDF, but have the resulting type present in the supporting RDF
					continue  # Omit
				else:
					sbis[subj] = sidx
					sid = sidx
					sidx += 1
			mbs.append(sid)
		if xtypes:
			print('WARNING, converting types contained typed subjects that are not present in the supprting RDF dataset, '
				+ ('the exta types are omitted' if opts.purify_types else 'included with new ids'), file=sys.stderr)

	# Output the fomred clusters
	outpname = os.path.splitext(opts.type_file)[0] + '.cnl'
	if opts.outp_dir:
		outpname = os.path.join(opts.outp_dir, os.path.split(outpname)[1])
	with open(outpname, 'w') as fout:
		for mbs in viewvalues(cls):
			# Note: empty members might be present in case of purification
			if not mbs:
				assert opts.purify_types, 'Empty cluser members may exists only for the purified types'
				continue
			fout.write(' '.join([str(mid) for mid in mbs]))
			fout.write('\n')
		print('Formed: {}'.format(outpname))


if __name__ == '__main__':
	convert(parseArgs())
