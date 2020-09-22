library(shiny)
library(shinythemes)
library(shinycssloaders)
library(eventbrite)

source(here::here("src", "helpers.R"))

ui <- fluidPage(
    
    theme = shinytheme("darkly"),

    titlePanel("NARC Eventbrite Data Monitoring Dashboard"),
    
    withSpinner(plotOutput("regPlot"))
    
)

server <- function(input, output) {
    
    dat <- read_event_data(eventid = "118500872299")
    
    dat <- wrangle_event_data(dat)
    
    output$regPlot <- renderPlot({
        plot_attendee_data(dat)
    })
}

shinyApp(ui = ui, server = server)
