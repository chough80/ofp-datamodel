---
search:
  boost: 5.0
---

# Slot: name 


_A human-readable name for a thing_



<div data-search-exclude markdown="1">



URI: [schema:name](http://schema.org/name)
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
| Slot URI | [schema:name](http://schema.org/name) |

### Cardinality and Requirements

| Property | Value |
| --- | --- |










## Identifier and Mapping Information





### Schema Source


* from schema: https://w3id.org/TerraneXus/ofp-datamodel




## Mappings

| Mapping Type | Mapped Value |
| ---  | ---  |
| self | schema:name |
| native | ofp_datamodel:name |




## LinkML Source

<details>
```yaml
name: name
description: A human-readable name for a thing
from_schema: https://w3id.org/TerraneXus/ofp-datamodel
rank: 1000
slot_uri: schema:name
domain_of:
- NamedThing
range: string

```
</details></div>