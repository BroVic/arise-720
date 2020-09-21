source("helpers.R")

# Arise-720 event's id: "118500872299"
# File name: arise-720-reg.csv

dat <- read_event_data(eventid = "118500872299")
plot_attendee_data(wrangle_event_data(dat))
