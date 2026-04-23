Class {
	#name : 'KeyValue',
	#superclass : 'Object',
	#instVars : [
		'key',
		'value'
	],
	#category : 'CAs-Parquet-Metadata',
	#package : 'CAs-Parquet',
	#tag : 'Metadata'
}

{ #category : 'instance creation' }
KeyValue >> fromDict: aDict [

	key := (aDict at: 1)asString.
	aDict at: 2 ifPresent: [ :val |  (value := val asString)]
]

{ #category : 'printing' }
KeyValue >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: key;
		nextPut: $)
]
