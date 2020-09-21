source("helpers.R")

# Arise-720 event's id: "118500872299"
# File name: arise-720-reg.csv

dat <- read_event_data(eventid = "118500872299")
gg <- plot_attendee_data(wrangle_event_data(dat))
print(gg)

if (!interactive()) {
  cache <- ".cache"
  dir.create(cache)
  file <- tempfile(tmpdir = cache, fileext = ".png")
  suppressMessages(ggplot2::ggsave(file, gg, device = "png"))
  shell.exec(file)
}