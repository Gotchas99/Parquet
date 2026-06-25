Class {
	#name : 'ColumnChunk',
	#superclass : 'Object',
	#instVars : [
		'file_path',
		'meta_data',
		'dictionaryItems'
	],
	#category : 'CAs-Parquet-Core',
	#package : 'CAs-Parquet',
	#tag : 'Core'
}

{ #category : 'accessing' }
ColumnChunk >> at:index [

	dictionaryItems at:index
]

{ #category : 'accessing' }
ColumnChunk >> dictionaryItems: anOrderedCollection [

	dictionaryItems := anOrderedCollection
]

{ #category : 'accessing' }
ColumnChunk >> dp_filepos [

	^meta_data data_page_offset.
]

{ #category : 'instance creation' }
ColumnChunk >> fromDict: aDict [

	aDict at: 1 ifPresent: [ :val | file_path := val ].
	"Deprecated: Byte offset in file_path to the ColumnMetaData"
	"file_offset := aDict at: 2."
	aDict
		at: 3
		ifPresent: [ :val | meta_data := ColumnMetaData new fromDict: val ].
	aDict at: 4 ifPresent: [ :val | self halt ].
	aDict at: 5 ifPresent: [ :val | self halt ].
	aDict at: 6 ifPresent: [ :val | self halt ].
	aDict at: 7 ifPresent: [ :val | self halt ].
	aDict at: 8 ifPresent: [ :val | self halt ].
	aDict at: 9 ifPresent: [ :val | self halt ]
]

{ #category : 'accessing' }
ColumnChunk >> metadata [ ^meta_data 
]

{ #category : 'accessing' }
ColumnChunk >> name [ 
^meta_data path_in_schema
]

{ #category : 'accessing' }
ColumnChunk >> numValues [

	^ meta_data numValues
]

{ #category : 'printing' }
ColumnChunk >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: meta_data path_in_schema;
		nextPut: $)
]

{ #category : 'accessing' }
ColumnChunk >> schema: aSchemaElement [

	meta_data schema:aSchemaElement
]
