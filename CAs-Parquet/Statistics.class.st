Class {
	#name : 'Statistics',
	#superclass : 'Object',
	#instVars : [
		'min',
		'max',
		'null_count',
		'distinct_count',
		'max_value',
		'min_value',
		'is_max_value_exact',
		'is_min_value_exact'
	],
	#category : 'CAs-Parquet-Metadata',
	#package : 'CAs-Parquet',
	#tag : 'Metadata'
}

{ #category : 'instance creation' }
Statistics >> fromDict: aDict [

aDict at: 1 ifPresent: [ :val | min := val].
aDict at:2 ifPresent: [ :val | max := val].
aDict at: 3 ifPresent: [ :val | null_count := val].
aDict at: 4 ifPresent: [ :val | distinct_count := val].
aDict at: 5 ifPresent: [ :val | max_value := val].
aDict at: 6 ifPresent: [ :val | min_value := val].
aDict at: 7 ifPresent: [ :val | is_max_value_exact := val].
aDict at: 8 ifPresent: [ :val | is_min_value_exact := val].

]
