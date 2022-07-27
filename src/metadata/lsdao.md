---
layout: ontology_detail
id: lsdao
title: Life Sciences Data Archive Ontology
jobs:
  - id: https://travis-ci.org//lsdao
    type: travis-ci
build:
  checkout: git clone https://github.com//lsdao.git
  system: git
  path: "."
contact:
  email: daniel.c.berrios@nasa.gov
  label: POC
  github: DanBerrios
description: The Life Sciences Data Archive Ontology is an application ontology designed to support NASA's Life Sciences Data Archive (LSDA) and the investigation of life sciences in space environments.
domain: Space Life Sciences
homepage: https://github.com//lsdao
products:
  - id: lsdao.owl
    name: "Life Sciences Data Archive Ontology main release in OWL format"
  - id: lsdao.obo
    name: "Life Sciences Data Archive Ontology additional release in OBO format"
  - id: lsdao.json
    name: "Life Sciences Data Archive Ontology additional release in OBOJSon format"
  - id: lsdao/lsdao-base.owl
    name: "Life Sciences Data Archive Ontology main release in OWL format"
  - id: lsdao/lsdao-base.obo
    name: "Life Sciences Data Archive Ontology additional release in OBO format"
  - id: lsdao/lsdao-base.json
    name: "Life Sciences Data Archive Ontology additional release in OBOJSon format"
dependencies:
- id: sddo

tracker: https://github.com//lsdao/issues
license:
  url: http://creativecommons.org/licenses/by/3.0/
  label: CC-BY
activity_status: active
---

The Life Sciences Data Archive ontology is an application ontology designed to support NASA's Life Science Data Archive, and the fields of space health and biology that support human space exploration.
