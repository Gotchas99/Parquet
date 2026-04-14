Class {
	#name : 'VarInt',
	#superclass : 'Object',
	#category : 'CAs-Parquet-Thrift',
	#package : 'CAs-Parquet',
	#tag : 'Thrift'
}

{ #category : 'converting' }
VarInt class >> decodeZigZag: anInt [
	"(n >> 1) ^ (-(n & 1))"

	| zag |
	zag := (anInt bitShift: -1) bitXor: (anInt bitAnd: 1) negated.
	" annan impl:
	zag := anInt bitShift: 1.
	anInt < 0 ifTrue: [ zag := zag negated - 1 ]."
	^ zag
]

{ #category : 'converting' }
VarInt class >> encode: anInt [

	| zag  uleb |
	zag := self encodeZigZag: anInt .
	uleb:= self encodeULEB128: zag.
		^uleb
]

{ #category : 'converting' }
VarInt class >> encodeULEB128: anInt [

	| rest barr next |
	rest := anInt .
	barr := ByteArray streamContents: [ :out |
			        [
				        next := rest bitAnd: 127.
				        rest := rest bitShift: -7.
				        rest > 0 ifTrue: [ next := next bitOr: 128 ].
				        out << next ] doWhileTrue: [ rest > 0 ] ].
	^ barr
]

{ #category : 'converting' }
VarInt class >> encodeZigZag: anInt [
"(n >> 1) ^ (-(n & 1))"
	| zag |
	zag := (anInt bitShift: 1)bitXor: ((anInt bitAnd: 1)negated ).
	" annan impl:
	zag := anInt bitShift: 1.
	anInt < 0 ifTrue: [ zag := zag negated - 1 ]."
	^ zag
]

{ #category : 'as yet unclassified' }
VarInt class >> putInt: anInt on: s [

	s << (self encode: anInt )
]

{ #category : 'as yet unclassified' }
VarInt class >> readInt: s [

	| next uleb zag off |
	self deprecated:'dont use'.
	uleb := 0.
	off := 0.
	[
		next := s next.
		uleb := next & 127 + (uleb << off).
		next & 128 > 0 ] whileTrue: [ off := off + 7 ].
	zag := self decodeZigZag: uleb.
	^ zag
]

{ #category : 'as yet unclassified' }
VarInt class >> readVarInt: s [

	| next uleb off |
	uleb := 0.
	off := 0.
	[
		next := s next.
		uleb := (next & 127 )<< off + (uleb ).
		next & 128 > 0 ] whileTrue: [ off := off + 7 ].
	^ uleb
]

{ #category : 'as yet unclassified' }
VarInt class >> readZigZag: s [

	|   zag  |
	zag := self decodeZigZag: (self readVarInt: s).
	^ zag
]
