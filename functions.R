library(lazyeval)
plot_treemap <- function(budget_df, city){
  df <- budget_df %>% filter(grad == city)
  
  # Several grupa's can have the same ekonomska_klasa inside them so we need a group by both of these variables to make them unique
  # We will take the sum of the groups (tibble groups) as their budgets since the functions of their entries are similar enough
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

prepare_data_for_barplot <- function(df, city){
  df <- df %>% filter(grad == city) %>%
    group_by(grupa)
  df <- summarise(df, budzet = sum(ukupno))
  df <- df %>% arrange(desc(budzet))
  df <- df[1:5,] # In case there are multiple rows with the same budget
  
  df
}

