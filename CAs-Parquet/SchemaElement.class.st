Class {
	#name : 'SchemaElement',
	#superclass : 'Object',
	#instVars : [
		'dict',
		'name',
		'type',
		'num_children',
		'type_length',
		'repetition_type',
		'converted_type',
		'scale',
		'precision',
		'field_id',
		'logicalType'
	],
	#pools : [
		'TypePool'
	],
	#category : 'CAs-Parquet-Metadata',
	#package : 'CAs-Parquet',
	#tag : 'Metadata'
}

{ #category : 'documentation' }
SchemaElement >> docs [

	 "/** Data type for this field. Not set if the current element is a non-leaf node */
  1: optional Type type;

  /** If type is FIXED_LEN_BYTE_ARRAY, this is the byte length of the values.
   * Otherwise, if specified, this is the maximum bit length to store any of the values.
   * (e.g. a low cardinality INT col could have this set to 3).  Note that this is
   * in the schema, and therefore fixed for the entire file.
   */
  2: optional i32 type_length;

  /** repetition of the field. The root of the schema does not have a repetition_type.
   * All other nodes must have one */
  3: optional FieldRepetitionType repetition_type;

  /** Name of the field in the schema */
  4: required string name;

  /** Nested fields.  Since thrift does not support nested fields,
   * the nesting is flattened to a single list by a depth-first traversal.
   * The children count is used to construct the nested relationship.
   * This field is not set when the element is a primitive type
   */
  5: optional i32 num_children;

  /**
   * DEPRECATED: When the schema is the result of a conversion from another model.
   * Used to record the original type to help with cross conversion.
   *
   * This is superseded by logicalType.
   */
  6: optional ConvertedType converted_type;

  /**
   * DEPRECATED: Used when this column contains decimal data.
   * See the DECIMAL converted type for more details.
   *
   * This is superseded by using the DecimalType annotation in logicalType.
   */
  7: optional i32 scale
  8: optional i32 precision

  /** When the original schema supports field ids, this will save the
   * original field id in the parquet schema
   */
  9: optional i32 field_id;

  /**
   * The logical type of this SchemaElement
   *
   * LogicalType replaces ConvertedType, but ConvertedType is still required
   * for some logical types to ensure forward-compatibility in format v1.
   */
  10: optional LogicalType logicalType#"
]

{ #category : 'instance creation' }
SchemaElement >> fromDict: aDict [

	dict := aDict.
	"/** Data type for this field. Not set if the current element is a non-leaf node */"
	dict at: 1 ifPresent: [ :val | type := val ].
	"/** If type is FIXED_LEN_BYTE_ARRAY, this is the byte length of the values.
   * Otherwise, if specified, this is the maximum bit length to store any of the values.
   * (e.g. a low cardinality INT col could have this set to 3).  Note that this is
   * in the schema, and therefore fixed for the entire file.
   */"
	dict at: 2 ifPresent: [ :val | type_length := val ].
	"/** repetition of the field. The root of the schema does not have a repetition_type.
   * All other nodes must have one */"
	dict at: 3 ifPresent: [ :val | repetition_type := val ].
	"/** Name of the field in the schema */"
	name := (dict at: 4) asString.
	"/** Nested fields.  Since thrift does not support nested fields,
   * the nesting is flattened to a single list by a depth-first traversal.
   * The children count is used to construct the nested relationship.
   * This field is not set when the element is a primitive type
   */"
	dict at: 5 ifPresent: [ :val | num_children := val ].
	"/**
   * DEPRECATED: When the schema is the result of a conversion from another model.
   * Used to record the original type to help with cross conversion.
   *
   * This is superseded by logicalType.
   */"
	dict at: 6 ifPresent: [ :val | converted_type := val ].
	" /**
   * DEPRECATED: Used when this column contains decimal data.
   * See the DECIMAL converted type for more details.
   *
   * This is superseded by using the DecimalType annotation in logicalType.
   */"
	dict at: 7 ifPresent: [ :val | scale := val ].
	dict at: 8 ifPresent: [ :val | precision := val ].
	"/** When the original schema supports field ids, this will save the
   * original field id in the parquet schema
   */"
	dict at: 9 ifPresent: [ :val | field_id := val ].
	"/**
   * The logical type of this SchemaElement
   *
   * LogicalType replaces ConvertedType, but ConvertedType is still required
   * for some logical types to ensure forward-compatibility in format v1.
   */"
	dict at: 10 ifPresent: [ :val | self traceCr:'LogicalType found'.logicalType := val asString ]
]

{ #category : 'accessing' }
SchemaElement >> name [ ^name
]

{ #category : 'printing' }
SchemaElement >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: name;
		nextPut: $)
]
