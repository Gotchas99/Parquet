Class {
	#name : 'ColumnChunk',
	#superclass : 'Object',
	#instVars : [
		'file_path',
		'file_offset',
		'meta_data'
	],
	#category : 'CAs-Parquet-Metadata',
	#package : 'CAs-Parquet',
	#tag : 'Metadata'
}

{ #category : 'instance creation' }
ColumnChunk >> fromDict: aDict [

	self halt.
	aDict at: 1 ifPresent: [ :val | 	file_path := val].
	file_offset := aDict at: 2.
	meta_data := ColumnMetaData new fromDict: (aDict at: 3).
	" (aDict at: 1) collect: [ :dict |
		                 ColumnChunk new fromDict: dict"
]

{ #category : 'printing' }
ColumnChunk >> printOn: aStream [

	super printOn: aStream
	"aStream
		nextPut: $(;
		nextPutAll: name;
		nextPut: $)"
]
