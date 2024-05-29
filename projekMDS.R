message('Loading Packages')
library(rvest)
library(tidyverse)
library(mongolite)

message('Scraping Data')
url <- "https://www.antaranews.com/tag/600/ikn-nusantara"
page <- read_html(url)


titles <- page %>% html_nodes(xpath = '//h2[@class="h5"]/a') %>% html_text()

dates <- page %>% html_nodes(xpath = '//span[@class="text-dark text-capitalize"]') %>% html_text()

links <- page %>% html_nodes(xpath = '//h2[@class="h5"]/a') %>% html_attr("href")

contents <-page %>% html_nodes(xpath = '//p') %>% html_text()

data <- data.frame(
  time_scraped = Sys.time(),
  titles = head(titles, 10),
  dates = head(dates, 10),
  links = head(links, 10),
  contents = head(contents, 10),
  stringsAsFactors = FALSE
)

# MONGODB
message('Input Data to MongoDB Atlas')
atlas_conn <- mongo(
  collection = Sys.getenv("ATLAS_COLLECTION"),
  db         = Sys.getenv("ATLAS_DB"),
  url        = Sys.getenv("ATLAS_URL")
)

atlas_conn$insert(data)
rm(atlas_conn)