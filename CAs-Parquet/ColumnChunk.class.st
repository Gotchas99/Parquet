Class {
	#name : 'ColumnChunk',
	#superclass : 'Object',
	#instVars : [
		'file_path',
		'file_offset',
		'meta_data'
	],
	#category : 'CAs-Parquet-Metadata',
	#package : 'CAs-Parquet',
	#tag : 'Metadata'
}

{ #category : 'instance creation' }
ColumnChunk >> fromDict: aDict [

	aDict at: 1 ifPresent: [ :val | file_path := val ].
	file_offset := aDict at: 2.
	aDict at: 3 ifPresent: [ :val |
			meta_data := ColumnMetaData new fromDict: val ].
	aDict at: 4 ifPresent: [ :val | self halt ].
	aDict at: 5 ifPresent: [ :val | self halt ].
	aDict at: 6 ifPresent: [ :val | self halt ].
	aDict at: 7 ifPresent: [ :val | self halt ].
	aDict at: 8 ifPresent: [ :val | self halt ].
	aDict at: 9 ifPresent: [ :val | "self validateEncodings.
	path_in_schema := (aDict at: 3) collect: #asString.
	compressionCodec := aDict at: 4.
	self validateCompressionCodec.
	num_values := aDict at: 5.
	total_uncompressed_size := aDict at: 6.
	total_compressed_size := aDict at: 7.
	aDict at: 8 ifPresent: [ :val |
			self halt.
			key_value_metadata := val ]. ""list of KeyValue""
	data_page_offset := aDict at: 9.
	aDict at: 10 ifPresent: [ :val | index_page_offset := val ].
	aDict at: 11 ifPresent: [ :val | dictionary_page_offset := val ].
	aDict
		at: 12
		ifPresent: [ :val | statistics := Statistics new fromDict: val ].
	aDict at: 13 ifPresent: [ :val |
			self halt.
			encoding_stats := val ]. ""list<PageEncodingStats>""
	aDict at: 14 ifPresent: [ :val | bloom_filter_offset := val ].
	aDict at: 15 ifPresent: [ :val | bloom_filter_length := val ].
	aDict at: 16 ifPresent: [ :val |
			self halt.
			size_statistics := val ]. ""SizeStatistics ""
	aDict at: 17 ifPresent: [ :val |
			self halt.
			geospatial_statistics := val ] ""GeospatialStatistics """
		self halt ]
]

{ #category : 'printing' }
ColumnChunk >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: meta_data path_in_schema;
		nextPut: $)
]
