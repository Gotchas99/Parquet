Class {
	#name : 'PageEncodingStats',
	#superclass : 'Object',
	#instVars : [
		'page_type',
		'encoding',
		'count'
	],
	#category : 'CAs-Parquet-Core',
	#package : 'CAs-Parquet',
	#tag : 'Core'
}

{ #category : 'instance creation' }
PageEncodingStats >> fromDict: aDict [
	page_type := aDict at: 1.
	encoding := aDict at: 2.
	count := (aDict at: 3)  
]

{ #category : 'printing' }
PageEncodingStats >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(.
aStream 		<< page_type asString<<  encoding  asString<< count asString.
aStream 		nextPut: $)
]
