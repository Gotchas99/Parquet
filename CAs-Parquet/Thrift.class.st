Class {
	#name : 'Thrift',
	#superclass : 'Object',
	#category : 'CAs-Parquet-Thrift',
	#package : 'CAs-Parquet',
	#tag : 'Thrift'
}

{ #category : 'as yet unclassified' }
Thrift >> readBinary: s [

	| size bytes |
	size := VarInt readVarInt: s.
	bytes := s next: size.
	^ bytes
]

{ #category : 'as yet unclassified' }
Thrift >> readElementFrom: s type: type [

	"type = 6 ifTrue: [ self halt ]."
	(#( 3 4 5 6 ) includes: type) ifTrue: [ ^ VarInt readZigZag: s ].
	type = 8 ifTrue: [ ^ self readBinary: s ].
	type = 9 ifTrue: [ ^ self readList: s ].
	type = 12 ifTrue: [ ^ self readStruct: s ].
	self halt
]

{ #category : 'as yet unclassified' }
Thrift >> readFieldFrom: s type: type [

	 "same as element currently. might change in the future..."
	^self readElementFrom: s type: type
]

{ #category : 'as yet unclassified' }
Thrift >> readList: s [

	| header size type list |
	header := s next.
	type := header & 15.
	size := header >> 4.
	"size hex F means long jump"
	size = 15 ifTrue: [ size := VarInt readVarInt: s ].
	list := OrderedCollection new.
	size timesRepeat: [ list add: (self readElementFrom: s type: type) ].
	^ list
]

{ #category : 'as yet unclassified' }
Thrift >> readStruct: s [

	| header fieldId delta type fields |
	fields := Dictionary new.
	fieldId := 0.
	[ (header := s next) > 0 ] whileTrue: [
			delta := header >> 4.
			type := header & 15.
			"delta 0 means long list"
			fieldId := delta = 0
				           ifTrue: [ VarInt readVarInt: s ]
				           ifFalse: [ fieldId + delta ].
				"1 and 2 are booleans"
			type <= 2
				ifTrue: [ fields at: fieldId put: (type=1)]
				ifFalse: [
				fields at: fieldId put: (self readElementFrom: s type: type) ]  ].
	^ fields
]
