library(ggplot2)
library(lubridate)

df = read.csv('../data/vgsales-cleaned.csv', stringsAsFactors = TRUE)
df[,'Year'] = year(as.Date(df[,'Year']))

#making CI
CI = df %>%
  group_by(Year) %>%
  summarize(
    #low = quantile(Global_Sales, probs=.25, na.rm=TRUE, names=FALSE),
    low = sum(Global_Sales) - length(Global_Sales)*qt(0.999,df=nrow(df)-1)*sd(Global_Sales)/sqrt(nrow(df)),
    mean = mean(Global_Sales),
    sum = sum(Global_Sales),
    #high = quantile(Global_Sales, probs=.75, na.rm=TRUE, names=FALSE)
    high = sum(Global_Sales) + length(Global_Sales)*qt(0.999,df=nrow(df)-1)*sd(Global_Sales)/sqrt(nrow(df)),
    row = length(Global_Sales)
  )


CI %>%
  ggplot(aes(x=Year, y=sum)) +
  geom_line(colour='#006400', lwd=1.1) +
  geom_point(colour='#006400') +
  geom_ribbon(aes(ymin=low, ymax=high), alpha=0.2, fill='#006400') + #   #ffff00
  ggthemes::theme_clean() +
  ylab('Sum of Sales (millions)') + 
  scale_y_continuous(labels = scales::label_dollar())
