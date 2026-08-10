## Add your own just recipes here. This is imported by the main justfile.

# Overriding recipes from the root justfile by adding a recipe with the same
# name in this file is not possible until a known issue in just is fixed,
# https://github.com/casey/just/issues/2540

# ============== Schemasheets ==============
# Source of truth for the schema is now schemasheets/*.tsv, not the YAML
# directly. Edit the TSVs (via Excel/Google Sheets export, or directly),
# then run this to regenerate src/ofp_datamodel/schema/ofp_datamodel.yaml.
# After that, run `just gen-project gen-doc` as usual.

# Regenerate the LinkML schema YAML from schemasheets/*.tsv
[group('model development')]
gen-schema-from-sheets:
  uv run sheets2linkml schemasheets/schema.tsv schemasheets/prefixes.tsv schemasheets/classes_slots.tsv schemasheets/classes_meta.tsv schemasheets/enums.tsv -o {{source_schema_path}}
