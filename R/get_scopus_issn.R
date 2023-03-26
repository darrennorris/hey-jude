get_scopus_issn <- function(x) {
  title_text <- x$Journal
  
  #search Scopus
  alt_res <-  safe_generic_els_search(query="", type="serial", 
                                      title = title_text,
                                      headers = insttoken) 
 
    if(!is.na(alt_res$result)){ 
      ent <- alt_res$result$content$`serial-metadata-response`$entry
      bindlist <- rscopus:::bind_list(ent)
      
      if(!is.null(bindlist$`dc:title`)){
        title_out <- bindlist$`dc:title`}else{title_out <- NA}
      if(!is.null(bindlist$`prism:issn`)){
        issn_out <- bindlist$`prism:issn`}else{issn_out <- NA} 
      if(!is.null(bindlist$`prism:eIssn`)){
        eissn_out <- bindlist$`prism:eIssn`}else{eissn_out <- NA} 
      
      dfout <- data.frame(journal_name = title_out, issn_scopus = issn_out, 
                          eissn_scopus = eissn_out)
    }else(dfout <- data.frame(journal_name = NA, issn_scopus = NA, eissn_scopus = NA))

  dfout
}