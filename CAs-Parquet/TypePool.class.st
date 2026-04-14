Class {
	#name : 'TypePool',
	#superclass : 'SharedPool',
	#classVars : [
		'BOOLEAN',
		'BYTE_ARRAY',
		'DOUBLE',
		'FIXED_LEN_BYTE_ARRAY',
		'FLOAT',
		'INT32',
		'INT64'
	],
	#category : 'CAs-Parquet-Metadata',
	#package : 'CAs-Parquet',
	#tag : 'Metadata'
}

{ #category : 'class initialization' }
TypePool class >> initialize [

	BOOLEAN := 0.
	INT32 := 1.
	INT64 := 2.
	DOUBLE := 5.
	FLOAT := 5.
	BYTE_ARRAY := 6.
	FIXED_LEN_BYTE_ARRAY := 7 
]
