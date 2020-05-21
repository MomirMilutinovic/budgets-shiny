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
    
    output$treemap <- renderPlot({
        df <- rashodi %>% filter(grad == input$grad) %>%
            group_by(ekonomska_klasifikacija)
        df <- summarise(df, budzet = sum(budzet))
        df <- df %>% top_n(n = 5) %>% arrange(budzet)
        df$budzet <- df$budzet * -1
        
        
        df %>% ggplot(aes(x=ekonomska_klasifikacija, y=budzet, area = budzet, fill = ekonomska_klasifikacija)) +
            geom_treemap() +
            theme(text = element_text(size=12)) +
            scale_x_discrete(labels = function(x) str_wrap(x, width = 15)) +
            ggtitle("Prvih 5 stavki po rashodu") +
            xlab("Stavka") +
            ylab("Rashod u RSD") +
            theme_minimal()
    })

})
