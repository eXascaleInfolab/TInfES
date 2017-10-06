#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
\descr: Sample entities from the input RDF dataset.
	Produce the output RDF dataset as reduction of the input dataset by the specified ratio.
\author: Artem Lutov <artem@exascale.info>
\organizations: eXascale lab <http://exascale.info/>
"""
from __future__ import print_function, division  # Required for stderr output, must be the first import
# # Required to efficiently traverse items of dictionaries in both Python 2 and 3
# try:
# 	from future.builtins import range
# except ImportError:
# 	# Replace range() implementation for Python2
# 	try:
# 		range = xrange
# 	except NameError:
# 		pass  # xrange is not defined in Python3, which is fine
import argparse
import os
import rdflib
import random


def parseArgs(args=None):
	"""Parse the terminal arguments

	args  - arguments list to be parsed, None means sys.argv
	"""
	# formatter_class=argparse.ArgumentDefaultsHelpFormatter
	parser = argparse.ArgumentParser(description='Sample entities from the input RDF dataset'
		' producing the output RDF dataset of the specified ratio of the input size.')
	parser.add_argument('-r', '--ratio', type=float, default='0.25'
		, help='Reduction ratio for the number of entities, float E (0, 1)')
	parser.add_argument('-s', '--seed', type=int
		, help='Seed for the random sammpling, uint64_t')
	parser.add_argument('-o', '--output'  # , metavar='filename'
		, help='Output file name, default: <input_filename>_<reduction_ratio>.<orig_ext>')
	parser.add_argument('dataset', help='File name of the input RDF dataset in N3/quad format')

	return parser.parse_args(args)


def sample(opts):
	"""Sample RDF dataset"""
	# Validate opts
	if not 0 < opts.ratio < 1:
		raise ValueError('The ratio is out of range (0, 1): ' + str(opts.ratio))
	if not opts.output:
		name, ext = os.path.splitext(opts.dataset)
		opts.output = ''.join((name, '_', str(opts.ratio), ext))

	gr = rdflib.Graph()
	gr.parse(opts.dataset, format='n3')
	print('The RDF dataset is loaded: {} triples, seed: {}'.format(len(gr), opts.seed))
	random.seed(opts.seed)  # Note: None means use system time
	grsubjsNum = len(gr.subjects())
	# Remove all selected subjects from the original graph, which should be more
	# efficient than multiple subsequent selections of the resources
	subjs = random.sample(gr.subjects(), grsubjsNum * (1 - opts.ratio))
	for sb in subjs:
		#ent = Resource(gr, sb)  #URIRef(
		#ent.graph.serialize(file, , format='n3')  # Serialize to the OPENED file!
		gr.remove((sb, None, None))  # Remove all triples with the specified subject

	gr.serialize(opts.output, format='n3')
	print('The random sample of {} / {} entities is saved in RDF N3 format to: {}'
		.format(len(subjs), grsubjsNum, opts.output))


if __name__ == '__main__':
	sample(parseArgs())
