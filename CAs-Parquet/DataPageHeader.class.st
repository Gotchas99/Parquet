Class {
	#name : 'DataPageHeader',
	#superclass : 'Object',
	#instVars : [
		'num_values',
		'encoding',
		'definition_level_encoding',
		'repetition_level_encoding',
		'statistics'
	],
	#category : 'CAs-Parquet-Core',
	#package : 'CAs-Parquet',
	#tag : 'Core'
}

{ #category : 'accessing' }
DataPageHeader >> encoding [ self assert: (encoding =0).^encoding 
]

{ #category : 'instance creation' }
DataPageHeader >> fromDict: aDict [

	num_values := aDict at: 1.
	"Encodings:
	PLAIN = 0;
	PLAIN_DICTIONARY = 2;
	RLE = 3;
	BIT_PACKED = 4;"
	encoding := aDict at: 2.
	self assert: encoding = 0.
	definition_level_encoding := aDict at: 3.
	repetition_level_encoding := aDict at: 4.
	aDict
		at: 5
		ifPresent: [ :val | statistics := Statistics new fromDict: val ]
]

{ #category : 'accessing' }
DataPageHeader >> numValues [ ^num_values 

]
