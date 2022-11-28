## Customize Makefile settings for lsdao
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

imports/sddo_import.owl:
	if [ $(IMP) = true ]; then cp mirror/sddo.owl imports/sddo_import.owl; fi
	
imports/vcard_import.owl: 
	if [ $(IMP) = true ]; then cp mirror/vcard.owl imports/vcard_import.owl; fi
	
#imports/dublin_core_terms_import.ttl: 
#	if [ $(IMP) = true ]; then cp mirror/dublin_core_terms.ttl imports/dublin_core_terms_import.ttl; fi
	
imports/dcat_import.owl: mirror/dcat2.ttl
	if [ $(IMP) = true ]; then $(ROBOT) remove --input $< --base-iri http://www.w3.org/ns/dcat  \
		--axioms external convert --output $@.tmp.owl && cp $@.tmp.owl $@; fi

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
