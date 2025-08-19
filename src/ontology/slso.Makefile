## Customize Makefile settings for slso
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

.PHONY: mirror-dcterms
.PRECIOUS: $(MIRRORDIR)/dcterms.owl
mirror-dcterms: | $(TMPDIR)
	if [ $(MIR) = true ] && [ $(IMP) = true ]; then curl -L http://dublincore.org/2020/01/20/dublin_core_terms.ttl --create-dirs -o $(MIRRORDIR)/dcterms.owl --retry 4 --max-time 200 &&\
		$(ROBOT) convert -i $(MIRRORDIR)/dcterms.owl -o $@.tmp.owl &&\
		mv $@.tmp.owl $(TMPDIR)/$@.owl; fi
		
## ONTOLOGY: chebi
.PHONY: mirror-chebi
.PRECIOUS: $(MIRRORDIR)/chebi.owl
mirror-chebi: | $(TMPDIR)
	if [ $(MIR) = true ] && [ $(IMP) = true ]; then curl -L --connect-timeout 500.0 --max-time 36000 $(URIBASE)/chebi.owl --create-dirs -o $(MIRRORDIR)/chebi.owl && $(ROBOT) convert -i $(MIRRORDIR)/chebi.owl -o $@.tmp.owl && mv $@.tmp.owl $(TMPDIR)/$@.owl; fi

imports/sddo_import.owl:
	if [ $(IMP) = true ]; then cp mirror/sddo.owl imports/sddo_import.owl; fi

imports/exo_import.owl: mirror/exo.owl imports/exo_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) query  -i $< --update ../sparql/preprocess-module.ru \
	extract -T imports/exo_terms_combined.txt --force true --individuals exclude --method BOT \
	query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
	annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi

imports/rbo_import.owl: mirror/rbo.owl imports/rbo_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) query  -i $< --update ../sparql/preprocess-module.ru \
	extract -T imports/rbo_terms_combined.txt --force true --individuals exclude --method BOT \
	query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
	annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi

imports/envo_import.owl: mirror/envo.owl imports/envo_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) extract -i $< -T imports/envo_terms_combined.txt --force true --method BOT \
		remove -t "https://www.wikidata.org/wiki/Q2306597" \
		remove -t "PO:0007033" -t BFO:0000003 --trim false --axioms subclass --signature true --preserve-structure false \
		remove -t "PO:0025337" -t BFO:0000001 --trim false --axioms subclass --signature true --preserve-structure false \
		remove -t "ENVO:01000338" \
		remove -t "PCO:0000001" -t CARO:0001010 --trim false --axioms subclass --signature true --preserve-structure false \
		remove -t "PO:0025337" -t BFO:0000001 --trim false --axioms subclass --signature true --preserve-structure false \
		remove -t "ENVO:01000155" -t CARO:0000000 --trim false --axioms subclass --signature true --preserve-structure false \
		remove -t "ENVO:01000355" -t CARO:0000000 --trim false --axioms subclass --signature true --preserve-structure false \
		remove -t "RO:0002207" -t CL:0000000 --trim false --axioms subclass --signature true --preserve-structure false \
		remove -t "ENVO:01000628" \
		remove -t "CARO:0010000" \
		remove -t "PO:0028002" -t BFO:0000001 --trim false --axioms subclass --signature true --preserve-structure false \
		remove -t "PO:0009012" -t BFO:0000015 --trim false --axioms subclass --signature true --preserve-structure false \
		remove -t "http://purl.obolibrary.org/obo/RO_0002507" -t "http://purl.obolibrary.org/obo/RO_0002508" \
		remove -t "ENVO:02500000" -t BFO:0000001 --trim false --axioms subclass --signature true --preserve-structure false \
		remove -t "ENVO:09200002" -t BFO:0000001 --trim false --axioms subclass --signature true --preserve-structure false \
		remove -t "ENVO:01001174"  --select self --trim true --signature true --preserve-structure false \
		remove -t "http://purl.obolibrary.org/obo/PATO_0001739" -t "IAO:0000115" --axioms annotation --trim false --signature true \
		query --update ../sparql/inject-subset-declaration.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi
		
