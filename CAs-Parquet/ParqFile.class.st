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
ParqFile >> file: aFile [
file := aFile asFileReference .
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
