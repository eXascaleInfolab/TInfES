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

# Sampled GT (1/4) as the hinting dataset
museum_gs0.25		./run.sh -f -g ../input/kenzabased/acsds_s0.25/museum_s0.25.rdf -o ../results/kenzabased/museum_gs0.25.cnl ../input/kenzabased/museum.rdf
soccerplayer_gs0.25	./run.sh -f -g ../input/kenzabased/acsds_s0.25/soccerplayer_s0.25.rdf -o ../results/kenzabased/soccerplayer_gs0.25.cnl ../input/kenzabased/soccerplayer.rdf
country_gs0.25		./run.sh -f -g ../input/kenzabased/acsds_s0.25/country_s0.25.rdf -o ../results/kenzabased/country_gs0.25.cnl ../input/kenzabased/country.rdf
politician_gs0.25	./run.sh -f -g ../input/kenzabased/acsds_s0.25/politician_s0.25.rdf -o ../results/kenzabased/politician_gs0.25.cnl ../input/kenzabased/politician.rdf
film_gs0.25			./run.sh -f -g ../input/kenzabased/acsds_s0.25/film_s0.25.rdf -o ../results/kenzabased/film_gs0.25.cnl ../input/kenzabased/film.rdf
mixen_gs0.25		./run.sh -f -g ../input/kenzabased/acsds_s0.25/mixen_s0.25.rdf -o ../results/kenzabased/mixen_gs0.25.cnl ../input/kenzabased/mixen.rdf
mixenfr_gs0.25		./run.sh -f -g ../input/kenzabased/acsds_s0.25/mixenfr_s0.25.rdf -o ../results/kenzabased/mixenfr_gs0.25.cnl ../input/kenzabased/mixenfr.rdf

# DBPedia as the hinting dataset
museum_gdbp			./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/kenzabased/museum_gdbp.cnl ../input/kenzabased/museum.rdf
soccerplayer_gdbp	./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/kenzabased/soccerplayer_gdbp.cnl ../input/kenzabased/soccerplayer.rdf
country_gdbp		./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/kenzabased/country_gdbp.cnl ../input/kenzabased/country.rdf
politician_gdbp		./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/kenzabased/politician_gdbp.cnl ../input/kenzabased/politician.rdf
film_gdbp			./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/kenzabased/film_gdbp.cnl ../input/kenzabased/film.rdf
mixen_gdbp			./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/kenzabased/mixen_gdbp.cnl ../input/kenzabased/mixen.rdf
mixenfr_gdbp		./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/kenzabased/mixenfr_gdbp.cnl ../input/kenzabased/mixenfr.rdf

# Automatic non supervised evaluations (without the hinting dataset)
museum			./run.sh -f -o ../results/kenzabased/museum.cnl ../input/kenzabased/museum.rdf
soccerplayer	./run.sh -f -o ../results/kenzabased/soccerplayer.cnl ../input/kenzabased/soccerplayer.rdf
country			./run.sh -f -o ../results/kenzabased/country.cnl ../input/kenzabased/country.rdf
politician		./run.sh -f -o ../results/kenzabased/politician.cnl ../input/kenzabased/politician.rdf
film			./run.sh -f -o ../results/kenzabased/film.cnl ../input/kenzabased/film.rdf
mixen			./run.sh -f -o ../results/kenzabased/mixen.cnl ../input/kenzabased/mixen.rdf
mixenfr			./run.sh -f -o ../results/kenzabased/mixenfr.cnl ../input/kenzabased/mixenfr.rdf

# Biomedical datasets ----------------------------------------------------------
# Statistics:
#760K ../input/biomedical/gendr-stat.nq
#1.2M ../input/biomedical/lsr-stat.nq
#1.4M ../input/biomedical/gendr_gene_expression.nq
#2.6M ../input/biomedical/wikipathways-stat.nq
#6.4M ../input/biomedical/genage_human.nq
#9.8M ../input/biomedical/lsr.nq

# Sampled GT (1/4) as the hinting dataset
gendr-stat_gs0.25				./run.sh -f -g ../input/biomedical/acsds_s0.25/gendr-stat_s0.25.nq -o ../results/biomedical/gendr-stat_gs0.25.cnl ../input/biomedical/gendr-stat.nq
lsr-stat_gs0.25					./run.sh -f -g ../input/biomedical/acsds_s0.25/lsr-stat_s0.25.nq -o ../results/biomedical/lsr-stat_gs0.25.cnl ../input/biomedical/lsr-stat.nq
gendr_gene_expression_gs0.25	./run.sh -f -g ../input/biomedical/acsds_s0.25/gendr_gene_expression_s0.25.nq -o ../results/biomedical/gendr_gene_expression_gs0.25.cnl ../input/biomedical/gendr_gene_expression.nq
wikipathways-stat_gs0.25		./run.sh -f -g ../input/biomedical/acsds_s0.25/wikipathways-stat_s0.25.nq -o ../results/biomedical/wikipathways-stat_gs0.25.cnl ../input/biomedical/wikipathways-stat.nq
genage_human_gs0.25				./run.sh -f -g ../input/biomedical/acsds_s0.25/genage_human_s0.25.nq -o ../results/biomedical/genage_human_gs0.25.cnl ../input/biomedical/genage_human.nq
lsr_gs0.25						./run.sh -f -g ../input/biomedical/acsds_s0.25/lsr_s0.25.nq -o ../results/biomedical/lsr_gs0.25.cnl ../input/biomedical/lsr.nq

# DBPedia as the hinting dataset
gendr-stat_gdbp				./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/biomedical/gendr-stat_gdbp.cnl ../input/biomedical/gendr-stat.nq
lsr-stat_gdbp				./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/biomedical/lsr-stat_gdbp.cnl ../input/biomedical/lsr-stat.nq
gendr_gene_expression_gdbp	./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/biomedical/gendr_gene_expression_gdbp.cnl ../input/biomedical/gendr_gene_expression.nq
wikipathways-stat_gdbp		./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/biomedical/wikipathways-stat_gdbp.cnl ../input/biomedical/wikipathways-stat.nq
genage_human_gdbp			./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/biomedical/genage_human_gdbp.cnl ../input/biomedical/genage_human.nq
lsr_gdbp					./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/biomedical/lsr_gdbp.cnl ../input/biomedical/lsr.nq

# Automatic non supervised evaluations (without the hinting dataset)
gendr-stat				./run.sh -f -o ../results/biomedical/gendr-stat.cnl ../input/biomedical/gendr-stat.nq
lsr-stat				./run.sh -f -o ../results/biomedical/lsr-stat.cnl ../input/biomedical/lsr-stat.nq
gendr_gene_expression	./run.sh -f -o ../results/biomedical/gendr_gene_expression.cnl ../input/biomedical/gendr_gene_expression.nq
wikipathways-stat		./run.sh -f -o ../results/biomedical/wikipathways-stat.cnl ../input/biomedical/wikipathways-stat.nq
genage_human			./run.sh -f -o ../results/biomedical/genage_human.cnl ../input/biomedical/genage_human.nq
lsr						./run.sh -f -o ../results/biomedical/lsr.cnl ../input/biomedical/lsr.nq
