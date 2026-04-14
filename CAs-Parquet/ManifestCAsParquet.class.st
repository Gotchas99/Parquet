"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestCAsParquet',
	#superclass : 'PackageManifest',
	#category : 'CAs-Parquet-Manifest',
	#package : 'CAs-Parquet',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestCAsParquet class >> ruleReCollectionAtCollectionSizeRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#ParqFooter #parse2: #false)) #'2026-04-14T08:13:28.945+02:00') )
]
