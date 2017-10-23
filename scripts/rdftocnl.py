#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
\descr: Convert RDF N-Tripple dataset to CNL cluster members ids
	Convert RDD dataset or resulting types in the RDF format to the ids mapping or CNL clustering
\author: Artem Lutov <artem@exascale.info>
\organizations: eXascale lab <http://exascale.info/>
"""
from __future__ import print_function, division  # Required for stderr output, must be the first import
from future.utils import viewvalues
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
{0} -r 0.5 -t typestats.txt opengov/*.nt'
python3 {0} ./samplerds.py -c -r 0.5 -t typestats.txt biomedical/*.nq
{0} -c -r 0.25 -o biomedical/samples_s0.25/ -t types.info biomedical/lsr.nq biomedical/gen*.nq
"""
		.format(sys.argv[0]))
	# parser.add_argument('-r', '--rdf-file', required=True
	# 	, help='Input RDF N-Tripple files specified by the wildcard or supporting rdf input file')
	parser.add_argument('-t', '--type-file'  #, metavar='FILE_NAME'
		, help='Resulting type file in RDF N-Tripple format to be converted into CNL format using suppotring RDF input file')
	parser.add_argument('-o', '--output-dir'
		, help='Output directory to store .imap or .cnl conversion results')
	parser.add_argument('rdfname', required=True, metavar='RDF-FILENAME'  #, dest='bar'
		, help='Input RDF N-Tripple files specified by the wildcard or supporting rdf input file for the type file')

	return parser.parse_args(args)


def makeSubjIds(rdfname, mapfile):
	"""Make subjects to ids mapping

	rdfname  - input RDF N-Tripples file name
	mapname  - output id mapping file object or None
	return  - name: id mapping
	"""
	sbis = {}
	assert mapfile is None or isinstance(mapfile, file), 'mapfile should a file object'
	with open(rdfname) as frdf:
		sid = 0  # Subject id
		for ln in frdf:
			# Consider comments as leading # and empty lines (at least the ending )
			if not ln or ln[0] == '#':
				continue
			name = ln.split(1, ' ')[0]
			if sbis.setdefault(name, sid) == sid:
				if mapfile:
					mapfile.write('{}\t{}\n'.format(sid, name))
				sid += 1  # This item has just been added
	return sbis


def convert(opts):
	# Create output directories if they do not exist
	if opts.outp_dir and not os.path.exists(opts.outp_dir):
		os.makedirs(opts.outp_dir)

	# Perfoem wildcard resolution if the type file is not specified
	if not opts.type_file:
		#rext = '.imap'  # Extension of the result
		for fname in glob.iglob(opts.rdfname):
			outpname = os.path.splitext(fname)[0] + '.imap'
			if opts.output_dir:
				outpname = os.path.join(opts.output_dir, os.path.split(outpname)[1])
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
			subj, pred, obj = ln.split(2, ' ')
			obj = obj.rtrim('. \t')
			if pred != tprop:
				raise ValueError('Unexpected predicate (rdf:type is exptected): ' + ln)
			mbs = cls.setdefault(obj, [])
			mbs.append(sbis[obj])
	# Output the fomred clusters
	outpname = os.path.splitext(opts.type_file)[0] + '.cnl'
	if opts.output_dir:
		outpname = os.path.join(opts.output_dir, os.path.split(outpname)[1])
	with open(outpname, 'w') as fout:
		print('Forming {} ...'.format(outpname))
		for mbs in viewvalues(cls):
			fout.write(' '.join([str(mid) for mid in mbs]))
			fout.write('\n')


if __name__ == '__main__':
	convert(parseArgs())
