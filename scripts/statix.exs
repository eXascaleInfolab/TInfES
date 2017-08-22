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
museum_gs0.25		./run.sh -f -g ../input/kenzabased/acsds_s0.25/museum_s0.25.rdf -o ../results/statix/kenzabased/museum_gs0.25.cnl ../input/kenzabased/museum.rdf
soccerplayer_gs0.25	./run.sh -f -g ../input/kenzabased/acsds_s0.25/soccerplayer_s0.25.rdf -o ../results/statix/kenzabased/soccerplayer_gs0.25.cnl ../input/kenzabased/soccerplayer.rdf
country_gs0.25		./run.sh -f -g ../input/kenzabased/acsds_s0.25/country_s0.25.rdf -o ../results/statix/kenzabased/country_gs0.25.cnl ../input/kenzabased/country.rdf
politician_gs0.25	./run.sh -f -g ../input/kenzabased/acsds_s0.25/politician_s0.25.rdf -o ../results/statix/kenzabased/politician_gs0.25.cnl ../input/kenzabased/politician.rdf
film_gs0.25			./run.sh -f -g ../input/kenzabased/acsds_s0.25/film_s0.25.rdf -o ../results/statix/kenzabased/film_gs0.25.cnl ../input/kenzabased/film.rdf
mixen_gs0.25		./run.sh -f -g ../input/kenzabased/acsds_s0.25/mixen_s0.25.rdf -o ../results/statix/kenzabased/mixen_gs0.25.cnl ../input/kenzabased/mixen.rdf
mixenfr_gs0.25		./run.sh -f -g ../input/kenzabased/acsds_s0.25/mixenfr_s0.25.rdf -o ../results/statix/kenzabased/mixenfr_gs0.25.cnl ../input/kenzabased/mixenfr.rdf

# DBPedia as the hinting dataset
museum_gdbp			./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/statix/kenzabased/museum_gdbp.cnl ../input/kenzabased/museum.rdf
soccerplayer_gdbp	./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/statix/kenzabased/soccerplayer_gdbp.cnl ../input/kenzabased/soccerplayer.rdf
country_gdbp		./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/statix/kenzabased/country_gdbp.cnl ../input/kenzabased/country.rdf
politician_gdbp		./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/statix/kenzabased/politician_gdbp.cnl ../input/kenzabased/politician.rdf
film_gdbp			./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/statix/kenzabased/film_gdbp.cnl ../input/kenzabased/film.rdf
mixen_gdbp			./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/statix/kenzabased/mixen_gdbp.cnl ../input/kenzabased/mixen.rdf
mixenfr_gdbp		./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/statix/kenzabased/mixenfr_gdbp.cnl ../input/kenzabased/mixenfr.rdf

# Automatic non supervised evaluations (without the hinting dataset)
museum			./run.sh -f -o ../results/statix/kenzabased/museum.cnl ../input/kenzabased/museum.rdf
soccerplayer	./run.sh -f -o ../results/statix/kenzabased/soccerplayer.cnl ../input/kenzabased/soccerplayer.rdf
country			./run.sh -f -o ../results/statix/kenzabased/country.cnl ../input/kenzabased/country.rdf
politician		./run.sh -f -o ../results/statix/kenzabased/politician.cnl ../input/kenzabased/politician.rdf
film			./run.sh -f -o ../results/statix/kenzabased/film.cnl ../input/kenzabased/film.rdf
mixen			./run.sh -f -o ../results/statix/kenzabased/mixen.cnl ../input/kenzabased/mixen.rdf
mixenfr			./run.sh -f -o ../results/statix/kenzabased/mixenfr.cnl ../input/kenzabased/mixenfr.rdf

# Biomedical datasets ----------------------------------------------------------
# Statistics:
#760K ../input/biomedical/gendr-stat.nq
#1.2M ../input/biomedical/lsr-stat.nq
#1.4M ../input/biomedical/gendr_gene_expression.nq
#2.6M ../input/biomedical/wikipathways-stat.nq
#6.4M ../input/biomedical/genage_human.nq
#9.8M ../input/biomedical/lsr.nq

# Sampled GT (1/4) as the hinting dataset
gendr-stat_gs0.25				./run.sh -f -g ../input/biomedical/acsds_s0.25/gendr-stat_s0.25.nq -o ../results/statix/biomedical/gendr-stat_gs0.25.cnl ../input/biomedical/gendr-stat.nq
lsr-stat_gs0.25					./run.sh -f -g ../input/biomedical/acsds_s0.25/lsr-stat_s0.25.nq -o ../results/statix/biomedical/lsr-stat_gs0.25.cnl ../input/biomedical/lsr-stat.nq
gendr_gene_expression_gs0.25	./run.sh -f -g ../input/biomedical/acsds_s0.25/gendr_gene_expression_s0.25.nq -o ../results/statix/biomedical/gendr_gene_expression_gs0.25.cnl ../input/biomedical/gendr_gene_expression.nq
wikipathways-stat_gs0.25		./run.sh -f -g ../input/biomedical/acsds_s0.25/wikipathways-stat_s0.25.nq -o ../results/statix/biomedical/wikipathways-stat_gs0.25.cnl ../input/biomedical/wikipathways-stat.nq
genage_human_gs0.25				./run.sh -f -g ../input/biomedical/acsds_s0.25/genage_human_s0.25.nq -o ../results/statix/biomedical/genage_human_gs0.25.cnl ../input/biomedical/genage_human.nq
lsr_gs0.25						./run.sh -f -g ../input/biomedical/acsds_s0.25/lsr_s0.25.nq -o ../results/statix/biomedical/lsr_gs0.25.cnl ../input/biomedical/lsr.nq

# DBPedia as the hinting dataset
gendr-stat_gdbp				./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/statix/biomedical/gendr-stat_gdbp.cnl ../input/biomedical/gendr-stat.nq
lsr-stat_gdbp				./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/statix/biomedical/lsr-stat_gdbp.cnl ../input/biomedical/lsr-stat.nq
gendr_gene_expression_gdbp	./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/statix/biomedical/gendr_gene_expression_gdbp.cnl ../input/biomedical/gendr_gene_expression.nq
wikipathways-stat_gdbp		./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/statix/biomedical/wikipathways-stat_gdbp.cnl ../input/biomedical/wikipathways-stat.nq
genage_human_gdbp			./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/statix/biomedical/genage_human_gdbp.cnl ../input/biomedical/genage_human.nq
lsr_gdbp					./run.sh -f -g ../input/dbpedia_3.8_en/mappingbased_properties_en.ttl -o ../results/statix/biomedical/lsr_gdbp.cnl ../input/biomedical/lsr.nq

# Automatic non supervised evaluations (without the hinting dataset)
gendr-stat				./run.sh -f -o ../results/statix/biomedical/gendr-stat.cnl ../input/biomedical/gendr-stat.nq
lsr-stat				./run.sh -f -o ../results/statix/biomedical/lsr-stat.cnl ../input/biomedical/lsr-stat.nq
gendr_gene_expression	./run.sh -f -o ../results/statix/biomedical/gendr_gene_expression.cnl ../input/biomedical/gendr_gene_expression.nq
wikipathways-stat		./run.sh -f -o ../results/statix/biomedical/wikipathways-stat.cnl ../input/biomedical/wikipathways-stat.nq
genage_human			./run.sh -f -o ../results/statix/biomedical/genage_human.cnl ../input/biomedical/genage_human.nq
lsr						./run.sh -f -o ../results/statix/biomedical/lsr.cnl ../input/biomedical/lsr.nq
