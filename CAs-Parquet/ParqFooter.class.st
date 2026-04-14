Class {
	#name : 'ParqFooter',
	#superclass : 'Object',
	#instVars : [
		'bytes',
		'version',
		'schema',
		'num_rows',
		'row_groups',
		'key_value_metadata',
		'created_by',
		'column_orders',
		'encryption_algorithm'
	],
	#category : 'CAs-Parquet-Metadata',
	#package : 'CAs-Parquet',
	#tag : 'Metadata'
}

{ #category : 'accessing' }
ParqFooter >> bytes: fileBytes [

	bytes := fileBytes.
	"self parse"
]

{ #category : 'accessing' }
ParqFooter >> parse [

	self parse2: bytes.
	self assert: version = 1
]

{ #category : 'accessing' }
ParqFooter >> parse2: buff [

	| meta |
	buff readStreamDo: [ :s | meta := Thrift new readStruct: s ].
	version := meta at: 1.
	schema := (meta at: 2) collect: [ :dict |
		          SchemaElement new fromDict: dict ].
	num_rows := meta at: 3.
	self halt.
		row_groups := (meta at: 4) collect: [ :dict |
		              RowGroup new fromDict: dict ]. 
	meta at: 5 ifPresent: [ :val |
			key_value_metadata := val collect: [ :dict |
				                      KeyValue new fromDict: dict ] ].
	created_by := (meta at: 6) asString.
	column_orders := 0.
	encryption_algorithm := 0
]

{ #category : 'accessing' }
ParqFooter >> parse: buff [

	| tmp |
	self halt.
	buff readStreamDo: [ :s |
			version := VarInt readZigZag: s.
			tmp := (Thrift new readList: s) first.
			schema := tmp collect: [ :dict | SchemaElement new fromDict: dict ].
			self halt.
			num_rows := VarInt readZigZag: s.
			tmp := (Thrift new readList: s) first.
			row_groups := tmp collect: [ :dict |
				              SchemaElement new fromDict: dict ].
			key_value_metadata := Thrift new readList: s.
			created_by := 'x'.
			column_orders := 0.
			encryption_algorithm := 0 ]
]

{ #category : 'versions' }
ParqFooter >> version [

	^version
]
