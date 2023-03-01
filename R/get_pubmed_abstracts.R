get_pubmed_abstracts <- function(x) {
  library(easyPubMed)
  my_id <- x
  pubmed_xml <- safe_pubmedfetch(my_id, format="xml")
  
  # return list
  if(is.null(pubmed_xml$error)){
    my_PM_list <- articles_to_list(pubmed_data = pubmed_xml)
    curr_PM_record <- my_PM_list[[1]]
    my.df <- article_to_df(curr_PM_record)
    
    dout <- data.frame(ab_pubmed = my.df[1,'abstract'])
  }else{
    dout <- data.frame(ab_pubmed = NA)
  } 
  dout
}