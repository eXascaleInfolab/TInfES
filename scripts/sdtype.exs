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

museum			java -jar SDType.jar ../input/kenzabased/museum.rdf ../input/dbpedia_3.8_en/instance_types_en.ttl ../input/dbpedia_3.8_en/disambiguations_unredirected_en.ttl
soccerplayer	java -jar SDType.jar ../input/kenzabased/soccerplayer.rdf ../input/dbpedia_3.8_en/instance_types_en.ttl ../input/dbpedia_3.8_en/disambiguations_unredirected_en.ttl
country			java -jar SDType.jar ../input/kenzabased/country.rdf ../input/dbpedia_3.8_en/instance_types_en.ttl ../input/dbpedia_3.8_en/disambiguations_unredirected_en.ttl
politician		java -jar SDType.jar ../input/kenzabased/politician.rdf ../input/dbpedia_3.8_en/instance_types_en.ttl ../input/dbpedia_3.8_en/disambiguations_unredirected_en.ttl
film			java -jar SDType.jar ../input/kenzabased/film.rdf ../input/dbpedia_3.8_en/instance_types_en.ttl ../input/dbpedia_3.8_en/disambiguations_unredirected_en.ttl
mixen			java -jar SDType.jar ../input/kenzabased/mixen.rdf ../input/dbpedia_3.8_en/instance_types_en.ttl ../input/dbpedia_3.8_en/disambiguations_unredirected_en.ttl
mixenfr			java -jar SDType.jar ../input/kenzabased/mixenfr.rdf ../input/dbpedia_3.8_en/instance_types_en.ttl ../input/dbpedia_3.8_en/disambiguations_unredirected_en.ttl

# Biomedical datasets ----------------------------------------------------------
# Statistics:
#760K ../input/biomedical/gendr-stat.nq
#1.2M ../input/biomedical/lsr-stat.nq
#1.4M ../input/biomedical/gendr_gene_expression.nq
#2.6M ../input/biomedical/wikipathways-stat.nq
#6.4M ../input/biomedical/genage_human.nq
#9.8M ../input/biomedical/lsr.nq

gendr-stat				java -jar SDType.jar ../input/biomedical/gendr-stat.nq ../input/dbpedia_3.8_en/instance_types_en.ttl ../input/dbpedia_3.8_en/disambiguations_unredirected_en.ttl
lsr-stat				java -jar SDType.jar ../input/biomedical/lsr-stat.nq ../input/dbpedia_3.8_en/instance_types_en.ttl ../input/dbpedia_3.8_en/disambiguations_unredirected_en.ttl
gendr_gene_expression	java -jar SDType.jar ../input/biomedical/gendr_gene_expression.nq ../input/dbpedia_3.8_en/instance_types_en.ttl ../input/dbpedia_3.8_en/disambiguations_unredirected_en.ttl
wikipathways-stat		java -jar SDType.jar ../input/biomedical/wikipathways-stat.nq ../input/dbpedia_3.8_en/instance_types_en.ttl ../input/dbpedia_3.8_en/disambiguations_unredirected_en.ttl
genage_human			java -jar SDType.jar ../input/biomedical/genage_human.nq ../input/dbpedia_3.8_en/instance_types_en.ttl ../input/dbpedia_3.8_en/disambiguations_unredirected_en.ttl
lsr						java -jar SDType.jar ../input/biomedical/lsr.nq ../input/dbpedia_3.8_en/instance_types_en.ttl ../input/dbpedia_3.8_en/disambiguations_unredirected_en.ttl
