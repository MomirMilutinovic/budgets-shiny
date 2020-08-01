# budgets-shiny
Flexdashboard dashboard about the budgets of several cities in Serbia.

## Data
The app uses budget data for Kragujevac, Niš and Priboj for the year 2020. The data is available at [Portal otvorenih podataka](https://data.gov.rs/sr/search/?q=%D0%B1%D1%83%D1%9F%D0%B5%D1%82) 

## Usage
Run budgetDashboard.Rmd and you should be ready to go.
You can also see the dashboard in action at: <https://floatingduck.shinyapps.io/budgetDashboard/> 

## Directory structure
- The data directory contains both the raw data for individual cities in the form excel tables, and the earnings and expenses for all of the cities in prihodi.csv, and rashodi.csv. 
- budgetDashboard.Rmd is the dashboard.
- functions.R contains various functions for visualizing the data and preparing it for visualization
- prepareData.R merges the raw data and writes it to prihodi.csv and rashodi.csv in a cleaner form
