# Scrape and standardize doi from "doi" and "url" columns.
# Questions - email Darren: dnorris75@gmail.com
# provides a consistent standard result, two columns - 
# doi_clean (facilitating bibliometric searches) and doi_url (resolvable link to webpage).
# Does not check if doi is valid.
# Will not correct issues (examples below) that 
# should be dealt with as part of standard cleaning process.
## 7874 - doi incorrect/invalid. Use manually adjusted dois
## 10316 - doi duplicate of 10478
## 8599 doi duplicate of 8598
## 10475 url duplicate of 10237

# L20  load packages
# L23  load data
# L38  scrape dois
# L167 tidy and check results
# L214 identify studies that need entries checking/updating


#1) packages
library(tidyverse)
library(readxl)
#2) load data
cedat <- read_excel('data/studydat_fordarrenn_24_02_2023.xlsx')
cedat %>%
group_by(study.id, publication.year, publication.title, 
         journal.name,doi, url) %>% 
  summarise(intervention_count = n()) %>% 
  ungroup() -> cedat_studies
# Example to check for duplicates of url address
# 18 need checking/correcting
cedat_studies %>% 
  filter(!is.na(url)) %>%
  group_by(url) %>% summarise(count_rows = n(), 
                              count_studies = length(unique(study.id))) %>% 
  filter(count_rows>1)

#3) Scrape dois
# clean out prefixes. Correct copy/paste errors etc.
doi_prefix <- c("https://dx.doi.org/DOI:", "http://dx.doi.org/DOI:", 
                "https://dx.doi.org/doi:", "http://dx.doi.org/doi:", 
                "https://dx.doi.org/", "http://dx.doi.org/",  
                 "https://doi.org/", "http://doi.org/", "ttps://doi.org/", 
                "dx.doi.org/",
                 "doi.org/","DOI: ","DOI:", "doi: ", "doi:")
# Url prefixes for dois used by specific journals.
# can expand this to include more urls to extract dois from
journal_doi_prefix <- c( "http://www.asmjournals.org/doi/abs/",
                         "http://link.springer.com/article/",  
                         "https://link.springer.com/chapter/", 
                         "https://link.springer.com/content/pdf/",
                         "http://www.bioone.org/doi/abs/", "http://www.karger.com/DOI/", 
                         "http://www.tandfonline.com/doi/abs/", 
                         "https://besjournals.onlinelibrary.wiley.com/doi/epdf/",
                         "https://besjournals.onlinelibrary.wiley.com/doi/abs/", 
                         "https://journals.plos.org/plosone/article/file?id=", 
                         "https://journals.plos.org/plosone/article?id=", 
                         "http://journals.sagepub.com/doi/abs/",
                         "https://link.springer.com/article/", 
                         "https://www.frontiersin.org/articles/",
                         "https://onlinelibrary.wiley.com/doi/epdf/",
                         "https://onlinelibrary.wiley.com/doi/pdf/",
                         "https://onlinelibrary.wiley.com/doi/abs/", 
                         "https://onlinelibrary.wiley.com/doi/full/", 
                         "https://onlinelibrary.wiley.com/doi/",
                         "http://onlinelibrary.wiley.com/doi/", 
                         "https://royalsocietypublishing.org/doi/pdf/",
                         "https://wildlife.onlinelibrary.wiley.com/doi/abs/", 
                         "https://wildlife.onlinelibrary.wiley.com/doi/pdf/", 
                         "https://zslpublications.onlinelibrary.wiley.com/doi/abs/",
                         "https://zslpublications.onlinelibrary.wiley.com/doi/epdf/",
                         "https://zslpublications.onlinelibrary.wiley.com/doi/pdf/",
                         "https://zslpublications.onlinelibrary.wiley.com/doi/", 
                         "https://www.scopus.com/inward/record.uri?eid=2-s2.0-84997426723&doi=", 
                         "https://www.scopus.com/inward/record.uri?eid=2-s2.0-84951076741&doi=", 
                         "https://www.scopus.com/inward/record.uri?eid=2-s2.0-84959282517&doi=", 
                         "https://www.scopus.com/inward/record.uri?eid=2-s2.0-84940942773&doi=", 
                         "https://www.scopus.com/inward/record.uri?eid=2-s2.0-84949952613&doi="
)

