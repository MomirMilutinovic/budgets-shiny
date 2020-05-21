#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(shinythemes)
library(plotly)

prihodi <- read_csv("../data/prihodi.csv")
rashodi <- read_csv("../data/rashodi.csv")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    theme = shinytheme(theme = "flatly"),

    # Application title
    titlePanel("Budžeti gradova Srbije"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("grad", "Izaberite grad", unique(prihodi$grad)),
            "Zasto ovo postoji i kako se koristi"
        ),

        # Show a plot of the generated distribution
        mainPanel(
            fluidRow(
                column(6,
                       plotlyOutput("topPrihodi")
                ),
                column(6,
                       plotlyOutput("topRashodi")
                ),
            ),
            plotOutput("treemap")
            
        )
    )
))
