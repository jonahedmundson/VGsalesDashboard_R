# VGsalesDashboard
A dashboard for video game sales using Dash.

The GitHub for this project can be found [here](https://github.com/jonahedmundson/VGsalesDashboard_R).

<!-- ~You can find the deployed app [here](https://vg-sales-r.herokuapp.com/).~ -->

(This dashboard was accruing charges, so I took it down. I have included some images below. Additionally, you can run a local live version of the dashboard by pasting `Rscript dashboard.R` into your terminal. You can also watch a video of me using the dashboard [here](https://www.youtube.com/watch?v=Xjt4mht_LyI).)

You can find the Python version of this same dashboard [here](https://github.com/a-foote/VGsalesDashboard).


![deployed dashboard 1](./app_sketch/dashboard_live.png)

![deployed dashboard 2](./app_sketch/dashboard_live2.png)

![deployed dashboard 3](./app_sketch/dashboard_live3.png)




## Data Source

You can find the dataset [here](https://www.kaggle.com/datasets/thedevastator/global-video-game-sales).


## App Description

The main page of the dashboard will be a map of the world that is colored like a heatmap based on total game sales. On the right hand side, there will be a line plot (with a confidence interval ribbon) showing global sales over time. As the user drags their mouse over the available regions, the line plot will update to show the sales for that particular region. A two-sided slider on the bottom will allow the user to select the date range that they would like to view.

The second page will have a heatmap. A dropdown menu on the left-hand side will allow users to select what they want to display on the x and y axes. Options will be `genre`, `publisher` and `platform`. A two-sided slider will allow the user to filter on year.

The third page will have a bar chart showing the sales (in dollars) of the top 5 best-selling games. A menu on the left-hand side will allow the user to filter by `region`, `year`, `genre`, `publisher` and `platform`. A slider on the bottom will allow the user to choose how many games are shown (ie. 1-20). When the user hovers over a bar, the full name of the game is displayed, as well as the sales of that game in dollars (game names are truncated on x axis).

The last/fourth page will have both a histogram (left-hand side) and a pie chart (right-hand side). The histogram will show the distribution of sales. A dropdown above the plot will allow users to filter by region. A tick box below will allow users to log-scale the y axis. The pie chart will show the breakdown of several categorical variables. A dropdown above will allow users to select either `genre`, `Publisher` or `Platform`.



## App Sketch

### Page 1

![Video Game Sales Dashboard, Page 1](./app_sketch/page1.png)


### Page 2

![Video Game Sales Dashboard, Page 2](./app_sketch/page2.png)



### Page 3

![Video Game Sales Dashboard, Page 3](./app_sketch/page3.png)



### Page 4

![Video Game Sales Dashboard, Page 4](./app_sketch/page4.png)




## Other Files

You can find our `Code of Conduct` [here](./doc/project_guidelines/CODE_OF_CONDUCT.md).

You can find our `Team Contract` [here](./doc/project_guidelines/team-contract.md).

You can find our `Contributions` document [here](./doc/project_guidelines/CONTRIBUTING.md).
