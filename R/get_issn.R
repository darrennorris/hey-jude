library(plyr) # plyr before tidyverse
library(tidyverse)
library(stringr)
library(textclean)
library(readxl)
library(magrittr)
library(rscopus)
library(RecordLinkage)

# Set API and Inst keys
s <- read_excel("data/something.xlsx")
s %>% filter(name=="apikey") %>% pull(value) -> myapikey
options("elsevier_api_key" = myapikey)
have_api_key()
print(rscopus::get_api_key(), reveal = TRUE)
s %>% filter(name=="insttoken") %>% pull(value) -> myinsttoken
insttoken <- myinsttoken
insttoken <- inst_token_header(insttoken)

# check API here? https://dev.elsevier.com/scopus.html
# defintions of codes https://service.elsevier.com/app/answers/detail/a_id/15181/supporthub/scopus/related/1/
subject_areas()
"ENVI"
subject_area_codes()
#1206 Conservation Social Sciences & Humanities
# https://dev.elsevier.com/scopus.html#!/Scopus_Search/ScopusSearch

#
jissn <- read_excel("data/journal_issn.xlsx")
# Helper functions 
source("R/safe_generic_els_search.R")
source("R/get_scopus_issn.R")
scopus_issn <- plyr::ddply(jissn, .(aid, Journal), .fun = get_scopus_issn)


# function to calculate similarity between titles.
find_title <- function(x){
  indat <- x
  indat %>% mutate(Journal = str_to_upper(Journal)) %>% pull(Journal) -> original
  indat %>% mutate(journal_name = str_to_upper(journal_name)) %>% 
    pull(journal_name) -> new_names
  jw = RecordLinkage::jarowinkler(original, new_names)
  jw_max =max(jw)
  indat %>% left_join(
  data.frame(Journal = indat$Journal, journal_name = indat$journal_name, 
             score_jw = jw)) %>% 
    filter(score_jw==jw_max) -> dfout
  dfout
}
# run function
scopus_titles <- plyr::ddply(scopus_issn, .(aid), .fun = find_title)
#export
jissn %>% left_join(
scopus_titles %>% 
  filter(score_jw >0.8) %>% 
  select(aid, issn_scopus, eissn_scopus)
) %>% 
  mutate(issn_clean = coalesce(issn, issn_scopus), 
         eissn_clean = coalesce(eissn, eissn_scopus)) %>% 
  write.csv("data/journal_issnclean.csv")

# manual integration of results with original data.
# now flag most strongly conservation focused i.e. conservation in the title
jnew <- read_excel("data/journal_issn.xlsx", na = c("", "NA"))
jnew %>% filter(!is.na(issn_clean)) %>% 
  group_by(issn_clean) %>% summarise(acount=n()) %>% 
  filter(acount>1)
jnew %>% filter(!is.na(eissn_clean)) %>% 
  group_by(eissn_clean) %>% summarise(acount=n()) %>% 
  filter(acount>1)
jnew %>%
  mutate(flag_conservation = ifelse(str_detect(str_to_upper(Journal), 
                                               "CONSERVATION"), 1, 0)) %>% 
  mutate(flag_conservation = ifelse(str_detect(str_to_upper(Journal), 
                                               "ORYX"), 1, flag_conservation)) -> jnew
jnew %>% 
  write.csv("data/flag_conservation.csv")
