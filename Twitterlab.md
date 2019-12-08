First we uploaded the two collections of tweets into a PostGIS database using te "UPLOAD RESULTS TO POSTGIS DATABASE" section from the R code above. We also used the " 
# Twitter Lab

# Introduction: 
Twitter, like other forms of social media, is a source of big data on the everyday experiences of people. With the rise of 
twitter communications geograhpers are exploring whether twitter data can be used to track major events like natural disasters and political events. In this lab, we used twitter data on Hurricane Dorian from November 2019 to explore whether the real storm or the storm of fake news from President Trump about the path of the storm generated more tweet content. The goal of this lab was to make a heat map (kernal density) in QGIS that showed areas with a high rate of tweets about Hurricane Dorian, and two maps- one that showed the hot spots and cold spots of Dorian tweets and another that identified the counties where the difference was statistically significant based one p values 0.05, 0.01, 0.001. 
![Heatmap](dorianheatmap.png)
![Hotspot](countiesGetisOrdMapFrame.png)
![Statistical Significance](counties2GetisOrdMapFrame.png)

# Data 
For this lab we used two collections of tweets: 
One related to Hurricane Dorian defined by keywords: fill in 
Another for the baseline tweets for November that we will use to normalize the Dorian tweets by location.
We downloaded this data via Twitter API using a developer acount. The maximum number of tweets returned for one token is 18,000 tweets. 
We also used the projected coordinate system: SA Contiguous Lambert Conformal Conic projection from https://www.spatialreference.org The SRS is 102004 . There is a PostGIS insert statement to add the coordinate system to a database.
And we used county level geographic and population data from the US census. The R code we used for this is included in the 
the next link
For this lab we used Rstudio, PostGIS, GeoDa, and QGIS

# Process 
[Full R code](twitterForLab2.r)  

First we uploaded the two collections of tweets into a PostGIS database using te "UPLOAD RESULTS TO POSTGIS DATABASE" section from the R code above. We also used the "SPATIAL ANALYSIS" section to download the county level geographic data using the Census API. 
Once everything was downloaded into the PostGIS database we used the SQl code here: 
[Full SQL code](lab10notes.sql)
to run though the next set of steps: 

First, 
