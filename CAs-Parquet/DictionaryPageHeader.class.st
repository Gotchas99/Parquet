Class {
	#name : 'DictionaryPageHeader',
	#superclass : 'Object',
	#instVars : [
		'num_values',
		'encoding',
		'is_sorted'
	],
	#category : 'CAs-Parquet-Core',
	#package : 'CAs-Parquet',
	#tag : 'Core'
}

{ #category : 'accessing' }
DictionaryPageHeader >> encoding [

	self assert: encoding = 2.
	^ encoding
]

{ #category : 'instance creation' }
DictionaryPageHeader >> fromDict: aDict [

	num_values := aDict at: 1.
	"Encodings:
	PLAIN = 0;
	PLAIN_DICTIONARY = 2;
	RLE = 3;
	BIT_PACKED = 4;" 
	encoding := aDict at: 2.
	self assert: (#( 2 3 ) includes: encoding).
	aDict at: 3 ifPresent: [ :val | is_sorted := val ]
]

{ #category : 'accessing' }
DictionaryPageHeader >> numValues [

	^ num_values
]
