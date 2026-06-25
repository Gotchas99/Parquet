Class {
	#name : 'DataPage',
	#superclass : 'Object',
	#instVars : [
		'chunk',
		'metadata',
		'pageHeader'
	],
	#category : 'CAs-Parquet-Core',
	#package : 'CAs-Parquet',
	#tag : 'Core'
}

{ #category : 'accessing' }
DataPage >> chunk: aColumnChunk [

	chunk := aColumnChunk.
	self metadata: chunk metadata.
]

{ #category : 'accessing' }
DataPage >> metadata: aColumnMetadata [ 
metadata :=aColumnMetadata
]

{ #category : 'accessing' }
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
DataPage >> readDictionaryFrom: aStream [

	| method block numValues res |
	self halt.
	metadata logicalType = #STRING ifTrue: [ method := #readStringFrom: ].
	self assert: method isNotNil.
	block := [ self perform: method with: aStream ].
	numValues := pageHeader numValues.
	res := OrderedCollection streamContents: [ :s |
		       numValues timesRepeat: [ s nextPut: block value ] ].^res
]

{ #category : 'instance creation' }
DataPage >> readFrom: aStream [

	| numValues res method block |
	self assert: metadata isNotNil.
	"repetition level måste vara 0"
	self assert: metadata schema mrl = 0.

	pageHeader := PageHeader new readFrom: aStream.
	pageHeader isDictionary ifTrue: [
			chunk dictionaryItems: (self readDictionaryFrom: aStream).
			res := #(  ) ]. 
	pageHeader isData ifTrue: [
			metadata schema isOptional ifTrue: [
				self readNullMaskFrom: aStream ].
			metadata logicalType = #STRING ifTrue: [
				method := #readStringFrom: ].
			self assert: method isNotNil.
			block := [ self perform: method with: aStream ].
			numValues := pageHeader numValues.
			res := OrderedCollection streamContents: [ :s |
				       numValues timesRepeat: [ s nextPut: block value ] ] ].
	^ res
]

{ #category : 'as yet unclassified' }
DataPage >> readNullMaskFrom: aStream [

	| len rle |
	"length in bytes"
	len:= aStream nextLittleEndianNumber:4.
	rle:= RLEelement new readFrom: aStream length: len.
	
]

{ #category : 'instance creation' }
DataPage >> readPageHeaderFrom: aStream [

 
self halt.
	pageHeader := PageHeader new readFrom: aStream.

	
]

{ #category : 'as yet unclassified' }
DataPage >> readStringFrom: aStream [

	| tmp |
	tmp := (self readByteArrayFrom: aStream) asString.
	^ tmp
]
