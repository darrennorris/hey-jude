get_abstracts <- function(x) {
  #get Abstracts from crossref
  alt_res <-  safe_abstracts(doi = x$doi_clean) 
  if(is.null(alt_res$error)){
    dfout <- data.frame(ab_text = alt_res$result)
  }else{
    dfout <- data.frame(ab_text = NA)
  } 
  dfout
}