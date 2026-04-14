"
A ZigZagTest is a test class for testing the behavior of ZigZag
"
Class {
	#name : 'ZigZagTest',
	#superclass : 'TestCase',
	#category : 'CAs-Parquet-Tests-Thrift',
	#package : 'CAs-Parquet-Tests',
	#tag : 'Thrift'
}

{ #category : 'as yet unclassified' }
ZigZagTest >> testEncode0 [

	| res exp |
	res := VarInt encode: 0.
	exp := ByteArray readHexFrom: '00'.
	self assert: res equals: exp
]

{ #category : 'as yet unclassified' }
ZigZagTest >> testEncode1 [

	| res exp |
	res := VarInt encode: 1.
	exp := ByteArray readHexFrom: '02'.
	self assert: res equals: exp
]

{ #category : 'as yet unclassified' }
ZigZagTest >> testEncode2 [

	| res exp |
	res := VarInt encode: 2.
	exp := ByteArray readHexFrom: '04'.
	self assert: res equals: exp
]

{ #category : 'as yet unclassified' }
ZigZagTest >> testEncode3 [

	| res exp |
	res := VarInt encode: 3.
	exp := ByteArray readHexFrom: '06'.
	self assert: res equals: exp
]

{ #category : 'as yet unclassified' }
ZigZagTest >> testEncodeNeg5 [

	| res exp |
	res := VarInt encode: -5.
	exp := ByteArray readHexFrom: '09'.
	self assert: res equals: exp
]

{ #category : 'as yet unclassified' }
ZigZagTest >> testEncodeULEB50399 [

	| res exp |
	res := VarInt encodeULEB128: 50399.
	exp := ByteArray readHexFrom: 'df8903'.
	self assert: res equals: exp
]

{ #category : 'as yet unclassified' }
ZigZagTest >> testEncodeULEB624485 [

	| res exp |
	res := VarInt encodeULEB128: 624485.
		exp := ByteArray readHexFrom: 'e58e26'.
	self assert: res equals: exp
]
