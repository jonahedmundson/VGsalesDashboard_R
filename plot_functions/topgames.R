# library(ggplot2)
# library(tidyverse)
# 
#df = read.csv('../data/vgsales-cleaned.csv', stringsAsFactors = TRUE)

#N = 5
topgames = function(df_temp,sales_type,N=5){
  figure = df_temp[1:N,] %>%
  ggplot(aes(x=get(sales_type), y=forcats::fct_reorder(Name_short, get(sales_type)))) +
  geom_col(fill="#006400") + 
  ggthemes::theme_few() +
  ylab('') + 
  xlab('Global Sales (millions)') + 
  scale_x_continuous(labels = scales::label_dollar())
  
  ggplotly(figure)
}


