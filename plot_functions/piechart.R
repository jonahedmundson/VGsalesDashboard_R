# library(ggplot2)
# library(tidyverse)
# 
# df = read.csv('../data/vgsales-cleaned.csv', stringsAsFactors = TRUE)



# bars = data.frame(
#   'counts' = unname(summary(df$Genre)),
#   'category' = levels(df$Genre)
# )
# bars$percentage = round(bars$counts*100 / sum(bars$counts))


#doesnt convert to plotly??
# piechart = bars %>%
#   ggplot(aes(x="", y=counts, fill=category)) +
#   geom_bar(stat="identity", width=1) +
#   coord_polar("y", start=0) + 
#   theme_void() + 
#   geom_text(aes(label = paste0(percentage, "%"), x =  1.35), position = position_stack(vjust=0.5)) +
#   labs(x = NULL, y = NULL, fill = NULL) + 
#   theme(legend.key.size = unit(.4, 'cm'))


#library(plotly)
piechart <- function(piedata){
  figure = plot_ly(piedata, 
    labels = ~category, 
    values = ~counts, 
    type = 'pie') %>% 
  layout(title = '',
    xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
    yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE)
  )
  figure
}