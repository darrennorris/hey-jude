get_scopus_search_williams <- function(x) {
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
        if(!is.null(res_df$`dc:description`)){
        ab_out <- res_df$`dc:description`}else{ab_out <- NA}
        if(!is.null(res_df$`dc:title`)){
        title_out <- res_df$`dc:title`}else{title_out <- NA} 
        if(!is.null(res_df$`prism:doi`)){
          doi_out <- res_df$`prism:doi`}else{doi_out <- NA} 
        if(!is.null(res_df$`prism:doi`)){
          journal_out <- res_df$`prism:publicationName`}else{journal_out <- NA} 
        # to return
        dfout <- data.frame(ab_scopus = ab_out, 
                            title_scopus =title_out, 
                            journal_scopus = journal_out, 
                            doi_scopus = doi_out)
                            }else{
                            dfout <- data.frame(ab_scopus = NA, title_scopus = NA, 
                                                journal_scopus = NA, doi_scopus = NA)
                            } 
    }else{ 
      dfout <- data.frame(ab_scopus = NA, title_scopus = NA, 
                          journal_scopus = NA, doi_scopus = NA)
      }
  
  dfout
}