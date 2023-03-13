get_scopus_abdoi <- function(x) {
  #get content from Scopus
  alt_res <-  safe_scopus_ab(id = x$doi_clean, identifier = "doi",
                             verbose = FALSE, headers = insttoken) 
  if(!is.null(alt_res$result)){
    abres <- alt_res$result$content$`abstracts-retrieval-response`$coredata$`dc:description`
    if(!is.null(abres)){
    dfout <- data.frame(ab_scopus = alt_res$result$content$`abstracts-retrieval-response`$coredata$`dc:description`, 
                        doi_scopus = alt_res$result$content$`abstracts-retrieval-response`$coredata$`prism:doi`) 
    }else{ 
      dfout <- data.frame(ab_scopus = NA, 
                               doi_scopus = x$doi_clean)
      }
  }else{
    dfout <- data.frame(ab_scopus = NA, 
                        doi_scopus = NA)
  } 
  dfout
}