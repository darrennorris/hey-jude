get_scopus_ab <- function(x) {
  #get content from Scopus
  alt_res <-  safe_scopus_ab(id = x$id_pii, identifier = "pii",
                             verbose = FALSE, headers = insttoken) 
  if(is.null(alt_res$error)){
    dfout <- data.frame(ab_scopus = alt_res$result$content$`abstracts-retrieval-response`$coredata$`dc:description`, 
                        doi_scopus = alt_res$result$content$`abstracts-retrieval-response`$coredata$`prism:doi`)
  }else{
    dfout <- data.frame(ab_scopus = NA, 
                        doi_scopus = NA)
  } 
  dfout
}