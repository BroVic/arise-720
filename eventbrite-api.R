# EventBrite API
library(httr)
library(here)
source(here("root.R"))

GET(url, add_headers(Authorization = paste("Bearer", apikeys)))
