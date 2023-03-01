# library(ggplot2)
# library(tidyverse)
# 
# df = read.csv('../data/vgsales-cleaned.csv', stringsAsFactors = TRUE)
# 
# location = 'Global_Sales'

sales_hist = function(df, log, sales_type){
  figure = df %>%
  ggplot(aes(x=get(sales_type))) + 
  geom_histogram(fill='#006400', binwidth = 1) + 
  ggthemes::theme_few() + 
  xlab(paste(sales_type, '(millions)')) + 
  ylab(paste(log, 'Count')) + 
  scale_x_continuous(labels = scales::label_dollar(), limits = c(0, median(df[,sales_type])+20*sd(df[,sales_type]))) 
  
  if (length(log) != 0){
    ggplotly((figure + scale_y_log10())) 
  } else {
    ggplotly(figure)
  }
}

