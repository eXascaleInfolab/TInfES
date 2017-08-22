# Task name			Execution command

# Kenza-based datasets ---------------------------------------------------------
# Statistics:
#340K ../input/kenzabased/museum.rdf
#464K ../input/kenzabased/soccerplayer.rdf
#508K ../input/kenzabased/country.rdf
#828K ../input/kenzabased/politician.rdf
#1.2M ../input/kenzabased/film.rdf
#2.1M ../input/kenzabased/mixen.rdf
#4M ../input/kenzabased/mixenfr.rdf

museum			java -jar kenza.jar ../input/kenzabased/museum.rdf
soccerplayer	java -jar kenza.jar ../input/kenzabased/soccerplayer.rdf
country			java -jar kenza.jar ../input/kenzabased/country.rdf
politician		java -jar kenza.jar ../input/kenzabased/politician.rdf
film			java -jar kenza.jar ../input/kenzabased/film.rdf
mixen			java -jar kenza.jar ../input/kenzabased/mixen.rdf
mixenfr			java -jar kenza.jar ../input/kenzabased/mixenfr.rdf

# Biomedical datasets ----------------------------------------------------------
# Statistics:
#760K ../input/biomedical/gendr-stat.nq
#1.2M ../input/biomedical/lsr-stat.nq
#1.4M ../input/biomedical/gendr_gene_expression.nq
#2.6M ../input/biomedical/wikipathways-stat.nq
#6.4M ../input/biomedical/genage_human.nq
#9.8M ../input/biomedical/lsr.nq

gendr-stat				java -jar kenza.jar ../input/biomedical/gendr-stat.nq
lsr-stat				java -jar kenza.jar ../input/biomedical/lsr-stat.nq
gendr_gene_expression	java -jar kenza.jar ../input/biomedical/gendr_gene_expression.nq
wikipathways-stat		java -jar kenza.jar ../input/biomedical/wikipathways-stat.nq
genage_human			java -jar kenza.jar ../input/biomedical/genage_human.nq
lsr						java -jar kenza.jar ../input/biomedical/lsr.nq
