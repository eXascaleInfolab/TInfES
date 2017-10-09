#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
\descr: Sample entities from the input RDF dataset.
	Produce the output RDF dataset as reduction of the input dataset by the specified ratio.
\author: Artem Lutov <artem@exascale.info>
\organizations: eXascale lab <http://exascale.info/>
"""
from __future__ import print_function, division  # Required for stderr output, must be the first import
import argparse
import os
import sys
import glob
import rdflib
import random
from rdflib.namespace import RDF
from rdflib.plugins.parsers.ntriples import ParseError


def parseArgs(args=None):
	"""Parse the terminal arguments

	args  - arguments list to be parsed, None means sys.argv
	"""
	# formatter_class=argparse.ArgumentDefaultsHelpFormatter
	parser = argparse.ArgumentParser(description='  Sample entities from the input RDF dataset'
		' producing the output RDF dataset of the specified ratio of the input size.'
		, formatter_class=argparse.RawDescriptionHelpFormatter
		, epilog="""Examples:
{0} -r 0.5 -t typestats.txt opengov/*.nt'
python3 {0} ./samplerds.py -c -r 0.5 -t typestats.txt biomedical/*.nq
{0} -c -r 0.25 -o biomedical/samples_s0.25/ -t types.info biomedical/lsr.nq biomedical/gen*.nq
"""
		.format(sys.argv[0]))
	parser.add_argument('-r', '--ratio', type=float, default='0.5'
		, help='Reduction ratio for the number of entities, float E (0, 1)')
	parser.add_argument('-s', '--seed', type=int
		, help='Seed for the random sammpling, uint64_t')
	parser.add_argument('-t', '--type-stat', metavar='FILE_NAME'
		, help='Show type statistics for the input dataset and add it to the specified file')
	parser.add_argument('-i', '--type-info', action='store_true'
		, help='Show type statistics for the input dataset (brief version of --type-stat)')
	parser.add_argument('-o', '--outp-dir'
		, help='Output direcotry name, default: <inp_dir>/samples_s<opts.ratio>/<inp_filename>_<ratio>.<orig_ext>')
	parser.add_argument('-c', '--cust-parse', action='store_true'  # cust_parse
		, help='Use custom parsing instead of RDFlib, useful to process the improper formatted URIs in N3/quad format')
	parser.add_argument('datasets', metavar='WILDCARD', nargs='+'
		, help='File names wildcards of the input RDF dataset[s] in N3/quad format')

	return parser.parse_args(args)


class Entity(object):
	"""Entity to load RDF tripples"""
	# ATTENTION: type(RDF.type + 'x') is <class 'rdflib.term.URIRef'>, which breaks the str comparison
	typeProp = '<' + str(RDF.type) + '>'  # N3/quad type property

	def __init__(self, subj, prop, obj):
		"""Entity constructor

		subj  - subject
		prop  - property
		obj  - object
		"""
		self.subj = subj
		self.attribs = [(prop, obj)]
		self.typped = prop == Entity.typeProp

	def extend(self, prop, obj):
		"""Extend the entity atribbutes

		prop  - property
		obj  - object
		"""
		self.typped = self.typped or prop == Entity.typeProp
		self.attribs.append((prop, obj))

	def __str__(self):
		"""String conversion"""
		return '{}: {} attributes, {}typed'.format(self.subj, len(self.attribs), '' if self.typped else 'non-')


def showTypeStat(estyped, estotal, dsname, tstatName):
	"""Show type information

	estyped  - the number of typed instances
	estotal  - total number of entites
	dsname  - dataset name
	tstatName  - file name for to output types statistics
	"""
	assert 0 <= estyped <= estotal, 'Entity statistics values are invalid: {} / {}'.format(estyped,  estotal)

	print('The number of typed entities in {}: {} / {} ({:.3%})'
		.format(dsname, estyped, estotal, estyped / estotal))
	# Add type info to the specified file
	if tstatName:
		with open(tstatName, 'a') as fout:
			fout.write('{} has {} / {} typed instances: {:.3%}\n'.format(
				dsname, estyped, estotal, estyped / estotal));


def rawSampling(dataset, opts):
	"""Perform manual sampling (without rdflib) as fallback processing

	dataset  - input dataset file name
	opts  - processing options
	"""
	# Load the dataset and identyfy typped entities
	res = {}  # All subjects and objects to avoid duplicates
	props = {}  # All properties to avoid duplicates

	ents = {}  # Loaded entities: subj: entity
	try:
		with open(dataset) as finp:
			for ln in finp:
				if not ln:
					continue
				subj, prop, obj = ln.split(' ', 2)
				obj = obj.rstrip(' .')
				# Reuse objects for the strings
				subj = res.setdefault(subj, subj)
				obj = res.setdefault(obj, obj)
				prop = props.setdefault(prop, prop)
				# Update the entity
				ent = ents.get(subj)
				if ent is not None:
					ent.extend(prop, obj)
				else:
					ents[subj] = Entity(subj, prop, obj)
	except ValueError:
		print('ERROR, Exception on parsing: {}'.format(ln), file=sys.stderr)
		raise

	if not ents:
		print('WARNING, the input dataset is empty: ' + dataset, file=sys.stderr)
		return
	# Release some memory
	res = None
	props = None

	# Show type statistics if required
	if opts.type_stat:
		opts.type_info = True
	dsname = os.path.split(dataset)[1]
	if opts.type_info:
		ntyped = sum([e.typped for e in ents.values()])
		nents = len(ents)
		showTypeStat(ntyped, nents, dsname, opts.type_stat)

	# Perform the sampling
	random.seed(opts.seed)  # Note: None means use system time
	smes = random.sample([e for e in ents.values()], int(nents * (1 - opts.ratio)))
	ents = None
	# Output the sampled entites in the RDF N3/quad firmat
	outfname = os.path.join(opts.outp_dir, dsname)
	with open(outfname, 'w') as foutp:
		for ent in smes:
			for atr in ent.attribs:
				foutp.write(' '.join((ent.subj, atr[0], atr[1], '.')))
	print('The random sample of {:G} / {} entities ({:.2%}) are saved in RDF N3/quad format to: {}'
		.format(nents * opts.ratio, nents, opts.ratio, outfname))


def sampleFile(dataset, opts):
	"""Sample a single dataset according to the specified options

	dataset  - input dataset file name
	opts  - processing options
	"""
	gr = rdflib.Graph()
	numtriples = 0
	dsname = os.path.split(dataset)[1]
	print('Sampling {}...'.format(dsname))
	# Perform the custom parsing if required
	if opts.cust_parse:
		rawSampling(dataset, opts)
		return

	try:
		gr.parse(dataset, format='nquads')  # 'nt', 'nquads'
		numtriples = len(gr)
		print('{} is loaded: {} triples'.format(dataset, numtriples))
	except ParseError as err:
		print('WARNING, Parcing of {} by RDFLib failed: {}'.format(dsname, err), file=sys.stderr)
	if not numtriples:
		# Manual falback processing
		print('WARNING, RDFLib failed to load {}, switching to the fallback mode'
			.format(dsname), file=sys.stderr)
		rawSampling(dataset, opts)
		return

	grsubjs = {s for s in gr.subjects()}  # Fetch all unique subjects
	grsubjsNum = len(grsubjs)
	# Show type statistics if required
	if opts.type_stat:
		opts.type_info = True
	if opts.type_info:
		grtypedSubjsNum = len({s for s in gr.subjects(RDF.type)})
		showTypeStat(grtypedSubjsNum, grsubjsNum, dsname, opts.type_stat)

	# Remove all selected subjects from the original graph, which should be more
	# efficient than multiple subsequent selections of the resources
	random.seed(opts.seed)  # Note: None means use system time
	subjs = random.sample(grsubjs, int(grsubjsNum * (1 - opts.ratio)))
	for sb in subjs:
		#ent = Resource(gr, sb)  #URIRef(
		#ent.graph.serialize(file, , format='n3')  # Serialize to the OPENED file!
		gr.remove((sb, None, None))  # Remove all triples with the specified subject
	outfname = os.path.join(opts.outp_dir, dsname)
	gr.serialize(outfname, format='nt')

	print('The random sample of {:G} / {} entities ({:.2%}) are saved in RDF N3/quad format to: {}'
		.format(grsubjsNum * opts.ratio, grsubjsNum, opts.ratio, outfname))


def sample(opts):
	"""Sample RDF dataset according to the specified options"""
	# Validate opts
	if not 0 < opts.ratio < 1:
		raise ValueError('The ratio is out of range (0, 1): ' + str(opts.ratio))
	print('Sampling input parameters are ratio: {}, seed: {}, custom parsing: {}'
		.format(opts.ratio, opts.seed, opts.cust_parse))

	# Perform the sampling of files in the dir
	skiped = []  # The list of skipped irregular files
	updOutpDir = opts.outp_dir == None  # Dynamically reevaluate the output dir
	# Create output directories if they do not exist
	if not updOutpDir and not os.path.exists(opts.outp_dir):
		os.makedirs(opts.outp_dir)
	for dstpl in opts.datasets:
		for dataset in glob.iglob(dstpl):
			if not os.path.isfile(dataset):
				skiped.append(dataset)
				continue
			if updOutpDir:
				path = os.path.split(dataset)[0]
				opts.outp_dir = os.path.join(path, 'samples_s' + str(opts.ratio))
				# Create output directories if they do not exist
				if not os.path.exists(opts.outp_dir):
					os.makedirs(opts.outp_dir)
			sampleFile(dataset, opts)
	if skiped:
		print('WARNING, skipped irregular files: ' + ', '.join(skiped), file=sys.stderr)


if __name__ == '__main__':
	sample(parseArgs())