# Process study records. Four parts: 1) replace doi prefixes, 
# 2) replace journal url prefixes, 3) replace doi prefixes in urls, 
# 4) replace superfluous text and symbols
cedat_studies %>% 
  mutate(doi = str_trim(doi), 
         url = str_trim(url)) %>%
  mutate(doi_ce = str_replace(doi, doi_prefix[1], "")) %>% 
  mutate(doi_ce = str_replace(doi_ce, doi_prefix[2], "")) %>% 
  mutate(doi_ce = str_replace(doi_ce, doi_prefix[3], "")) %>% 
  mutate(doi_ce = str_replace(doi_ce, doi_prefix[4], "")) %>% 
  mutate(doi_ce = str_replace(doi_ce, doi_prefix[5], "")) %>% 
  mutate(doi_ce = str_replace(doi_ce, doi_prefix[6], "")) %>% 
  mutate(doi_ce = str_replace(doi_ce, doi_prefix[7], "")) %>% 
  mutate(doi_ce = str_replace(doi_ce, doi_prefix[8], "")) %>% 
  mutate(doi_ce = str_replace(doi_ce, doi_prefix[9], "")) %>% 
  mutate(doi_ce = str_replace(doi_ce, doi_prefix[10], "")) %>% 
  mutate(doi_ce = str_replace(doi_ce, doi_prefix[11], "")) %>% 
  mutate(doi_ce = str_replace(doi_ce, doi_prefix[12], "")) %>% 
  mutate(doi_ce = str_replace(doi_ce, doi_prefix[13], "")) %>% 
  mutate(doi_ce = str_replace(doi_ce, doi_prefix[14], "")) %>%
  mutate(doi_ce = str_replace(doi_ce, doi_prefix[15], "")) %>%
  mutate(doi_ce = if_else(study.id ==7943 ,"10.1016/j.jnc.2015.03.007", doi_ce)) %>%
  mutate(doi_ce = str_replace(doi_ce, "http://www.bioone.org/doi/abs/", "")) %>% 
  mutate(doi_ce = str_replace(doi_ce, "https://link.springer.com/article/", "")) %>% 
  mutate(doi_ce = str_replace(doi_ce, "https://onlinelibrary.wiley.com/doi/abs/", "")) %>%  
  mutate(doi_ce = str_replace(doi_ce, "NA", NA_character_)) %>% 
  mutate(doi_url = str_replace(url, fixed(journal_doi_prefix[1]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[2]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[3]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[4]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[5]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[6]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[7]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[8]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[9]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[10]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[11]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[12]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[13]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[14]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[15]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[16]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[17]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[18]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[19]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[20]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[21]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[22]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[23]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[24]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[25]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[26]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[27]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[28]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[29]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[30]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[31]), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed(journal_doi_prefix[32]), "")) %>%
  mutate(doi_url = str_replace(doi_url, doi_prefix[1], "")) %>%
  mutate(doi_url = str_replace(doi_url, doi_prefix[2], "")) %>% 
  mutate(doi_url = str_replace(doi_url, doi_prefix[3], "")) %>% 
  mutate(doi_url = str_replace(doi_url, doi_prefix[4], "")) %>% 
  mutate(doi_url = str_replace(doi_url, doi_prefix[5], "")) %>% 
  mutate(doi_url = str_replace(doi_url, doi_prefix[6], "")) %>% 
  mutate(doi_url = str_replace(doi_url, doi_prefix[7], "")) %>% 
  mutate(doi_url = str_replace(doi_url, doi_prefix[8], "")) %>% 
  mutate(doi_url = str_replace(doi_url, doi_prefix[9], "")) %>% 
  mutate(doi_url = str_replace(doi_url, doi_prefix[10], "")) %>% 
  mutate(doi_url = str_replace(doi_url, doi_prefix[11], "")) %>% 
  mutate(doi_url = str_replace(doi_url, doi_prefix[12], "")) %>% 
  mutate(doi_url = str_replace(doi_url, doi_prefix[13], "")) %>% 
  mutate(doi_url = str_replace(doi_url, doi_prefix[14], "")) %>% 
  mutate(doi_url = str_replace(doi_url, doi_prefix[15], "")) %>%
  mutate(doi_url = str_replace(doi_url, "/abstract", "")) %>% 
  mutate(doi_url = str_replace(doi_url, "/full", "")) %>% 
  mutate(doi_url = str_replace(doi_url, "/pdf", "")) %>% 
  mutate(doi_url = str_replace(doi_url, ".pdf", "")) %>% 
  mutate(doi_url = str_replace(doi_url, "%2F", "/")) %>% 
  mutate(doi_url = str_replace(doi_url, "%2f", "/")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed("&type=printable"), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed("&partnerID=40&md5=e7e28a9bcf2a253ad4cdbc1c807581c1"), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed("&partnerID=40&md5=69d21e627f92cd4b6f3c9837c45d6f2c"), "")) %>% 
  mutate(doi_url = str_replace(doi_url, fixed("&partnerID=40&md5=1af9d56b08f7404744b5e497fda4cd24"), "")) %>% 
  mutate(doi_url = str_replace(doi_url, 
                               fixed("&partnerID=40&md5=5c317266eef42c4e3e99d4ca26b2db29"), "")) -> cedat_study02

