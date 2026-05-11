Class {
	#name : 'FileMetaData',
	#superclass : 'Object',
	#instVars : [
		'version',
		'schema',
		'num_rows',
		'row_groups',
		'key_value_metadata',
		'created_by',
		'column_orders',
		'encryption_algorithm',
		'footer_signing_key_metadata'
	],
	#category : 'CAs-Parquet-Metadata',
	#package : 'CAs-Parquet',
	#tag : 'Metadata'
}

{ #category : 'accessing' }
FileMetaData >> bytes: fileBytes [

	self parse2: fileBytes.
	self assert: version = 1
]

{ #category : 'as yet unclassified' }
FileMetaData >> chunksFor: aColName [

	^row_groups collect:[:rg|rg chunkFor: aColName ]
]

{ #category : 'accessing' }
FileMetaData >> parse2: buff [

	| meta |
	buff readStreamDo: [ :s | meta := Thrift new readStruct: s ].
	version := meta at: 1.
	schema := (meta at: 2) collect: [ :dict |
		          SchemaElement new fromDict: dict ].
	num_rows := meta at: 3.
	row_groups := (meta at: 4) collect: [ :dict |
		              RowGroup new fromDict: dict ].
	meta at: 5 ifPresent: [ :val |
			key_value_metadata := val collect: [ :dict |
				                      KeyValue new fromDict: dict ] ].
	created_by := (meta at: 6) asString.
	"ColumnOrder is ignored. Didn't understand"
	"meta at: 7 ifPresent: [ :val |
			self halt.
			column_orders := val collect: [ :dict |
				                 XXXXXXXXX new fromDict: dict ] ]."
	meta at: 8 ifPresent: [ :val |
			self halt.
			encryption_algorithm := val collect: [ :dict |
				                        KeyValue new fromDict: dict ] ].
	meta at: 9 ifPresent: [ :val |
			self halt.
			footer_signing_key_metadata := val collect: [ :dict |
				                               KeyValue new fromDict: dict ] ]
]

{ #category : 'accessing' }
FileMetaData >> parse: buff [

	| tmp |
	self deprecated: 'använd parse2 istället'.
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

{ #category : 'accessing' }
FileMetaData >> schema [
^schema
]

{ #category : 'accessing' }
FileMetaData >> schemaForName:aColName [

	^ schema detect:[:el|el name = aColName ].
]

{ #category : 'accessing' }
FileMetaData >> version [

	^version
]
