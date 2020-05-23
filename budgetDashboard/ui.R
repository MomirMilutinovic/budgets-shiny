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
library(treemapify)

prihodi <- read_csv("../data/prihodi.csv")
rashodi <- read_csv("../data/rashodi.csv")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    theme = shinytheme(theme = "paper"),

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
                column(4,
                       htmlOutput("prihodiCard", class = "card")
                ),
                column(4,
                       htmlOutput("rashodiCard")
                ),
                column(4,
                       htmlOutput("dohodakCard", class = "card")
                )
            ),
            fluidRow(
                column(6,
                       plotlyOutput("topPrihodi")
                ),
                column(6,
                       plotlyOutput("topRashodi")
                )
            ),
            fluidRow(
                column(6,
                       plotlyOutput("prihodiTreemap")
                ),
                column(6,
                       plotlyOutput("rashodiTreemap")
                ),
            )
            
        )
    )
))
