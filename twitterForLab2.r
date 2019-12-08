#search and analyze twitter data, by Joseph Holler, 2019
#following tutorial at https://www.earthdatascience.org/courses/earth-analytics/get-data-using-apis/use-twitter-api-r/
#also get advice from the rtweet page: https://rtweet.info/
#to do anything, you first need a twitter API token: https://rtweet.info/articles/auth.html 

#install packages for twitter, census, data management, and mapping
install.packages(c("rtweet","tidycensus","tidytext","maps","RPostgres", "igraph","tm", "ggraph", "ggthemes"))
install.packages("ggthemes")
#initialize the libraries
library(rtweet)
library(tidycensus)
library(ggplot2)
library(dplyr)
library(tidyr)
library(RPostgres)
library(tidytext)
library(tm)
library(igraph)
library(ggraph)
library(ggthemes)
library(grep)

#ste up twitter API information
twitter_token <- create_token(
  app = "social_vulnerability",  					#replace ??? with your app name
  consumer_key = "SdaFMknZTHfIpCxe6j6l4MGaR",  		#replace ??? with your consumer key
  consumer_secret = "AYTdWuYyMUaGkar0JiC4fMkBz1GO4bQxFDN0JiWSsDXTucjl14",  #replace ??? with your consumer secret
  access_token = NULL,
  access_secret = NULL
)

#reference for search_tweets function: https://rtweet.info/reference/search_tweets.html 
#don't add any spaces in between variable name and value. i.e. n=1000 is better than n = 1000
#winterTweets will be a new data frame object holding the Twitter data found by search_tweets function
#the first parameter in quotes is the search string, searching tweet contents and hashtags
#n=10000 asks for 10,000 tweets
#if you want more than 18,000 tweets, change retryonratelimit to TRUE and wait 15 minutes for every batch of 18,000
#include_rts=FALSE excludes retweets.
#token refers to the twitter token you defined above for access to your twitter developer account
#geocode is equal to a string with three parts: longitude, latidude, and distance with the units mi for miles or km for kilometers

winterTweets <- search_tweets("freeze OR ice OR snow", n=10000, retryonratelimit=FALSE, include_rts=FALSE, token=twitter_token, geocode="41,-76,550km")

############# TEMPORAL ANALYSIS ############# 

#create temporal data frame & graph it
winterTweetHours <- ts_data(winterTweets, by="hours")
ts_plot(winterTweets, by="hours")

############# NETWORK ANALYSIS ############# 

#create network data frame & graph it
winterTweetNetwork <- network_graph(winterTweetsGeo, "quote")
plot.igraph(winterTweetNetwork)

############# FIND ONLY PRECISE GEOGRAPHIES ############# 

#reference for lat_lng function: https://rtweet.info/reference/lat_lng.html
#adds a lat and long field to the data frame, picked out of the fields you indicate in the c() list
#sample function: lat_lng(x, coords = c("coords_coords", "bbox_coords"))

# list unique/distinct place types to check if you got them all
unique(winterTweets$place_type)

# list and count unique place types
# NA results included based on profile locations, not geotagging / geocoding. If you have these, it indicates that you exhausted the more precise tweets in your search parameters
count(winterTweets, place_type)

#this just copied coordinates for those with specific geographies
#do not use geo_coords! Lat/Lng will come out inverted

#convert GPS coordinates into lat and lng columns
winterTweets <- lat_lng(winterTweets,coords=c("coords_coords"))

#select any tweets with lat and lng columns (from GPS) or designated place types of your choosing
winterTweetsGeo <- subset(winterTweets, place_type == 'city'| place_type == 'neighborhood'| place_type == 'poi' | !is.na(lat))

#convert bounding boxes into centroids for lat and lng columns
winterTweetsGeo <- lat_lng(winterTweetsGeo,coords=c("bbox_coords"))

############# TEXT / CONTEXTUAL ANALYSIS ############# 

winterText <- select(winterTweetsGeo,text)
winterWords <- unnest_tokens(winterText, word, text)

# how many words do you have including the stop words?
count(winterWords)

#create list of stop words (useless words) and add "t.co" twitter links to the list
data("stop_words")
stop_words <- stop_words %>% add_row(word="t.co",lexicon = "SMART")

winterWords <- winterWords %>%
  anti_join(stop_words) %>%
  filter(!word == "rt")

# how many words after removing the stop words?
count(winterWords)

winterWords %>%
  count(word, sort = TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
  labs(x = "Count",
       y = "Unique words",
       title = "Count of unique words found in tweets")

winterWordPairs <- winterTweetsGeo %>% select(text) %>%
  mutate(text = removeWords(text, stop_words$word)) %>%
  unnest_tokens(paired_words, text, token = "ngrams", n = 2)

winterWordPairs <- separate(winterWordPairs, paired_words, c("word1", "word2"),sep=" ")
winterWordPairs <- winterWordPairs %>% count(word1, word2, sort=TRUE)

winterWordPairs %>%
  filter(n >= 25) %>%
  graph_from_data_frame() %>%
  ggraph(layout = "fr") +
  # geom_edge_link(aes(edge_alpha = n, edge_width = n)) +
  geom_node_point(color = "darkslategray4", size = 3) +
  geom_node_text(aes(label = name), vjust = 1.8, size = 3) +
  labs(title = "Word Network: Tweets during the 2013 Colorado Flood Event",
       subtitle = "September 2013 - Text mining twitter data ",
       x = "", y = "") +
  theme_void()

############# SPATIAL ANALYSIS ############# 

Counties <- get_estimates("county",product="population",output="wide",geometry=TRUE,keep_geo_vars=TRUE, key="1fb2d48d1ae3f73a19d620f258ec9f823ad09b25")
NorthEastCounties <- filter(Counties,STATEFP %in% c("09","25","33","44","54","50","36","42","24","10","34","51","39") )

ggplot() +
  geom_sf(data=NorthEastCounties)+
  geom_point(data = winterTweetsGeo, aes(x = lng, y = lat),
             colour = 'purple', alpha = .5) +
  scale_size_continuous(range = c(1, 8),
                        breaks = c(250, 500, 750, 1000)) +
  labs(title = "Tweet Locations During first Winter Weather")


############### UPLOAD RESULTS TO POSTGIS DATABASE ###############

#Connectign to Postgres
#Create a con database connection with the dbConnect function.
#Change the database name, user, and password to your own!
con <- dbConnect(RPostgres::Postgres(), dbname='dsmosm', host='artemis', user='holler', password='pwd') 

#list the database tables, to check if the database is working
dbListTables(con) 

#write data to the database
#replace new_table_name with your new table name
#replace dhshh with the data frame you want to upload to the database 
dbWriteTable(con,'new_table_name',dhshh, overwrite=TRUE)

#disconnect from the database
dbDisconnect(con)