# Reflection

## So Far

Right now, there are 3 pages implemented in our dashboard using R Dash. The first is the ''Geographic Sales Distribution'', which includes a map and a line plot of sales. The second is a highly-filterable bar chart of the ''top games''. The last is a histogram of sales and a pie chart of several categorical variables. 


## Using R

Building a dashboard in R is different than building one in Python. R has far less documentation, and the syntax is obviously different. One issue is that converting ggplots to plotly objects using the ggplotly() function doesn't always work. For example, this was the case with the pie chart. ggplotly() cannot convert it, so I had to recode it natively in plotly. 


## Challenges

For some reason, heatmaps, it seems as though both ggplots and native plotly ones are not supported in R Dash. I tried for several hours to get any sort of heatmap to render, and it simply would not. This is why the app sketch has 4 pages, but this implementation only has 3. I am not sure what is causing this issue. 



## Improvements

In order to make this dashboard better, the following could be implemented: 

* clicking on the map changes the line plot to display sales from only that region
* aesthetic changes to make the dashboard look like a retro video game (red and grey colors, adding a see-through background, adding borders around filtering options, etc.)
* somehow figure out how to render the heatmap for the last tab, or compensate for this plot somehow
* removing the `.Primitive("names")` from the map tooltip
* fixing/cleaning up the `topgames` bar chart tooltip
* better scaling on the sales histogram when the log axis is disabled
