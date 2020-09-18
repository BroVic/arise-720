library(httr)
library(here)
library(jsonlite)
library(tidyverse)

source('root.R')

eventapiurl <- "https://www.eventbriteapi.com/v3/events/121737621503/attendees/"
r <- GET(eventapiurl, add_headers(Authorization = paste("Bearer", "AC7TSTCT6NJXFLDZIEEE")))

status_code(r) == 200
stringi::stri_enc_detect(content(r, as = 'text'))
att <- content(r, as = 'text', encoding = "ISO-8859-1")
att.list <- fromJSON(att, simplifyVector = FALSE, simplifyDataFrame = TRUE)
pageInfo <- att.list$pagination
data <- att.list$attendees
myobjectnames <-
  c(
    "id",
    "created",
    "changed",
    "quantity",
    "profile",
    "checked_in",
    "cancelled",
    "status"
  )
mydata.list <- data[myobjectnames]
prof <- mydata.list$profile
mydata.list$profile <- NULL
att.data <- cbind(mydata.list, prof)


   
