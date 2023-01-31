get_altm <- function(x) {
  #get altmetrics from bibliometrix data.frame
  alt_res <-  safe_altmetrics(doi = x$DI) 
  if(is.null(alt_res$error)){
    dfout <- data.frame(altmetric = alt_res$result$score, 
                        altmetric_3m = alt_res$result$history.3m)
  }else{
    dfout <- data.frame(altmetric = NA, altmetric_3m = NA)
  } 
  dfout
}