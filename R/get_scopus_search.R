get_scopus_search <- function(x) {
  title_text <- x$title_clean
  title_query <- paste("TITLE(",title_text,")", sep="")
  #search Scopus
  alt_res <-  safe_scopus_search(title_query, view = "COMPLETE",
                             verbose = FALSE, headers = insttoken) 
 
    if(!is.na(alt_res$result)){
      res_df <- gen_entries_to_df(alt_res$result$entries)$df
      #Ignores cases when search returns multiple articles
      myrow <- nrow(res_df)
      if(myrow==1){
      ab_out <- res_df$`dc:description`
        if(!is.null(ab_out)){
                            dfout <- data.frame(ab_scopus = ab_out, 
                            title_scopus = res_df$`dc:title`) 
                            }else{
                            dfout <- data.frame(ab_scopus = NA, title_scopus = NA)
                            } 
    }else{ 
      dfout <- data.frame(ab_scopus = NA, title_scopus = NA)
      }
  }else{
    dfout <- data.frame(ab_scopus = NA, title_scopus = NA)
  } 
  
  dfout
}