/*
Preliminaries

Lexical Elements
Language Constructs
Identifiers
Case-Sensitivity

[CQL Railroad Diagrams](http://build.fhir.org/ig/HL7/cql/19-l-cqlsyntaxdiagrams.html)

There are several lexical, syntactic, and semantic errors throughout this library. Correct the errors to
obtain a lexically correct library.
*/
library Exercises01

// # Lexical Errors

/*
// This is a comment
// Whitespace is all the "invisibles" (spaces, tabs, returns)
*/
define "This is a quoted identifier":
  @2021-03-29 + 3 days

define "_1MoreIdentifier":
//cannot start identifier with a number
  0.0 'g'

// # Syntax Errors

define "Inequality Expression":
  4 != 5
  //not equal

define "Relative Comparison Expression":
  4 <= 5
  //no spaces in operator

define "Quantity Expression":
  5' g/dL'
  //UCUM units needs to be in string with ''

// # Semantic Errors

define "Reference Expression":
  "Quantity Expression"
  //identifier is case sensitive

define "String Concatenation":
  '1' + 'John'
  //cannot add integers and strings, have labelled number as string with ''

define "Warning Message":
  Message(1, true, '123', 'Warning', 'This is a warning message')

define "Nested Warning Message":
  1 + Message(2, true, '123', 'Warning', 'The value is 2')
