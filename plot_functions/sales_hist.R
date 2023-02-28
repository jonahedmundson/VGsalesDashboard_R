# library(ggplot2)
# library(tidyverse)
# 
# df = read.csv('../data/vgsales-cleaned.csv', stringsAsFactors = TRUE)
# 
# location = 'Global_Sales'

sales_hist = df %>%
  ggplot(aes(x=Global_Sales)) + 
  geom_histogram(fill='#006400', binwidth = 1) + 
  ggthemes::theme_few() + 
  xlab('Global Sales (millions)') + 
  ylab('Log of Count') + 
  scale_x_continuous(labels = scales::label_dollar(), limits = c(0, median(df[,'Global_Sales'])+20*sd(df[,'Global_Sales']))) + 
  scale_y_log10() 

