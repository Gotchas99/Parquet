Class {
	#name : 'ParqFile',
	#superclass : 'Object',
	#instVars : [
		'file',
		's',
		'footerLength'
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

{ #category : 'as yet unclassified' }
ParqFile >> footer [

	| bytes footer |
	s position: s size - 4 - 4 - footerLength.
	bytes := s next: footerLength.
	footer := ParqFooter new bytes: bytes.
	^ footer
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
	footerLength := s
		                position: s size - 8;
		                nextLittleEndianNumber: 4.

]
