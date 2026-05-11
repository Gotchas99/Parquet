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

{ #category : 'rendering' }
ParqFile >> columnNames [

	| cols |
	cols := metadata schema allButFirst collect: [ :c | c name ]. ^cols
]

{ #category : 'accessing' }
ParqFile >> file: aFile [
file := aFile asFileReference .
]

{ #category : 'rendering' }
ParqFile >> getColumns: colList [

	| c chunk ph dp res |
	"bara första kolumen för nu"
	c := colList first.
	chunk := (metadata chunksFor: c) first.
	chunk schema: (metadata schemaForName: c).

	ph := PageHeader new readFrom: s pos: chunk dp_filepos.
	dp := DataPage new.
	dp metadata: chunk metadata.
	dp pageHeader: ph.
	res := dp readFrom: s.
	^ res
]

{ #category : 'accessing' }
ParqFile >> metadata [


	^ metadata
]

{ #category : 'accessing' }
ParqFile >> open [

	s := file binaryReadStream.
	self assert: (s
			 position: 0;
			 next: 4) asString = 'PAR1'.
	self assert: (s
			 position: s size - 4;
			 next: 4) asString = 'PAR1'.
	self readMetadata.

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
