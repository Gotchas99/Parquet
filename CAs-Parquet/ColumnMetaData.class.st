Class {
	#name : 'ColumnMetaData',
	#superclass : 'Object',
	#instVars : [
		'type',
		'encodings',
		'path_in_schema',
		'codec',
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
		'geospatial_statistics'
	],
	#category : 'CAs-Parquet-Metadata',
	#package : 'CAs-Parquet',
	#tag : 'Metadata'
}

{ #category : 'instance creation' }
ColumnMetaData >> fromDict: aDict [

	type := aDict at: 1.
	self halt.encodings:= aDict at:2. "list of Encoding".
	self halt.path_in_schema:=aDict at:3. "list of string"
	self halt.codec :=aDict at:4."CompressionCodec"
	num_values:=aDict  at:5.
	total_uncompressed_size:=aDict at:6.
	total_compressed_size:=aDict at:7.
	aDict at: 8 ifPresent: [ :val | self halt.key_value_metadata:= val]."list of KeyValue"
	data_page_offset:=aDict at:9.
	aDict at: 10 ifPresent: [ :val | index_page_offset := val].
	aDict at: 11 ifPresent: [ :val | dictionary_page_offset := val].
	aDict at: 12 ifPresent: [ :val |self halt. statistics:= val]."Statistics"
	aDict at: 13 ifPresent: [ :val | self halt.encoding_stats := val]."list<PageEncodingStats>"
	aDict at: 14 ifPresent: [ :val | bloom_filter_offset:= val].
	aDict at: 15 ifPresent: [ :val | bloom_filter_length:= val].
	aDict at: 16 ifPresent: [ :val | self halt.size_statistics:= val]."SizeStatistics "
	aDict at: 17 ifPresent: [ :val |self halt. geospatial_statistics:= val]."GeospatialStatistics "
]
