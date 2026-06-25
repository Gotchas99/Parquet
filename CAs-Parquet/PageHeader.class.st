Class {
	#name : 'PageHeader',
	#superclass : 'Object',
	#instVars : [
		'pageType',
		'uncompressed_page_size',
		'compressed_page_size',
		'crc',
		'page_header'
	],
	#category : 'CAs-Parquet-Core',
	#package : 'CAs-Parquet',
	#tag : 'Core'
}

{ #category : 'instance creation' }
PageHeader >> fromDict: aDict [
	"DATA_PAGE = 0;
    INDEX_PAGE = 1;
    DICTIONARY_PAGE = 2;
    DATA_PAGE_V2 = 3;"

	pageType := aDict at: 1.
	uncompressed_page_size := aDict at: 2.
	compressed_page_size := aDict at: 3.
	aDict at: 4 ifPresent: [ :val | crc := val ].
	"Bara en av nedanstående är ifylld"
	aDict
		at: 5
		ifPresent: [ :val | page_header := DataPageHeader new fromDict: val ].
	aDict at: 6 ifPresent: [ :val |
			self halt.
			page_header := IndexPageHeader new fromDict: val ].
	aDict
		at: 7
		ifPresent: [ :val |
		page_header := DictionaryPageHeader new fromDict: val ].
	aDict at: 8 ifPresent: [ :val |
			self halt.
			page_header := DataPageHeader_v2 new fromDict: val]
]

{ #category : 'testing' }
PageHeader >> isData [
	"0 is DataPage"

	^ pageType = 0
]

{ #category : 'testing' }
PageHeader >> isDictionary [
"2 is DictionaryPage"
^pageType =2
]

{ #category : 'accessing' }
PageHeader >> numValues [

^page_header numValues .
]

{ #category : 'printing' }
PageHeader >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: pageType asString;
		nextPut: $).

]

{ #category : 'instance creation' }
PageHeader >> readFrom: s [ 

	| dict |
	dict := Thrift new readStruct: s.
	self fromDict: dict
]

{ #category : 'instance creation' }
PageHeader >> readFrom: s pos: aPos [

	| dict |
	self deprecated: 'sätt pos först och använd readFrom:'.
	s position: aPos.
	dict := Thrift new readStruct: s.
	self fromDict: dict
]
