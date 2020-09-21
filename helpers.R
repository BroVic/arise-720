source("root.R")

authenticate_apikey <- function() {
  require(httr, quietly = TRUE)
  url <- parse_url("https://www.eventbriteapi.com/v3/users/me")
  try({
    GET(url, add_headers(Authorization = paste("Bearer", getPrivateKey())))
  })
}

read_event_data <- function(eventid = NULL, file = NULL) {
  
  if (!is.null(file)) {
    return(read.csv(file, stringsAsFactors = FALSE))
  }
  
  if (is.null(eventid))
    stop("Arguments are required", call. = FALSE)
  
  require(httr, quietly = TRUE)
  
  apiurl <-
    file.path("https://www.eventbriteapi.com/v3/events",
              eventid,
              "attendees")
  
  tryCatch({
    r <- authenticate_apikey()
    stop_for_status(r)
    key <- getPrivateKey()
    r <-
      GET(apiurl,
          add_headers(Authorization = paste("Bearer", key)))
  }, error = function(e)
    stop(e))
  
  stop_for_status(r, task = "Reading data failed with status")
  
  # stringi::stri_enc_detect(content(r, as = 'text'))
  att <- content(r, as = 'text', encoding = "ISO-8859-1")
  att.list <-
    jsonlite::fromJSON(att, simplifyVector = FALSE, simplifyDataFrame = TRUE)
  
  # pageInfo <- att.list$pagination
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
  data.list <- data[myobjectnames]
  prof <- data.list$profile
  prof$addresses <- NULL
  data.list$profile <- NULL
  cbind(data.list, prof)
}


wrangle_event_data <- function(data) {
  stopifnot(is.data.frame(data))
  suppressPackageStartupMessages(require(dplyr))
  
  tryCatch({
    if ("Order.Date" %in% names(data))
      data <- rename(data, created = Order.Date)
  }, 
  error = function(e)
    message(conditionMessage(e), " but continuing with evaluation"))
  
  mutate(data, isodate = as.Date(created))
}


plot_attendee_data <- function(data) {
  stopifnot(any(grepl("isodate", names(data))))
  require(ggplot2, quietly = TRUE)
  ggplot(data, aes(x = isodate)) +
    geom_bar(col = "blue", fill = "brown") +
    ggtitle("Registrations for Arise Nigeria Project 720",
            subtitle = paste("Total number of registrations:", nrow(data)))
}