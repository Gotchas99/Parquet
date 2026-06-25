Class {
	#name : 'ParqFile',
	#superclass : 'Object',
	#instVars : [
		'file',
		's',
		'metadata'
	],
	#category : 'CAs-Parquet-Core',
	#package : 'CAs-Parquet',
	#tag : 'Core'
}

{ #category : 'accessing' }
ParqFile >> close [ 
s ifNotNil:[s close.s := nil]
]

{ #category : 'accessing' }
ParqFile >> columnNames [

	| cols |
	cols := metadata schema allButFirst collect: [ :c | c name ]. ^cols
]

{ #category : 'accessing' }
ParqFile >> file: aFile [
file := aFile asFileReference .
]

{ #category : 'accessing' }
ParqFile >> getColumn: colName [

	| chunk dp res readValues tmp |
	chunk := (metadata chunksFor: colName) first.
	chunk schema: (metadata schemaForName: colName).
	s position: chunk dp_filepos.
	readValues:=0.
	res:=OrderedCollection new.
self halt.
	[ readValues<chunk numValues ]whileTrue: [
	dp := DataPage new.
	dp chunk: chunk.
	tmp:= dp readFrom: s.
	readValues :=readValues+tmp size.
	res append:tmp. ].
	"ds := DataSeries withValues: res name: colName."
	^ res
]

{ #category : 'accessing' }
ParqFile >> getColumns: colList [

	| res df |
	self assert: metadata isNotNil.
	s := self stream.
	res := colList collect: [ :col | self getColumn: col ].
	df := DataFrame withColumns: res columnNames: colList.
	self close.
	^ df
]

{ #category : 'accessing' }
ParqFile >> metadata [


	^ metadata
]

{ #category : 'accessing' }
ParqFile >> open [

	s := self stream.
	self assert: (s
			 position: 0;
			 next: 4) asString = 'PAR1'.
	self assert: (s
			 position: s size - 4;
			 next: 4) asString = 'PAR1'.
	self readMetadata.
	self close
]

{ #category : 'accessing' }
ParqFile >> readMetadata [

	| bytes footerLength |
	footerLength := s
		                position: s size - 8;
		                nextLittleEndianNumber: 4.
	s position: s size - 4 - 4 - footerLength.
	bytes := s next: footerLength.
	metadata := FileMetaData new bytes: bytes.
	^ metadata
]

{ #category : 'accessing' }
ParqFile >> stream [

	s := file binaryReadStream.
	^s
]
