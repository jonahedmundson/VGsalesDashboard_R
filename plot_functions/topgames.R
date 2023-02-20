# library(ggplot2)
# library(tidyverse)
# 
#df = read.csv('../data/vgsales-cleaned.csv', stringsAsFactors = TRUE)

#N = 5
topgames = df[1:N,] %>%
  ggplot(aes(x=Global_Sales, y=forcats::fct_reorder(Name_short, Global_Sales))) +
  geom_col(fill="#006400") + 
  ggthemes::theme_few() +
  ylab('') + 
  xlab('Global Sales (millions)') + 
  scale_x_continuous(labels = scales::label_dollar())


