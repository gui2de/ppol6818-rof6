## STATA 3

## PART 1 
Overall we see that increasing the sample size increases the precision of beta estimates, reduces standard errors, and narrows confidence intervals. This can be seen in the graphs and table below.

In the boxplot below, we see that as N increases the variation in the beta estimates reduces. The interquartile range decreases substantially as N increases from 10 to 1000, showing that beta estimates are more accurate with larger samples. Moreover, the smaller sample sizes have more outliers (points beyond the whiskers).

 ![Boxplot](./box.png)


This is also represented in the histogram below, whereby it can be seen that N increases, the distribution goes from being spread around the mean to tall and narrow (N=1000).

 ![Histogram](./part_one.png)


Finally, in the table below we see that the confidence interval narrows as N gets larger and that the standard error of the beta estimates reduces significantly as the sample size increases.

 ![Table](./table_one.png)



## PART 2

 ![Histogramparttwo](./part2graph.jpg)

We see that as N increases the spread of beta coefficients narrows and becomes more precise. When N is 4, the spread of estimates is much greater compared to when N increases beyond 1,000/10,0000.


  ![Box](./boxpart2.png)

In the boxplot below for part 2, we see that as N increases the variation in the beta estimates reduces, much like in part 1. 

  
  ![tablepart2](./part2table.png)


In the table above we see that the confidence interval narrows as N gets larger and that the standard error of the beta estimates reduces significantly as the sample size increases. The standard errors does not change significantly, although it gets closer to 10 as the sample size increases. The confidence interval gets smaller and smaller as the sample size increases.

## PART 1 vs PART 2 

We see that for N = 10, the width of the confidence interval is very similar ~0.6. For N = 100, the width of the CI for part 1 is 0.157 whereas, for part 2 it is 0.153. This can be understood/expected since in part 1, we are pulling a sample of e..g, 100 from a dataset of 10,000 whereas, in part 2, we are regressing on a population of 100, therefore, it is not surprising that the accuracy between both parts is relatively similar. Moreover, for both parts 1 and 2, we see the same pattern as the sample size increases, whereby the estimates become more and more accurate.

