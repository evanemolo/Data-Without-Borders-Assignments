tweets = read.csv("/Users/evanemolo/Dropbox/_ITP/_Fall_2012/DWB/HW/WK3/libya_tweets.csv", as.is = TRUE)

# Part 1

# How many unique users have more than 100000 followers?
# What are their screen names?
# create a logical vector for more than 100000 followers:
many.followers = tweets$followers > 100000
# create subset of these users
head.honchos = tweets[many.followers,]
# make sure they're unique users
unique(head.honchos$screen_name)
# count them up:
length(unique(head.honchos$screen_name))

# What are the top 3 locations people are from (not counting blanks)?
# create a var using a logic vector to determine which tweets have a location listed
subset.location.bool = nchar(tweets$location) > 0
# list the tweets that have a location listed
locations.with.names = which(subset.location.bool == TRUE)
# create a subset with the locations.with.names var, 
location.subset = tweets[locations.with.names,]
# and target the "location" column
location.subset["location"]
# then create a table, rev-sort it, and target the first 3 locations
rev(sort(table(location.subset["location"])))[1:3]

# What is the text of the tweet that was retweeted the most times and who tweeted it?
# get the retweet id of the tweet retweeted the most times
which.max(rev(sort(table(tweets$retweet))))
# 247533773971918848
# which index numbers have this retweet id?
which(tweets$retweet == 247533773971918848)
# [1]  141  145  194  206  207  229  390 1944
# target one of these index numbers, and pull the text:
 tweets$text[141]

# Plot the distribution of the number of people the users are following. What do you see? 
following = tweets$following
hist(following, breaks=1000)
hist(following, breaks=2000, xlim = c(0,3000))
# Most users follow less than 100 other users. There are some outliers who follow more than 
# 150000 other users.

# Let’s reduce our set to just people with fewer than 5000 followers and look 
# at the histogram again. What do you see now? Have you tried using different breaks? 
# Does anything surprise you?
five.K.or.less.followers = tweets[tweets$followers, ]
hist(five.K.or.less.followers$followers, breaks=10000, xlim= c(0,10000))
# Most individuals have less than 500 followers

# Part 2

# Write code to find the 5 most popular words used in the descriptions of our users

# use strsplit() to seperate the words in the description
split.description = strsplit(tweets$description, split = "[^a-zA-Z0-9]+")
# use unlist() to turn the list into a vector
split.description = unlist(strsplit(tweets$description, split = "[^a-zA-Z0-9]+"))
# use tolower() to convert all words to lower case to reduce duplicates
split.description = tolower(unlist(strsplit(tweets$description, split = "[^a-zA-Z0-9]+")))
# count the number of occurances of each word, and pull the top five
rev(sort(table(split.description)))[1:5]
# wait...get rid of the stopwords
# load up the .csv of stopwords
stopwords = read.csv("/Users/evanemolo/Dropbox/_ITP/_Fall_2012/DWB/HW/WK3/english-stopwords.csv", as.is=TRUE, header=F)
# append extraneous chars and "http" to stopwords for removal
stopwords = c(stopwords, "", "&", "-", "|", "http")
# turn stopwords into a vector
stopwords = unlist(stopwords)
# use %in% to remove the stopwords from split.description
split.desc.clean = split.description[!(split.description %in% stopwords)]
# reverse sort the vector, and target the first five index numbers
rev(sort(table(split.desc.clean)))[1:5]

#  news   conservative    world   love    follow 
#  317        150          145     135     126 
# What do you think of the results? Do you have a sense of what types of users are 
# most common in our dataset?

# Considering these words are taken out of context, it's difficult to get a good feel
# for how these words are being used. Do these Twitter accounts represent
# individuals with conservative views who love world news, and included a link to their 
# blog/website in their description? There's not enough information to say.

# Part 3

# The dataset is tweets within an NYC bounding box from Tuesday night
nyc.tweets = read.csv("/Users/evanemolo/Dropbox/_ITP/_Fall_2012/DWB/HW/WK3/nyc_tweets.csv", as.is = TRUE) 

# What were people talking about in NYC around 9pm Tuesday night? 
split.nyc.text = strsplit(nyc.tweets$text, split = "[^a-zA-Z0-9]+")
split.nyc.text = unlist(strsplit(nyc.tweets$text, split = "[^a-zA-Z0-9]+"))
split.nyc.text = tolower(unlist(strsplit(nyc.tweets$text, split = "[^a-zA-Z0-9]+")))
split.nyc.text.clean = split.nyc.text[ !(split.nyc.text %in% stopwords)]
rev(sort(table(split.nyc.text.clean)))[1:5]
# ny love  lol  amp york 
# 242  235  210  207  172 

# What do people in NYC love so much?
love.tweets = grep("love", nyc.tweets$text)
love.tweets.subset = nyc.tweets[love.tweets, ]
split.love.tweets = tolower(unlist(strsplit(love.tweets.subset$text, split = "[^a-zA-Z0-9]+")))
love.stopwords = c(stopwords, "love", "loved", "loves")
split.love.tweets.clean = split.love.tweets[ !(split.love.tweets %in% love.stopwords)]
rev(sort(table(split.love.tweets.clean)))[1:10]
 # lt        3     show  friends watching      don      lol     kiss    world    tweet 
#  13       13        9        9        8        8        7        6        5        5





