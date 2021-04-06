/*
Queries

Query Structure
Filtering with Where
With Relationships
Without Relationships
Shaping Results with Return
Ordering Results with Sort
*/
library Exercises07

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'

codesystem "LOINC": 'http://loinc.org'
codesystem "ActCode": 'http://terminology.hl7.org/CodeSystem/v3-ActCode'
codesystem "MedicationRequestCategory": 'http://terminology.hl7.org/CodeSystem/medicationrequest-category'
codesystem "ObservationCategory": 'http://terminology.hl7.org/CodeSystem/observation-category'

valueset "Community Medication": 'http://example.org/fhir/ValueSet/community-medication'
valueset "Vital Sign": 'http://example.org/fhir/ValueSet/vital-sign'
valueset "Laboratory": 'http://example.org/fhir/ValueSet/laboratory'

code "Blood Glucose": '2339-0' from "LOINC" display 'Glucose Bld-mCnc'

// Act Codes
code "Inpatient Encounter": 'IMP' from "ActCode" display 'Inpatient Encounter'

/*
Write a query to return only Laboratory results that are final or
amended and have a quantitative result
*/

define "Final or Amended Laboratory Results":
  [Observation: category in "Laboratory"] O
  //use category and Laboratory ValueSet as best practice '
  where O.status in {'final', 'amended' }
  and O.value is Quantity
  //Observations that only have a quanitity

/*
Write a query to return encounters that have a quantitative laboratory result
during the encounter
*/

define "Quantitative Laboratory Encounters":
  [Encounter] E
    with [Observation: category in Laboratory]O
      such that O.status in {'final', 'amended' }
      and O.value is Quantity
      and O.effective as dateTime during E.period
      //Observations that have an effective dateTime during that encounter
      and O.encounter is not null

//Better version:
define "Quantitative Laboratory Encounters (2)":
  [Encounter] E
    with "Final or Amended Laboratory Results" O
    //use the previous query duh
      such that O.effective as dateTime during E.period

/*
Write a query to return encounters that did not have a procedure performed
during the encounter
*/

define "Procedure":
[Procedure]

define "Encounter Without Procedure":
  [Encounter] E
    without [Procedure] P
      such that P.performed as dateTime during E.period

/*
Write a query to return the most recent blood glucose observation
*/

define "Blood Glucose Observations":
  "Final or Amended Laboratory Results" O
      where O.code ~ "Blood Glucose"
      sort by FHIRHelpers.ToDateTime(effective as dateTime) desc

define "Most Recent Blood Glucose":
  First("Blood Glucose Observations")


/*
Write a definition that returns the difference between the two most recent
blood glucose observations
*/

define "Difference Between Two Most Recent Blood Glucose":
