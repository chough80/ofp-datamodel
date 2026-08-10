---
search:
  boost: 5.0
---

# Slot: birth_date 


_Date on which a person is born_



<div data-search-exclude markdown="1">



URI: [schema:birthDate](http://schema.org/birthDate)
<!-- no inheritance hierarchy -->





## Applicable Classes

| Name | Description | Modifies Slot |
| --- | --- | --- |
| [Person](Person.md) | Represents a Person |  no  |






## Properties

### Type and Range

| Property | Value |
| --- | --- |
| Range | [Date](Date.md) |
| Domain Of | [Person](Person.md) |
| Slot URI | [schema:birthDate](http://schema.org/birthDate) |

### Cardinality and Requirements

| Property | Value |
| --- | --- |










## Identifier and Mapping Information





### Schema Source


* from schema: https://w3id.org/TerraneXus/ofp-datamodel




## Mappings

| Mapping Type | Mapped Value |
| ---  | ---  |
| self | schema:birthDate |
| native | ofp_datamodel:birth_date |




## LinkML Source

<details>
```yaml
name: birth_date
description: Date on which a person is born
from_schema: https://w3id.org/TerraneXus/ofp-datamodel
rank: 1000
slot_uri: schema:birthDate
domain_of:
- Person
range: date

```
</details></div>