#4) Tidy, make new column with clean doi from  original doi and url columns.
# Check (probably) valid dois i.e. must start with "10". 
# Result should be an empty tibble. 
# If not go back and update doi/journal prefixes.
cedat_study02 %>%
  mutate(url_flag_doi = ifelse(str_detect(doi_ce, "http"), 1, 0), 
         url_flag = ifelse(str_detect(doi_url, "http"), 1, 0), 
         wos_flag = ifelse(str_detect(doi_url, "ISI"), 1, 0), 
         www_flag = ifelse(str_detect(doi_url, "www"), 1, 0)) %>% 
  mutate( doi_ce = ifelse(url_flag_doi==1, NA_character_, doi_ce), 
          doi_url = ifelse(url_flag==1 | wos_flag==1 | www_flag==1, NA_character_, doi_url) 
        ) %>% 
  mutate(doi_clean = coalesce(doi_ce, doi_url)) %>% 
  separate(doi_clean, into=c("doi_clean", NA), sep=" ") %>%
  filter(!is.na(doi_clean)) %>% 
  mutate(flag_valid = ifelse(str_detect(str_sub(doi_clean, start=1, end=2),"10"), 1, 0)) %>% 
  filter(flag_valid==0) %>% 
  select(study.id, doi, url, doi_clean, doi_url)

# Save results in new data frame.
# Tidy, new column with doi from  original doi and url columns.
cedat_study02 %>%
  # remove remaining url links that do not include dois
  mutate(url_flag_doi = ifelse(str_detect(doi_ce, "http"), 1, 0), 
         url_flag = ifelse(str_detect(doi_url, "http"), 1, 0), 
         wos_flag = ifelse(str_detect(doi_url, "ISI"), 1, 0), 
         www_flag = ifelse(str_detect(doi_url, "www"), 1, 0)) %>% 
  mutate( doi_ce = ifelse(url_flag_doi==1, NA_character_, doi_ce), 
          doi_url = ifelse(url_flag==1 | wos_flag==1 | www_flag==1, NA_character_, doi_url) 
  ) %>% 
  # new column with doi
  mutate(doi_clean = coalesce(doi_ce, doi_url)) %>% 
  separate(doi_clean, into=c("doi_clean", NA), sep=" ") %>% 
  # new column with doi url
  mutate(doi_url = if_else(is.na(doi_clean), doi_clean, paste("https://doi.org/", 
                                                              doi_clean, sep=""))) %>% 
  select(study.id, journal.name, publication.title, doi, url, doi_clean, doi_url) -> cedat_dois 

# dois more than doubled from 26% (707) to 62% (1682)
cedat_dois %>% 
  filter(!is.na(doi), !is.na(journal.name)) %>% nrow() -> count_article_doi
cedat_dois %>% 
  filter(!is.na(doi_clean), !is.na(journal.name)) %>% nrow() -> count_article_doi_clean
c(count_article_doi, count_article_doi_clean) / cedat_dois %>% 
  filter(!is.na(journal.name)) %>% nrow()
#[1] 0.2566108 0.6204842

#5) Identify problem studies
length(unique(cedat_dois$doi_clean)) # 1669
cedat_dois %>% 
  filter(!is.na(doi_clean)) %>%
  group_by(doi_clean) %>% summarise(count_rows = n(), 
                                    count_study = length(unique(study.id))) %>% 
  filter(count_rows >1) %>% pull(doi_clean) -> check_dois
cedat_dois %>% 
  filter(doi_clean %in% check_dois) %>% pull(study.id) -> check_studies
# Below are studies that may need correcting e.g.
# interventions in different synopses have different urls and/or dois for the same study
# incorrect url/doi duplicated across different studies
cedat %>% 
  filter(study.id %in% check_studies) %>% 
  arrange(study.id) -> tocheck
write.csv(tocheck, "data/cedat_tocheck.csv", row.names = FALSE)
# Export
cedat_dois %>% 
  mutate(doi_clean = ifelse(study.id %in% check_studies, NA_character_, doi_clean), 
         doi_url = ifelse(study.id %in% check_studies, NA_character_, doi_url)) -> cedat_dois_out
length(unique(cedat_dois_out$doi_clean)) # 1636
# should be an empty tibble
cedat_dois_out %>% 
  filter(!is.na(doi_clean)) %>%
  group_by(doi_clean) %>% summarise(count_rows = n(), 
                                    count_study = length(unique(study.id))) %>% 
  filter(count_rows >1)
         
write.csv(cedat_dois_out,"data/cedat_dois.csv", row.names = FALSE)
