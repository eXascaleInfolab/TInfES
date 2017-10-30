#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
\descr: Convert RDF N-Tripple dataset to CNL cluster members ids
	Convert RDD dataset or resulting types in the RDF format to the ids mapping or CNL clustering
\author: Artem Lutov <artem@exascale.info>
\organizations: eXascale lab <http://exascale.info/>
"""
from __future__ import print_function, division  # Required for stderr output, must be the first import
from future.utils import viewvalues, viewitems
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
	# parser.add_argument('-r', '--rdf-file', required=True
	# 	, help='Input RDF N-Tripple files specified by the wildcard or supporting rdf input file')
	parser.add_argument('-t', '--type-file'  #, metavar='FILE_NAME'
		, help='Resulting type file in RDF N-Tripple format to be converted into CNL format using suppotring RDF input file')
	parser.add_argument('-o', '--output-dir', dest='outp_dir'
		, help='Output directory to store .imap or .cnl conversion results')
	parser.add_argument('rdfname', metavar='RDF_FILENAME'  #, dest='bar'
		, help='Input RDF N-Tripple files specified by the wildcard or supporting rdf input file for the type file')

	return parser.parse_args(args)


def makeSubjIds(rdfname, mapfile=None):
	"""Map subjects to ids

	rdfname  - input RDF N-Tripples file name
	mapname  - output id mapping file object or None
	return  - name: id mapping
	"""
	sbis = {}
	with open(rdfname) as frdf:
		sid = 0  # Subject id
		for ln in frdf:
			# Consider comments as leading # and empty lines (at least the ending )
			if not ln or ln[0] == '#':
				continue
			if ln.startswith(' '):
				raise ValueError('N-Tripple format is invalid: ' + ln)
			name = ln.split(' ', 1)[0]
			if sbis.setdefault(name, sid) == sid:
				if mapfile:
					mapfile.write('{}\t{}\n'.format(sid, name))
				sid += 1  # This item has just been added
	return sbis


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
		sbis = makeSubjIds(opts.rdfname)
		print('Loading types from {} using the base {} ...'.format(opts.type_file, opts.rdfname))
		for ln in finp:
			# Consider comments and empty lines (at least the ending one)
			if not ln or ln.startswith('#'):
				continue
			subj, pred, obj = ln.split(' ', 2)
			obj = obj.rstrip('\n. \t')
			if pred != tprop:
				raise ValueError('Unexpected predicate (rdf:type is exptected): ' + ln)
			mbs = cls.setdefault(obj, [])
			mbs.append(sbis[subj])
	# Output the fomred clusters
	outpname = os.path.splitext(opts.type_file)[0] + '.cnl'
	if opts.outp_dir:
		outpname = os.path.join(opts.outp_dir, os.path.split(outpname)[1])
	with open(outpname, 'w') as fout:
		for mbs in viewvalues(cls):
			fout.write(' '.join([str(mid) for mid in mbs]))
			fout.write('\n')
		print('Formed: {}'.format(outpname))


if __name__ == '__main__':
	convert(parseArgs())
