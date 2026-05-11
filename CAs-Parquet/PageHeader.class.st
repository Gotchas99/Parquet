Class {
	#name : 'PageHeader',
	#superclass : 'Object',
	#instVars : [
		'uncompressed_page_size',
		'compressed_page_size',
		'crc',
		'data_page_header',
		'index_page_header',
		'dictionary_page_header',
		'pageType'
	],
	#category : 'CAs-Parquet-Metadata',
	#package : 'CAs-Parquet',
	#tag : 'Metadata'
}

{ #category : 'as yet unclassified' }
PageHeader >> dataPageHeader [ ^data_page_header
]

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
		ifPresent: [ :val |
		data_page_header := DataPageHeader new fromDict: val ].
	aDict at: 6 ifPresent: [ :val | self halt ].
	aDict at: 7 ifPresent: [ :val | self halt ].
	aDict at: 8 ifPresent: [ :val | self halt ]
]

{ #category : 'instance creation' }
PageHeader >> readFrom: s pos: aPos [

	| dict |
	s position: aPos.
	dict := Thrift new readStruct: s.
	self fromDict: dict.
]
