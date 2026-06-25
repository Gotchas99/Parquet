Class {
	#name : 'EncodingPlain',
	#superclass : 'EncodingRoot',
	#classVars : [
		'Encodings'
	],
	#category : 'CAs-Parquet-Encoding',
	#package : 'CAs-Parquet',
	#tag : 'Encoding'
}

{ #category : 'as yet unclassified' }
EncodingPlain class >> forCode: anInt [

	| suff class |
	suff:=Encodings at: anInt .
	class:= Smalltalk classNamed:('Encoding',suff).
	^class new
	
]

{ #category : 'class initialization' }
EncodingPlain class >> initialize [

	Encodings:= Dictionary newFromPairs:#(0 #Plain 2 #PlainDictionary 3 #Rle 5 DeltaBinary 6 #DeltaLength 7 #DeltaStrings 8 #RleDictionary 9 #ByteStream). 
]
