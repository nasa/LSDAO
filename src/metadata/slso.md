---
layout: ontology_detail
id: slso
title: Space Life Sciences Ontology
jobs:
  - id: https://travis-ci.org//slso
    type: travis-ci
build:
  checkout: git clone https://github.com/NASA/LSDAO.git
  system: git
  path: "."
contact:
  email: daniel.c.berrios@nasa.gov
  label: POC
  github: DanBerrios
description: The Space Life Sciences Ontology is an application ontology designed to support NASA's Life Sciences Data Archive (LSDA) and the investigation of life sciences in space environments.
domain: Space Life Sciences
homepage: https://github.com/NASA/LSDAO
products:
  - id: slso.owl
    name: "Space Life Sciences Ontology main release in OWL format"
  - id: slso.obo
    name: "Space Life Sciences Ontology additional release in OBO format"
  - id: slso.json
    name: "Space Life Sciences Ontology additional release in OBOJSon format"
  - id: slso/slso-base.owl
    name: "Space Life Sciences Ontology main release in OWL format"
  - id: slso/slso-base.obo
    name: "Space Life Sciences Ontology additional release in OBO format"
  - id: slso/slso-base.json
    name: "Space Life Sciences Ontology additional release in OBOJSon format"
dependencies:
- id: sddo

tracker: https://github.com/NASA/LSDAO/issues
license:
  url: http://creativecommons.org/licenses/by/3.0/
  label: CC-BY
activity_status: active
---

The Space Life Sciences ontology is an application ontology designed to support NASA's Life Science Data Archive, and the fields of space health and biology that support human space exploration.
