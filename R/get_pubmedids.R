get_pubmedids <- function(x) {
  #get IDs
  library(easyPubMed)
  query_text <- paste(x$doi_clean, "[DOI]", sep="")
  my_query <- safe_pubmedid(query_text, api_key ="ff5578bfd85d5a8281f602b4b6b9f1cc7e08")
  
  if(is.null(my_query$error) & my_query$result$Count=="1"){
  pubmed_xmlt <- safe_pubmedfetch(my_query$result, format="xml")
  # return abstract
    my_PM_list <- articles_to_list(pubmed_data = pubmed_xmlt$result)
    curr_PM_record <- my_PM_list[[1]]
    my.df <- article_to_df(curr_PM_record, max_chars = -1, getAuthors = FALSE)
    
    dout <- data.frame(ab_pubmed = my.df[1,'abstract'])
  }else{
    dout <- data.frame(ab_pubmed = NA)
  } 
  dout
}