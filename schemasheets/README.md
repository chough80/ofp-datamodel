# schemasheets/

This folder is the **source of truth** for the `ofp-datamodel` LinkML schema.

Instead of hand-editing `src/ofp_datamodel/schema/ofp_datamodel.yaml` directly, the
schema is authored as a set of spreadsheets (TSV files here, editable in Excel or
Google Sheets), and compiled into that YAML file using
[schemasheets](https://linkml.io/schemasheets/) (`sheets2linkml`).

**Do not hand-edit `src/ofp_datamodel/schema/ofp_datamodel.yaml` directly.** Treat it
like `project/` and `docs/elements/` — a generated artifact. Edits belong here, in
the TSVs.

---

## Why spreadsheets instead of YAML

LinkML schemas are normally written as YAML. Schemasheets exists for people who'd
rather define classes, fields, and enums as spreadsheet rows than write YAML by
hand — useful if non-developers (e.g. a domain expert who isn't comfortable in an
IDE) need to contribute to the model directly.

The tradeoff: spreadsheets can't express every LinkML feature as cleanly as YAML
can, and getting the row/column conventions right takes some care (see
[Gotchas](#gotchas-we-hit-setting-this-up) below). For a schema this small it's a
personal preference; the benefit grows as more people/non-YAML-comfortable
contributors get involved.

---

## The files

| File | Purpose |
|---|---|
| `schema.tsv` | Top-level schema metadata: `id`, `title`, `description`, `default_prefix`, `license`, `see_also`. One row per schema (we only ever have one). |
| `prefixes.tsv` | The prefix map (`linkml:`, `schema:`, `PATO:`, etc.) — equivalent to the `prefixes:` block in LinkML YAML. |
| `classes_slots.tsv` | The bulk of the model: standalone slot definitions (fields), class definitions, and which slots each class uses (including per-class overrides like `pattern`). |
| `classes_meta.tsv` | Class-only properties that can't live in `classes_slots.tsv` — currently `tree_root` and `class_uri`. See [Gotchas](#gotchas-we-hit-setting-this-up) for why this is split out. |
| `enums.tsv` | Enumerations and their permissible values (e.g. `PersonStatus`: `ALIVE` / `DEAD` / `UNKNOWN`), including ontology `meaning` mappings. |

---

## How a schemasheets TSV is structured

Every sheet follows the same three-part shape:

```
<header row>              <- your own column labels, purely cosmetic
> <element type>  <descriptor> <descriptor> ...   <- tells the tool what each column means
<data row>
<data row>
...
```

**Row 1 — header.** Freeform column names, just for human readability. They can be
anything (`class`, `Record`, `Table`, whatever you like).

**Row 2 — descriptor row.** This is the row that actually matters. Its first cell
combines a `>` marker with the *element type* this sheet declares (e.g. `> class`,
`> schema`, `> enum`, `> prefix`). Every other cell in this row names a real LinkML
metaslot (`is_a`, `range`, `slot_uri`, `identifier`, `description`, `multivalued`,
`tree_root`, `class_uri`, `pattern`, ...) — that's what maps column N to LinkML
attribute N for every data row below it.

**Row 3+ — data.** One row per schema element. Leave a cell **truly empty**
(don't put a placeholder like `-` or `n/a`) if that property doesn't apply — see
the first gotcha below.

### How schemasheets decides what a row *is*

In `classes_slots.tsv` there are two "identity" columns: `class` and `slot`.

- **Class column filled, slot column blank** → the row defines a *class*.
- **Class column blank, slot column filled** → the row defines a standalone *slot*
  (field) that can be reused across multiple classes.
- **Both filled** → the row represents that slot's *usage within that specific
  class* — this is where per-class overrides go (e.g. `Person` + `primary_email`
  with a `pattern` column value applies a regex validation only when `primary_email`
  is used on `Person`).

The same idea applies elsewhere: `enums.tsv` uses `enum` + `permissible_value` the
same way (enum alone = the enum itself; both filled = one permissible value).

---

## The day-to-day workflow

1. Edit the TSVs — either directly, or via Excel/Google Sheets:
   - **Google Sheets**: edit online, then `File → Download → Tab Separated Values`
     for each tab, overwriting the matching `.tsv` here.
   - **Excel**: edit, then `File → Save As → Text (Tab delimited) (*.txt)`, rename to
     `.tsv`. Schemasheets has **no direct `.xlsx` support** — TSV is mandatory.
     Watch out for Excel silently "helpfully" reformatting values (e.g. turning
     something like `1-2` into a date) — check the exported TSV before converting.
2. Regenerate the schema YAML from the sheets:
   ```
   just gen-schema-from-sheets
   ```
3. Regenerate everything else downstream (Python, docs, OWL, JSON Schema, etc.), same as always:
   ```
   just gen-project gen-doc
   ```
4. Review the diff (`git diff`) across the TSVs, the regenerated
   `ofp_datamodel.yaml`, `project/`, and `docs/elements/` before committing —
   same discipline as any other schema change.
5. Commit everything together:
   ```
   git add schemasheets/ src/ofp_datamodel/schema/ofp_datamodel.yaml project/ docs/elements/
   git commit -m "..."
   ```

---

## Adding something new to the model

**A new slot (field) used by one class only:**
Add a row to `classes_slots.tsv` with the class filled in, slot filled in, and no
separate standalone-slot row — schemasheets will implicitly create the slot.

**A new slot reused across multiple classes:**
Add one standalone row (class blank, slot filled) to define it, then add one
class+slot usage row per class that uses it.

**A new class:**
Add a row to `classes_slots.tsv` with the class column filled in, slot column
blank, plus `is_a` if it inherits from another class, and a `description`. If it
needs `tree_root` or `class_uri`, add those in `classes_meta.tsv` instead (see
below).

**A new enum:**
Add rows to `enums.tsv` — one row for the enum itself (`permissible_value` blank),
then one row per permissible value, with `meaning` pointing at an ontology term
where possible (e.g. `PATO:0001421`).

---

## Gotchas we hit setting this up

These aren't obvious from the schemasheets docs, so worth knowing before you edit:

1. **Leave cells genuinely blank, not `-` or `n/a`.** schemasheets treats *any*
   non-empty cell as a literal value to assign. Putting `-` as a "nothing here"
   placeholder actually sets that property to the string `"-"` (we hit this —
   it created a class literally named `-` and enum values with `meaning: '-'`).
   Just leave the cell empty.

2. **The `>` marker goes in the same cell as the first descriptor, not a separate
   column.** Row 2's first cell is exactly `> class` (or `> schema`, `> enum`,
   `> prefix`) — one cell, not `>` in one column and `class` in the next.

3. **Class-only and slot-only metaslots can't share a sheet.** Columns like
   `tree_root` and `class_uri` only exist on LinkML classes; columns like
   `multivalued`, `slot_uri`, `pattern`, `identifier` only exist on slots. If a
   sheet mixes both kinds of columns, converting a slot-only row crashes with an
   `AttributeError` because the tool tries to read/set a class-only property on a
   slot object (or vice versa). That's why `tree_root`/`class_uri` live in their
   own `classes_meta.tsv`, using a `class`-only sheet with no `slot` column at all.

4. **Boolean columns expect `True` (capitalized), not `yes`/`true`/`1`.** Used for
   things like `multivalued`, `inlined_as_list`, `tree_root`.

5. **No `.xlsx` support.** Excel/Google Sheets are for *editing*; you must export
   to `.tsv` before running `sheets2linkml`. This is also why we track `.tsv`
   files in git rather than `.xlsx` — Excel binary formats are harder to diff and
   schemasheets' own docs specifically recommend against tracking `.xlsx`.

---

## Bonus tooling that came along for the ride

Installing `schemasheets` pulled in ~30 transitive dependencies (`uv.lock` will
show a large diff for this — that's normal, see below). Most are low-level
plumbing, but a few are genuinely useful capabilities worth knowing about, not
just incidental packaging noise. None of these are set up or in use yet — this is
a reference for later, when/if the use case comes up.

### Live Google Sheets integration (`gspread`, `google-auth`, `google-auth-oauthlib`, `google-api-python-client`)

`sheets2linkml` can read directly from a Google Sheet via its URL/ID using OAuth,
instead of the manual "edit → download as TSV → overwrite the file" step this
project currently uses. Worth setting up if you and a collaborator end up
co-editing a shared live sheet regularly and the manual export step starts to
feel like friction. Requires setting up Google API credentials (OAuth client or
service account) — see [Working with Google Sheets](https://linkml.io/schemasheets/howto/google-sheets/).

### COGS — bidirectional GitHub ↔ Google Sheets sync (`ontodev-cogs`)

[COGS](https://github.com/ontodev/cogs) ("COnfluence of Github and Sheets") goes
further than plain `gspread`: it keeps a GitHub repo and a Google Sheet in two-way
sync — push local TSV changes up to the sheet, pull sheet edits back down,
tracked like git. This is the natural fit if a non-technical collaborator (e.g.
the friend behind the OFP product idea) is actively editing the model on an
ongoing basis, since COGS handles the sync direction and conflict tracking
instead of manual export/import round-trips. Worth evaluating once real
collaborative editing starts.

### Bioregistry — ontology/vocabulary prefix lookup (`bioregistry`)

A registry and resolver for ontology prefixes (in the same family as the `PATO:`
prefix already used in `enums.tsv`). Useful for two things in an
environmental-reporting context like this: finding the correct prefix/URI for a
term you want to reference (e.g. looking up whether there's a standard prefix for
a GHG Protocol or emissions-related ontology), and validating that a `meaning:`
mapping in an enum actually resolves to a real, registered term rather than a
typo'd CURIE. See [bioregistry.io](https://bioregistry.io/).

### Daff — readable tabular diffs (`daff`)

Produces human-readable diffs of CSV/TSV data (highlighting added/changed/removed
cells, not raw line-by-line text diffs). Could replace `git diff` for reviewing
what actually changed in a TSV between two edits, especially useful once sheets
grow beyond a handful of rows. See [paulfitz/daff](https://github.com/paulfitz/daff).

### Real email validation (`email-validator`, `dnspython`)

Format *and* DNS/MX-record validation for email addresses — stronger than the
regex `pattern` currently set on `Person.primary_email`. Relevant if Scope 1/2
reporting ever needs to validate a real contact email (e.g. a subcontractor
submission contact) rather than just a plausible-looking string.

### Ontology mapping standard (`sssom-pydantic`)

Pydantic models for [SSSOM](https://mapping-commons.github.io/sssom/) (Simple
Standard for Sharing Ontology Mappings) — a formal way to record mappings between
concepts across standards. Relevant if OFP concepts ever need to be formally
mapped to other standards (e.g. GHG Protocol terms, or concepts from prior OSDU
LinkML work) beyond the informal `exact_mappings` already used in the schema.

### Why `uv.lock` shows such a large diff for one new dependency

`uv.lock` records the *entire* resolved dependency tree — exact versions and
hashes for every direct and transitive package — not just what you explicitly
added. `schemasheets` alone pulls in ~30 packages (mostly the Google Sheets stack
above), so adding one line to `pyproject.toml` can produce a lockfile diff of
several hundred lines. That's expected mechanical bookkeeping, not a sign
something unintended happened — `pyproject.toml`'s diff (one line) is the one
that reflects actual intent.

The remaining packages pulled in (`tabulate`, `termcolor`, `httplib2`,
`protobuf`, `pyasn1`, `pyasn1-modules`, `cryptography`, `python-multipart`,
`more-click`, `uritemplate`, `oauthlib`, `requests-oauthlib`,
`googleapis-common-protos`, `proto-plus`, `google`) are low-level infrastructure
the tools above depend on internally — not things you'd use directly.

---

## Verifying a conversion worked

Before trusting a regenerated schema, it's worth checking it actually compiles and
that existing test data still validates:

```
just gen-python
uv run python -m pytest
just lint
```

If `just lint` reports new warnings you didn't expect, or `pytest` fails to load
`tests/data/valid/*.yaml`, something in the TSV conversion didn't map the way you
intended — check the gotchas above first.

---

## More information

- [Schemasheets documentation](https://linkml.io/schemasheets/)
- [Basics: how rows and columns map to LinkML](https://linkml.io/schemasheets/intro/basics/)
- [Working with Excel](https://linkml.io/schemasheets/howto/excel/)
- [Working with Google Sheets](https://linkml.io/schemasheets/howto/google-sheets/)
