# DataDepository

An R package to upload datasets to BigQuery for public sharing so that they can be integrated with other public datasets easily.

## Why?

Before an analysis can be done, often a number of datasets have to be downloaded, cleaned and standardized.

A central repository that can store the data set after standardization would reduce the time required for the next analysis using the same source data. It would eliminate the time required to download, and parse a dataset. 

## What?

BigQuery is a serverless database that is an attractive solution to store and share datasets of general interest for a number of reasons:
* Very fast - joining two files in PubChem, 100 million chemical structures and 70 million names took less than 3 minutes without having to define an index
* Very cheap. There is no fee for the server it is hosted on, rather there is a small fee for storing data (10Gb free, $0.02 for each additional Gb - i.e. 1TB for $20 per month) and a fee for querying the data (1Tb free, $5 per additional TB)
* It has UI from which data can be stored or queried
* It has a rest API (and many clients)
* Metadata can be used to describe the dataset.
* All datasets can be referenced with unique URL

## Examples
[Compound names from PubChem mapped onto InChIKeys](https://bigquery.cloud.google.com/dataset/decisive-coder-171820:dataflow_output)
[Compound activities from ChEMBL enhanced with InChIKeys](https://bigquery.cloud.google.com/dataset/decisive-coder-171820:Chembl)
[Count of compounds appearing in databases based on UniChem](https://bigquery.cloud.google.com/dataset/decisive-coder-171820:UniChem)

## 

[Shiny app to query BigQuery](https://github.com/MarkEdmondson1234/BigQuery-Visualiser)