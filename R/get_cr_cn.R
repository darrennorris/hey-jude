get_cr_cn <- function(x) {
  #get content from crossref
  alt_res <-  safe_cr_cn(dois = x$doi_clean, format = "bibentry") 
  if(is.null(alt_res$error)){
    dfout <- data.frame(journal = alt_res$result$journal)
  }else{
    dfout <- data.frame(journal = NA)
  } 
  dfout
}