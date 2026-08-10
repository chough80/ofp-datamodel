<a href="https://github.com/linkml/linkml-project-copier"><img src="https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/copier-org/copier/master/img/badge/badge-grayscale-inverted-border-teal.json" alt="Copier Badge" style="max-width:100%;"/></a>

# ofp-datamodel

LinkML data model for Open Footprint-aligned Scope 1/2 emissions reporting

## Documentation Website

[https://ofp-datamodel.terranexus.com.au](https://ofp-datamodel.terranexus.com.au)

## Permanent Identifier

The schema's permanent identifier is [https://w3id.org/terranexus/ofp-datamodel](https://w3id.org/terranexus/ofp-datamodel)
(registered via [perma-id/w3id.org#6522](https://github.com/perma-id/w3id.org/pull/6522)).
This is the stable URI used in every generated representation of the schema
(OWL, JSON-LD, SHACL, etc.) — it redirects to the documentation website above,
and will keep working even if the documentation site's hosting changes in the
future.

## Editing the Schema

The schema is authored as spreadsheets, not hand-written YAML. Edit the TSV
files in [schemasheets/](schemasheets/) (via Excel/Google Sheets export, or
directly), then run:

```
just gen-schema-from-sheets
just gen-project gen-doc
```

`gen-schema-from-sheets` compiles the sheets into
`src/ofp_datamodel/schema/ofp_datamodel.yaml`; `gen-project gen-doc` then
regenerates every downstream representation (Python, OWL, JSON Schema, docs,
etc.) from that YAML, same as usual. See
[schemasheets/README.md](schemasheets/README.md) for the full authoring
workflow, conventions, and gotchas.

## Repository Structure

* [docs/](docs/) - mkdocs-managed documentation
  * [elements/](docs/elements/) - generated schema documentation
  * [CNAME](docs/CNAME) - custom domain for GitHub Pages (do not remove --
    without it, the custom domain gets wiped on every `just deploy`)
* [examples/](examples/) - Examples of using the schema
* [project/](project/) - project files (these files are auto-generated, do not edit)
* [schemasheets/](schemasheets/) - the schema's source of truth (see
  [Editing the Schema](#editing-the-schema) above)
* [src/](src/) - source files
  * [ofp_datamodel](src/ofp_datamodel)
    * [schema/](src/ofp_datamodel/schema) -- LinkML schema, generated from
      [schemasheets/](schemasheets/) (do not edit directly)
    * [datamodel/](src/ofp_datamodel/datamodel) -- generated
      Python datamodel
* [tests/](tests/) - Python tests
  * [data/](tests/data) - Example data

## Developer Tools

There are several pre-defined command-recipes available.
They are written for the command runner [just](https://github.com/casey/just/).
To list all pre-defined commands, run `just` or `just --list`.

## License

Proprietary — all rights reserved. See [LICENSE](LICENSE). This repository is
publicly visible for documentation-hosting purposes only; visibility does not
constitute a license grant.

## Credits

This project uses the template [linkml-project-copier](https://github.com/linkml/linkml-project-copier).
