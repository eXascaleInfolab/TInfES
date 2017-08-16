# TInfES
Type Inference Evaluation Scripts &amp; Accessory Apps (used for the StaTIX benchmarking)

## Content
- [Overview](#overview)
- [Requirements](#requirements)
- [Usage](#usage)

## Overview

Scripts and accessory Java applications used for the type inference benchmarking of [StaTIX](https://github.com/eXascaleInfolab/StaTIX).

### Scripts

- `evalgt.sh`  - executes the evaluation app ([xmeasures](https://github.com/eXascaleInfolab/xmeasures), [gecmi]((https://github.com/eXascaleInfolab/GenConvNMI)), etc) specified number of times with the specified options on each `*.cnl` file in each specified input directory, evaluating against the <inpdir>_gt.cnl ground-truth.
- `shufrdfs.sh`  - shuffles and reduces input RDF dataset in N3 format to the specified ratio.
- `execfile.sh`  - executes commands from the specified file tracing the resource consumption.

## Requirements

The scripts require any `POSIX` compatible execution environment (Linux or Unix). Java apps were tested on Java 1.8+.

## Related Projects

- [xmeasures](https://github.com/eXascaleInfolab/xmeasures)  - Extrinsic clustering measures evaluation for the multi-resolution clustering with overlaps (covers): F1_gm for overlapping multi-resolution clusterings with possible unequal node base and standard NMI for non-overlapping clustering on a single resolution.
- [GenConvNMI](https://github.com/eXascaleInfolab/GenConvNMI) - Overlapping NMI evaluation that is (unlike `onmi`) compatible with the original NMI and suitable for both overlapping and multi resolution (hierarchical) clusterings.
- [ExecTime](https://bitbucket.org/lumais/exectime/)  - A lightweight resource consumption profiler.
- [PyCABeM](https://github.com/eXascaleInfolab/PyCABeM) - Python Benchmarking Framework for the Clustering Algorithms Evaluation. Uses extrinsic (NMIs) and intrinsic (Q) measures for the clusters quality evaluation considering overlaps (nodes membership by multiple clusters).
