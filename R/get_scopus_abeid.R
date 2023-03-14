get_scopus_abeid <- function(x) {
  #get content from Scopus
  alt_res <-  safe_scopus_ab(id = x$id_eid, identifier = "eid",
                             verbose = FALSE, headers = insttoken) 
  if(is.null(alt_res$error)){
    abres <- alt_res$result$content$`abstracts-retrieval-response`$coredata$`dc:description`
    doires <- alt_res$result$content$`abstracts-retrieval-response`$coredata$`prism:doi`
    
    if(!is.null(abres) & !is.null(doires)){
      dfout <- data.frame(ab_scopus = alt_res$result$content$`abstracts-retrieval-response`$coredata$`dc:description`, 
                          doi_scopus = alt_res$result$content$`abstracts-retrieval-response`$coredata$`prism:doi`) 
    }else{ 
      dfout <- data.frame(ab_scopus = NA, 
                          doi_scopus = NA)
    }
  }else{
    dfout <- data.frame(ab_scopus = NA, 
                        doi_scopus = NA)
  } 
  dfout
}