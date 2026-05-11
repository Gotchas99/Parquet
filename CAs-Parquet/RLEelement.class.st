Class {
	#name : 'RLEelement',
	#superclass : 'Object',
	#category : 'CAs-Parquet-Core',
	#package : 'CAs-Parquet',
	#tag : 'Core'
}

{ #category : 'as yet unclassified' }
RLEelement >> readFrom: aStream length: dataLen [

	|  header isRLE count val |
	header := VarInt readVarInt: aStream.
	isRLE := (header bitAnd: 1) = 0.
	count := header >> 1.
	val := aStream next.

]
