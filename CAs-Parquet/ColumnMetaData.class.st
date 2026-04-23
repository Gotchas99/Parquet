Class {
	#name : 'ColumnMetaData',
	#superclass : 'Object',
	#instVars : [
		'type',
		'encodings',
		'path_in_schema',
		'num_values',
		'total_uncompressed_size',
		'total_compressed_size',
		'key_value_metadata',
		'data_page_offset',
		'index_page_offset',
		'dictionary_page_offset',
		'statistics',
		'encoding_stats',
		'bloom_filter_offset',
		'bloom_filter_length',
		'size_statistics',
		'geospatial_statistics',
		'compressionCodec'
	],
	#category : 'CAs-Parquet-Metadata',
	#package : 'CAs-Parquet',
	#tag : 'Metadata'
}

{ #category : 'instance creation' }
ColumnMetaData >> fromDict: aDict [

	type := aDict at: 1.
	encodings := aDict at: 2.
	self validateEncodings.
	path_in_schema := (aDict at: 3) collect: #asString.
	compressionCodec := aDict at: 4.
	self validateCompressionCodec.
	num_values := aDict at: 5.
	total_uncompressed_size := aDict at: 6.
	total_compressed_size := aDict at: 7.
	aDict at: 8 ifPresent: [ :val |
			self halt.
			key_value_metadata := val ]. "list of KeyValue"
	data_page_offset := aDict at: 9.
	aDict at: 10 ifPresent: [ :val | index_page_offset := val ].
	aDict at: 11 ifPresent: [ :val | dictionary_page_offset := val ].
	aDict
		at: 12
		ifPresent: [ :val | statistics := Statistics new fromDict: val ].
	aDict at: 13 ifPresent: [ :val |
			encoding_stats := val collect: [ :pes |
				                  PageEncodingStats new fromDict: pes ] ]. "list<PageEncodingStats>"
	aDict at: 14 ifPresent: [ :val | bloom_filter_offset := val ].
	aDict at: 15 ifPresent: [ :val | bloom_filter_length := val ].
	aDict at: 16 ifPresent: [ :val |
			self halt.
			size_statistics := val ]. "SizeStatistics "
	aDict at: 17 ifPresent: [ :val |
			self halt.
			geospatial_statistics := val ] "GeospatialStatistics "
]

{ #category : 'accessing' }
ColumnMetaData >> path_in_schema [

	^ path_in_schema first
]

{ #category : 'printing' }
ColumnMetaData >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: self path_in_schema;
		nextPut: $).
(		compressionCodec =2)ifTrue: [ aStream << '-GZIP' ]
]

{ #category : 'as yet unclassified' }
ColumnMetaData >> validateCompressionCodec [
	"enum CompressionCodec {
  UNCOMPRESSED = 0;
  SNAPPY = 1;
  GZIP = 2;
  LZO = 3;
  BROTLI = 4;  // Added in 2.4
  LZ4 = 5;     // DEPRECATED (Added in 2.4)
  ZSTD = 6;    // Added in 2.4
  LZ4_RAW = 7; // Added in 2.9
	}"

	(#( 0 2) includes: compressionCodec) ifFalse: [
		self error: 'Unknown CompressionCodec' ]
]

{ #category : 'as yet unclassified' }
ColumnMetaData >> validateEncodings [
	"Encodings:
	PLAIN = 0;
	PLAIN_DICTIONARY = 2;
	RLE = 3;
	BIT_PACKED = 4;"

	(#( 0 2 3 4 ) includesAll: encodings) ifFalse: [
		self error: 'Unknown encoding' ] 
]
