load_bib <- function(x){ 
  # simple wrapper of bibliometrix::convert2df
  myrefs <- bibliometrix::convert2df(file = x$file_id, dbsource = "wos", 
                                     format = "bibtex") 
  myrefs
}