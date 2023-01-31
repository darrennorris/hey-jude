get_files <- function(folder_name = NA) {
  # get all ".bib" files from folder
  library(tidyverse)
  folder_location <- folder_name
  in_files <- list.files(folder_location, 
                         pattern = ".bib", full.names = TRUE)
  data.frame(folder_id = folder_location, file_id = in_files) %>%  
    group_by(folder_id, file_id) %>% 
    summarise(file_count = n()) %>% 
    ungroup() -> df_files
  return(df_files)
}