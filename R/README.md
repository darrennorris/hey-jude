## R folder directory
Includes a collection of helper functions to help automate and tidy processing.
Functions that help convert data from multiple sources into "readable" and  "usable" formats.

1. To load literature search results
 [get_files.R] gets names of bibtex files, creates a data.frame for use by load_bib.R
 [load_bib.R] wrapper around bibliometrix::convert2df to enable processing of multiple files.
 [mergeDbSourcesDN.R] hack of bibliometrix::mergeDbSources to work with list object.


2. To politely import Altmetric values 
 [altmetrics_updated.R] updated version of rAltmetric::altmetrics
 [safe_altmetrics.R] safe wrapper around altmetrics_updated.R
 [get_altm.R] to enable processing of multiple dois.