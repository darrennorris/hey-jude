altmetrics_new <-
  # from https://stackoverflow.com/questions/72658482/having-trouble-using-raltmetric-in-r
  # copy at https://gist.github.com/mathzero/f1d1b3b94f6f76019a5861d1bed7d597
  function(doi = NULL,
           apikey = NULL,
           ...) {
    
    base_url <- "https://api.altmetric.com/v1/"
    args <- list(key = apikey)
    request <-
      httr::GET(paste0(base_url, "doi/",doi))
    if(httr::status_code(request) == 404) {
      stop("No metrics found for object")
    } else {
      httr::warn_for_status(request)
      results <-
        jsonlite::fromJSON(httr::content(request, as = "text"), flatten = TRUE)
      results <- rlist::list.flatten(results)
      class(results) <- "altmetric"
      results
      
    }
  }
