library(ggplot2)
library(lubridate)

df = read.csv('../data/vgsales-cleaned.csv', stringsAsFactors = TRUE)


test = df %>%
  ggplot(aes(x=Publisher_grouped, y=Genre)) + 
  geom_bin2d() 
counts = ggplot_build(test)$data[[1]]['count']



df %>%
  ggplot(aes(x=Publisher_grouped, y=Platform_grouped)) + 
  geom_bin2d(na.rm=TRUE) + 
  scale_fill_gradient(low = "white", high = "steelblue")
  #scale_fill_viridis_c()
