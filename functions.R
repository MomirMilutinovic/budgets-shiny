library(lazyeval)
plot_treemap <- function(budget_df, city){
  # Creates the treemap of either spending or earning
  # @param budget_df Either prihodi or rashodi
  # @param city The name of the city for which to plot the data
  # @return Returns a plotly plot which contains the treemap of either earning or spending
  
  df <- budget_df %>% filter(grad == city)
  
  # Creates unique labels for use in the treemap
  df <- df %>% group_by(ekonomska_klasa, grupa)
  df <- df %>% summarise(ukupno = sum(ukupno))
  df <- as.data.frame(df) %>% mutate(ekonomska_klasa = paste(ekonomska_klasa, "-", grupa))
  
  df_by_grupa <- budget_df %>% filter(grad == city) %>%
    group_by(grupa)
  df_by_grupa <- df_by_grupa %>% summarise(budzet = sum(ukupno))
  
  plot_ly(
    type='treemap',
    branchvalues="total",
    labels=c(df_by_grupa$grupa, df$ekonomska_klasa),
    parents=c(rep(NA, length(df_by_grupa$grupa)), df$grupa),
    values= c(df_by_grupa$budzet, df$ukupno))
}

plot_top_earning_or_spending <- function(df, title, xlabel, ylabel, color){
  # Creates the barplot of top areas of either spending or earning
  # @param df The budget data to plot
  # @param title Title of the plot
  # @param xlabel X axis label of the plot
  # @param ylabel Y axis label of the plot
  # @param color Color of the bars
  # @return Returns the barplot of top areas of spending or earning depending on df parameter
  
  df$grupa <- factor(df$grupa, levels = df$grupa[order(df$budzet)])
  
  plot <- df %>% ggplot(aes(x=grupa, y=budzet)) +
    geom_col(fill = color, color="black") +
    theme(text = element_text(size=12)) +
    scale_x_discrete(labels = function(x) str_wrap(x, width = 15)) +
    ggtitle(title) +
    xlab(xlabel) +
    ylab(ylabel) +
    theme_minimal()
  
  plot
}

prepare_data_for_barplot <- function(budget_df, city){
  # Gets the top 5 areas of either earning or spending for use in a barplot
  # @param budget_df Either prihodi or rashodi
  # @param city The name of the city for which to plot the data
  # @return Returns a tibble with the top areas of either earning or spending
  
  df <- budget_df %>% filter(grad == city) %>%
    group_by(grupa)
  df <- summarise(df, budzet = sum(ukupno))
  df <- df %>% arrange(desc(budzet))
  df <- df[1:5,] # In case there are multiple rows with the same budget
  
  df
}

