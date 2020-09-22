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
            subtitle = paste("Total registrations =", nrow(data))) +
    xlab("Date") +
    ylab("No. of registrations") +
    theme(plot.title = element_text(face = "bold", hjust = 0.5),
          plot.subtitle = element_text(hjust = 0.5))
}
