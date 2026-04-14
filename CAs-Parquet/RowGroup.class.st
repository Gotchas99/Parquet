Class {
	#name : 'RowGroup',
	#superclass : 'Object',
	#instVars : [
		'total_bytes',
		'num_rows',
		'column_chunks'
	],
	#category : 'CAs-Parquet-Metadata',
	#package : 'CAs-Parquet',
	#tag : 'Metadata'
}

{ #category : 'instance creation' }
RowGroup >> fromDict: aDict [

	self halt.
column_chunks := (aDict at: 1) collect: [ :dict |
		              ColumnChunk new fromDict: dict ].
	total_bytes := aDict at: 2.
	num_rows := aDict at: 3
]

{ #category : 'printing' }
RowGroup >> printOn: aStream [

	super printOn: aStream.
	"aStream
		nextPut: $(;
		nextPutAll: name;
		nextPut: $)"
]
