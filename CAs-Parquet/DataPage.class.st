Class {
	#name : 'DataPage',
	#superclass : 'Object',
	#instVars : [
		'metadata',
		'pageHeader'
	],
	#category : 'CAs-Parquet-Core',
	#package : 'CAs-Parquet',
	#tag : 'Core'
}

{ #category : 'instance creation' }
DataPage >> metadata: aColumnMetadata [ 
metadata :=aColumnMetadata
]

{ #category : 'instance creation' }
DataPage >> pageHeader: aPageHeader [

	pageHeader := aPageHeader 
]

{ #category : 'as yet unclassified' }
DataPage >> readByteArrayFrom: aStream [

	| len tmp |
	len := aStream nextLittleEndianNumber: 4.
	tmp := aStream next: len.
	^ tmp
]

{ #category : 'instance creation' }
DataPage >> readFrom: aStream [

	| numValues res method block |
	self assert: metadata isNotNil.
	"repetition level måste vara 0"
	self assert: metadata schema mrl = 0.

	method:=#halt.
	metadata schema isOptional ifTrue: [ self readNullMaskFrom: aStream ].
	metadata logicalType = #STRING ifTrue: [ method := #readStringFrom: ].
	block := [ self perform: method with: aStream ].
	numValues := pageHeader dataPageHeader numValues. 
	res := OrderedCollection streamContents: [ :s |
		       numValues timesRepeat: [ s nextPut: block value ] ].
	^res
]

{ #category : 'as yet unclassified' }
DataPage >> readNullMaskFrom: aStream [

	| len rle |
	"length in bytes"
	len:= aStream nextLittleEndianNumber:4.
	rle:= RLEelement new readFrom: aStream length: len.
	
]

{ #category : 'as yet unclassified' }
DataPage >> readStringFrom: aStream [

	| tmp |
	tmp := (self readByteArrayFrom: aStream) asString.
	^ tmp
]
