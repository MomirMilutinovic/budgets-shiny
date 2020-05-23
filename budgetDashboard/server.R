#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$topPrihodi <- renderPlotly({

        df <- prihodi %>% filter(grad == input$grad) %>%
            group_by(ekonomska_klasa)
        df <- summarise(df, budzet = sum(budzet))
        df <- df %>% top_n(n = 5) %>% arrange(budzet)
        
        df$ekonomska_klasa <- factor(df$ekonomska_klasa, levels = df$ekonomska_klasa[order(df$budzet)])
        plot <- df %>% ggplot(aes(x=ekonomska_klasa, y=budzet)) +
            geom_col(fill = "green", color="black") +
            theme(text = element_text(size=12)) +
            scale_x_discrete(labels = function(x) str_wrap(x, width = 15)) +
            ggtitle("Prvih 5 stavki po prihodu") +
            xlab("Stavka") +
            ylab("Prihod u RSD") +
            theme_minimal()
        
        ggplotly(plot)

    })
    
    output$topRashodi <- renderPlotly({
        
        df <- rashodi %>% filter(grad == input$grad) %>%
                group_by(ekonomska_klasifikacija)
        df <- summarise(df, budzet = sum(budzet))
        df <- df %>% top_n(n = 5) %>% arrange(budzet)
        df$budzet <- df$budzet * -1
        
        df$ekonomska_klasifikacija <- factor(df$ekonomska_klasifikacija, levels = df$ekonomska_klasifikacija[order(df$budzet)])
        plot <- df %>% ggplot(aes(x=ekonomska_klasifikacija, y=budzet)) +
            geom_col(fill= "red", color="black") +
            theme(text = element_text(size=12)) +
            scale_x_discrete(labels = function(x) str_wrap(x, width = 15)) +
            ggtitle("Prvih 5 stavki po rashodu") +
            xlab("Stavka") +
            ylab("Rashod u RSD") +
            theme_minimal()
        
        ggplotly(plot)
        
    })
    
    output$rashodiTreemap <- renderPlotly({
        df <- rashodi %>% filter(grad == input$grad) %>%
            group_by(ekonomska_klasifikacija)
        df <- summarise(df, budzet = sum(budzet), parent = unique(programska_klasifikacija)[1])
        df$budzet <- df$budzet * -1
        
        plot_ly(
            type='treemap',
            labels=df$ekonomska_klasifikacija,
            parents=NA,
            values= df$budzet)
        
    })
    
    
    output$prihodiTreemap <- renderPlotly({
        df <- prihodi %>% filter(grad == input$grad) %>%
            group_by(ekonomska_klasa)
        df <- summarise(df, budzet = sum(budzet))
        
        plot_ly(
            type='treemap',
            labels=df$ekonomska_klasa,
            parents=NA,
            values= df$budzet)
    })
    
    output$prihodiCard <- renderUI({
       h3("Prihodi", style = "color: green")
    })
    
    output$rashodiCard <- renderUI({
        div(class = "card",
        div(class = "card-body",
            h3("Rashodi", style = "color: red")
            )
        )
        
    })
    
    output$dohodakCard <- renderUI({
        h3("Dohodak")
    })
})
