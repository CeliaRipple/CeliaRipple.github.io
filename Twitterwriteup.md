I read an article about using twitter data to predict the outcome of Italian elections. The article can be found here:
https://doi.org/10.1371/journal.pone.0095809

1. The purpose of the research study was to determine if one can acurately predict the outcome of a
national election using twitter data at different scales: national, regional, provincial. Part of Caldarelli et al.'s analysis
was also using the volume of tweets per party to predict the relative popularity of each party. 
This research was inductive because the main purpose was to examine a large volume of tweets and to see if their results 
matched the findings of past studies in this area. 

2. Caldarelli et al. used Twitter API and "Twython" to gather an even larger base of data (12 million tweets). 
Researchers include a link to their data http://www.linkalab.it/data
For their query parameters Caldarelli et al. used the name of the 4 largest parties M5S, PD, PDL, SC, and small (a collection
of the smaller parties); the names of the party leaders as they were mentioned using @ and #s. They included all versions
of the party names and the 8 most popular #s associated with each candidate. The search included all tweets within the 
Italian peninsula, but the researchers used the user profile location to locate tweets instead of the geographic coordinates 
of the tweet. They did this because the user profile rather than the location of the tweet is more often related to 
municipality in which the user will vote. 

3. The research doesn't seem to be reproducible because Caldarelli et al. did not include any information about the functions 
or libraries they used in R to process the data. Part of the data seems reproducible because they provided access to their 
data and their equations for the "Relative Support Parameter" that they used to examine the popularity of each party in 
relation to each other. 

4. For the same reason as above, it would difficult to replicate this study without knowledge of the functions/ libraries 
that they used. However, I think there is enough information for one to desgin a study based on the process of Caldarelli et 
al.

5. Libraries and packages were not included in the study article.  
