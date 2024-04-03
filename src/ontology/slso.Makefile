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

	
imports/vcard_import.owl: 
	if [ $(IMP) = true ]; then cp mirror/vcard.owl imports/vcard_import.owl; fi

imports/obi_import.owl: mirror/obi.owl imports/obi_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) extract -i $< -T imports/obi_terms_combined.txt --force true --method BOT --individuals exclude \
    query --update ../sparql/inject-subset-declaration.ru \
    annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi

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
