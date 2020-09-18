tidypack <- "tidyverse"
pic <- "registrations-plot.png"

if (!requireNamespace(tidypack))
  install.packages(tidypack, repos = "https://cran.rstudio.com")
library(tidyverse)

dat <- read.csv("arise-720-reg.csv")

gg <- dat %>%
  mutate(isodate = as.Date(Order.Date)) %>%
  ggplot(aes(x = isodate)) +
  geom_bar()

ggsave(pic, gg, "png")
shell.exec(pic)