imports/go_import.owl: mirror/go.owl imports/go_terms_combined.txt
	if [ $(IMP) = true ]; then \
		$(ROBOT) extract -i mirror/go.owl --branch-from-term "obo:GO_0006281"  --force true --method MIREOT --output imports/go_top.tmp.owl && \
		$(ROBOT) query  -i $< --update ../sparql/preprocess-module.ru \
		extract -T imports/go_terms_combined.txt --force true --copy-ontology-annotations true --individuals exclude --method BOT \
		query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && \
		$(ROBOT) merge --input $@.tmp.owl --input imports/go_top.tmp.owl && mv $@.tmp.owl $@; fi

imports/rorio_import.owl: mirror/rorio.owl imports/rorio_terms_combined.txt
	if [ $(IMP) = true ]; then \
		$(ROBOT) query -i $< --update ../sparql/preprocess-module.ru remove --select individuals \
		remove --term rdfs:seeAlso \
		query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && \
		mv $@.tmp.owl $@; fi


imports/vcard_import.owl: 
	if [ $(IMP) = true ]; then cp mirror/vcard.owl imports/vcard_import.owl; fi
	
imports/taxrank_import.owl: 
	if [ $(IMP) = true ]; then cp mirror/taxrank.owl imports/taxrank_import.owl; fi

imports/obi_import.owl: mirror/obi.owl imports/obi_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) extract -i $< -T imports/obi_terms_combined.txt --force true --method BOT --individuals exclude \
    query --update ../sparql/inject-subset-declaration.ru \
    annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && \
    	$(ROBOT) extract -i mirror/obi.owl -branch-from-term  "OBI:0001479" --force true --method MIREOT --output imports/obi_specimentype.tmp.owl && \
	$(ROBOT) merge --input $@.tmp.owl --input imports/obi_specimentype.tmp.owl  --output $@.tmp2.owl && mv $@.tmp2.owl $@; fi

imports/dcterms_import.owl: 
	if [ $(IMP) = true ]; then $(ROBOT) convert --input mirror/dublin_core_terms.ttl --output $@.tmp.owl && mv $@.tmp.owl $@; fi
	
imports/dcat_import.owl: mirror/dcat2.ttl
	if [ $(IMP) = true ]; then $(ROBOT) filter --input $< --base-iri http://www.w3.org/ns/dcat  \
		--select "annotations" --axioms internal --output $@.tmp.ttl && mv $@.tmp.ttl $@; fi
		
imports/sdo_import.owl: mirror/schemaorg.owl
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		extract -T $(IMPORTDIR)/sdo_terms.txt --force true --copy-ontology-annotations true --individuals include --method TOP \
		remove --signature true --select "self descendants" --term https://schema.org/DataType \
		--term https://schema.org/Text \
		--term https://schema.org/URL \
		query --update ../sparql/inject-subset-declaration.ru --update ../sparql/inject-synonymtype-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi

$(IMPORTDIR)/orcidio_terms_combined.txt: $(SRCMERGED)
	$(ROBOT) query -f csv -i $< --query ../sparql/orcids.sparql $@.tmp &&\
	cat $@.tmp | sort | uniq >  $@

imports/ncbitaxon_import.owl: mirror/ncbitaxon.owl imports/ncbitaxon_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) extract -i $< -T imports/ncbitaxon_terms_combined.txt --force true --method BOT \
	annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi

imports/cco_import.owl: mirror/cco.owl imports/cco_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) extract -i $< -T imports/cco_terms_combined.txt --force true --method TOP \
	annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi



#########################################
### Generating all ROBOT templates ######
#########################################

TEMPLATESDIR=./templates

TEMPLATES=$(patsubst %.tsv, $(TEMPLATESDIR)/%.owl, $(notdir $(wildcard $(TEMPLATESDIR)/*.tsv)))

$(TEMPLATESDIR)/%.owl: $(TEMPLATESDIR)/%.tsv $(SRC)
	$(ROBOT) merge -i $(SRC) template --template $< --force true --errors "."  --output $@ && \
	$(ROBOT) annotate --input $@ --ontology-iri $(ONTBASE)/components/$*.owl -o $@
	
components/all_templates.owl: $(TEMPLATES)
	$(ROBOT) merge $(patsubst %, -i %, $^) \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ \
		--output $@.tmp.owl && mv $@.tmp.owl $@
		
templates: $(TEMPLATES)
	echo $(TEMPLATES)
