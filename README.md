# TInfES
Type Inference Evaluation Scripts &amp; Accessory Apps (used for the StaTIX benchmarking)

\authors: (c) Artem Lutov <artem@exascale.info>, [Soheil Roshankish](http://unibe-ch2.academia.edu/SoheilRoshankish/CurriculumVitae)
\license:  [Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0)  
\organization: [eXascale Infolab](http://exascale.info/)  

## Content
- [Overview](#overview)
- [Requirements](#requirements)
- [Usage](#usage)
- [Benchmarking Results](#benchmarking-results)
- [Related Projects](#related-projects)

## Overview

Scripts and accessory Java applications used for the type inference benchmarking of [StaTIX](https://github.com/eXascaleInfolab/StaTIX).

### Scripts

- `evalgt.sh`  - executes the evaluation app ([xmeasures](https://github.com/eXascaleInfolab/xmeasures), [gecmi]((https://github.com/eXascaleInfolab/GenConvNMI)), etc) specified number of times with the specified options on each `*.cnl` file in each specified input directory, evaluating against the <inpdir>_gt.cnl ground-truth.
- `shufrdfs.sh`  - shuffles and reduces input RDF dataset in N-Tripple format to the specified ratio.
- `execfile.sh`  - executes commands from the specified file tracing the resource consumption.
- `mkevaldirs.sh`  - creates directories corresponding to the ground-truth files to put evaluating type inference results there.
- `linkfiles.sh`  - links type inference (clustering) results of the algorithm(s) to the corresponding evaluating directories made by `mkevaldirs.sh`.
- `samplerds.py`  - samples entities of the RDF N-Tripple reducing it to the specified ratio.
- `rdfconvert.py`  - converts input RDF N-Tripple file to id map for the subjects or converts resulting types of SDA(Kenza) algorithm to the unified evaluating CNL format.

### Algorithms

- [StaTIX](https://github.com/eXascaleInfolab/StaTIX)
- [SDA (Semantic Data Aggregator)](https://link.springer.com/chapter/10.1007/978-3-319-25264-3_36). Kellou-Menouer and Zoubida Kedad. 2015. Schema Discovery in RDF Data Sources. In Conceptual Modeling, ER 2015, Stockholm. 481–495.
- [SDType](https://github.com/HeikoPaulheim/sd-type-validate). Heiko Paulheim and Christian Bizer. 2013. Type inference on noisy rdf data. In International Semantic Web Conference. Springer, 510–525.

## Requirements

The scripts require any `POSIX` compatible execution environment (Linux or Unix). Java apps were tested on Java 1.8+.

## Usage

To perform batch execution of the clustering algorithms copy / unpack the required algorithm to the dedicated directory `<algdir>` and link / copy there `scripts/execfile.sh`, `scripts/<algname>.exs`, [exectime](https://bitbucket.org/lumais/exectime/). Update paths in the `<algname>.exs` if required.  
Run the batch execution: `./execfile.sh <algname>.exs`. It produces `evals_<algname>.rcp` containing execution time and memory consumption measurements in the current directory and resulting clusterings (type inference) according to the specified parameters in the `<algname>.exs`.  
Example (run StaTIX in the background):
```sh
$ nohup ./execfile.sh statix_m_rm.exs &>> statix_m_rm.log &
```

To perform batch evaluation of the type inference accuracy, create a dedicated directory `<evals>/` and link / copy there `scripts/evalgt.sh`, `scripts/linkfiles.sh`, `scripts/mkevaldirs.sh`, [xmeasures](https://github.com/eXascaleInfolab/xmeasures), [gecmi](https://github.com/eXascaleInfolab/GenConvNMI) and ground-truth files from the `data/<datasets>_gt` (or produce them). The ground-truth files contain for each #type property space separated subject ids, sequentially enumerated from 0. Run `./mkevaldirs.sh` to create directories that will hold type inference results to be evaluated against the respective ground-truth files. Then run `linkfiles.sh <results_dir>` to link algorithm(s) results to the corresponding directories to be evaluated. And finally run the batch evaluations using `evalgt.sh` script. See `evalgt.sh -h` for details. It produces the required evaluations (`eval_<evalapp-params>.txt` files) in the current directory, which are the accuracy results of the type inference.  
Example:
```sh
# Execute the algorithm(s) to infer the types (clusters)
$ nohup ./execfile.sh statix_m_rm_j_w.exs &>> statix_m_rm_j_w.log &
# Rename and remove directories from the previous mapping if any
$ ./renamedirs.sh _tmp && rm -r *_tmp/
# Make evaluation directories and link the files from the type inference results
$ ./mkevaldirs.sh
$ ./linkfiles.sh ../results/statix/kenzabased/
$ ./linkfiles.sh ../results/statix/biomedical/
$ ./linkfiles.sh ../results/statix/opengov/
# Evaluate results by the required measures
$ ./evalgt.sh ./xmeasures -fh 1 museum soccerplayer country politician film mixen gendr-stat lsr-stat gendr_gene_expression wikipathways-stat genage_human lsr libraries bauhist-fotosamm schools hist_munic_reg &> evals_fh.log
$ nohup ./evalgt.sh ./gecmi 3 museum soccerplayer country politician film mixen gendr-stat lsr-stat gendr_gene_expression wikipathways-stat genage_human lsr libraries bauhist-fotosamm schools hist_munic_reg &> evals_nmi-gecmi.log &
```

## Benchmarking Results

[StaTIX](https://github.com/eXascaleInfolab/StaTIX) in the non-supervised mode with the following parameters:
  - StaTIX: `-f` and the clustering library compiled *without the fast* clusters formation (AggHash);
  - StaTIX-rm: `-f -r m` and the clustering library compiled *without the fast* clusters formation (AggHash);
  - StaTIX-rm-m: `-f -r m -m` and the clustering library compiled *without the fast* clusters formation (AggHash);
  - StaTIX-rm-m-f: `-f -r m -m` and the clustering library compiled with the **fast** clusters formation (AggHash).

### Accuracy
#### [Harmonic F1-Score](https://github.com/eXascaleInfolab/xmeasures) (higher is better)
![F1h](images/F1h_Algs.png)

#### [F1-Measures, Precision and Recall for the labeled types](https://github.com/eXascaleInfolab/xmeasures) (higher is better)
\\ Algorithm | StaTIX | StaTIX-rm | | \StaTIX-rm-m[-f] | | | SDA | | |  SDType | |
--- | :---: | :---: | --- | :---: | ---  | --- | :---: | --- | --- | :---: | --- |
Dataset \\ | F1 | F1 | F1 | P | R | F1 | P | R | F1 | P | R
museum       | 0.866  | 0.866  | 0.866  | 1.000 | 0.763 | 0.539 | 0.380 | 0.927 | 0.209 | 0.120 | 0.785
soccerplayer | 0.789  | 0.789  | 0.789  | 1.000 | 0.652 | 0.695 | 0.574 | 0.882 | 0.447 | 0.339 | 0.657
country      | 0.840  | 0.840  | 0.840  | 1.000 | 0.725 | 0.632 | 0.478 | 0.930 | 0.249 | 0.155 | 0.634
politician   | 0.732  | 0.732  | **0.756** | 0.982 | 0.615 | 0.704 | 0.590 | 0.874 | 0.471 | 0.403 | 0.568
film         | 1.000  | 1.000  | 1.000  | 1.000 | 1.000 | 0.839 | 0.722 | 1.000 | 0.435 | 0.278 | 1.000
mixen        | 0.505  | **0.723**  | **0.751** | 0.869 | 0.662 | 0.559 | 0.412 | 0.873 | 0.378 | 0.360 | 0.398
gendrgene    | 0.806  | 0.806  | 0.806  | 0.757 | 0.861 | 0.889 | 0.987 | 0.809 |       |       |      
lsr          | 0.912  | **0.990**  | 0.990  | 1.000 | 0.981 | 0.998 | 0.996 | 0.999 |       |       |      
bauhist      | 1.000  | 1.000  | 1.000  | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 |       |       |      
schools      | 1.000  | 1.000  | 1.000  | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 |       |       |      
histmunic    | 0.950  | 0.950  | **0.958** | 1.000 | 0.920 |       |       |       |       |       | 

### [Efficiency](https://bitbucket.org/lumais/exectime/)
#### Execution Time (lower is better)
![Execution Time](images/ETime_Algs.png)
#### Memory Consumption (RAM) (lower is better)
![RAM](images/RAM_Algs.png)

**Note:** Please, [star this project](//github.com/eXascaleInfolab/TInfES) if you use it.

## Related Projects

- [StaTIX](https://github.com/eXascaleInfolab/StaTIX)  - Statistical Type Inference (both fully automatic and semi supervised) for RDF datasets in the N-Tripple format.
- [xmeasures](https://github.com/eXascaleInfolab/xmeasures)  - Extrinsic clustering measures evaluation for the multi-resolution clustering with overlaps (covers): F1_gm for overlapping multi-resolution clusterings with possible unequal node base and standard NMI for non-overlapping clustering on a single resolution.
- [GenConvNMI](https://github.com/eXascaleInfolab/GenConvNMI) - Overlapping NMI evaluation that is (unlike `onmi`) compatible with the original NMI and suitable for both overlapping and multi resolution (hierarchical) clusterings.
- [OvpNMI](https://github.com/eXascaleInfolab/OvpNMI) - NMI evaluation method for the overlapping clusters (communities) that is not compatible with the standard NMI value unlike GenConvNMI, but it is much faster than GenConvNMI.
- [ExecTime](https://bitbucket.org/lumais/exectime/)  - A lightweight resource consumption profiler.
- [PyCABeM](https://github.com/eXascaleInfolab/PyCABeM) - Python Benchmarking Framework for the Clustering Algorithms Evaluation. Uses extrinsic (NMIs) and intrinsic (Q) measures for the clusters quality evaluation considering overlaps (nodes membership by multiple clusters).
