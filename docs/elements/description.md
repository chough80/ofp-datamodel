---
search:
  boost: 5.0
---

# Slot: description 


_A human-readable description for a thing_



<div data-search-exclude markdown="1">



URI: [schema:description](http://schema.org/description)
<!-- no inheritance hierarchy -->





## Applicable Classes

| Name | Description | Modifies Slot |
| --- | --- | --- |
| [NamedThing](NamedThing.md) | A generic grouping for any identifiable entity |  no  |
| [Person](Person.md) | Represents a Person |  no  |






## Properties

### Type and Range

| Property | Value |
| --- | --- |
| Range | [String](String.md) |
| Domain Of | [NamedThing](NamedThing.md) |
| Slot URI | [schema:description](http://schema.org/description) |

### Cardinality and Requirements

| Property | Value |
| --- | --- |










## Identifier and Mapping Information





### Schema Source


* from schema: https://w3id.org/TerraneXus/ofp-datamodel




## Mappings

| Mapping Type | Mapped Value |
| ---  | ---  |
| self | schema:description |
| native | ofp_datamodel:description |




## LinkML Source

<details>
```yaml
name: description
description: A human-readable description for a thing
from_schema: https://w3id.org/TerraneXus/ofp-datamodel
rank: 1000
slot_uri: schema:description
domain_of:
- NamedThing
range: string

```
</details></div>