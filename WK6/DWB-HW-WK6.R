# Data Without Borders Week 6 Homework

# Part 1

# Import the data and TTR library:
#tweets = read.csv("http://jakeporway.com/teaching/data/tweets2009.csv", header=FALSE, as.is=TRUE)
tweets = read.csv("/Users/evanemolo/Dropbox/_ITP/_Fall_2012/DWB/HW/WK6/tweets2009.csv", as.is=TRUE, header=FALSE)
library("TTR")
# Assign a vector to the names() function to name the columns
names(tweets) = c("time", "seconds", "screen_name", "text")
# Plot the time series, first create a histogram of the data:
tweets.hist = hist(tweets$seconds, breaks=500)
# And plot it as a line:
plot(tweets.hist$counts, type='l') # counts is number of plots in each bin
# Figure out if there are any cycles / seasonal trends in this data with acf()
tweets.autocorrelation = acf(tweets.hist$counts, lag.max=200)
# Use order() to find where the lag values for which the signal most overlaps itself
rev(order(tweets.autocorrelation$acf))
# The signal repeats itself at a lag of 179, indicating a cycle
# Remove the cycles and analyze the data
# First, create a time series object with the ts() function
tweets.ts = ts(tweets.hist$counts, freq=179)
# Now use decompose() to break it into trend, random and seasonal
tweets.parts = decompose(tweets.ts)
# And plot it:
plot(tweets.parts)
# What do you see?
# The amount of tweets decrease over the course of the 5 days, with a slight uptick on the fourth day

# Part 2

# Let's search the tweets for "Iran" using grep()
iran.tweets = tweets[grep("iran", ignore.case=TRUE, tweets$text), ]
# Plot the time series for iran.tweets
iran.tweets.hist = hist(iran.tweets$seconds, breaks=100)
plot(iran.tweets.hist$counts, type='l')
# Mark the three largest peaks on the time series
abline(v=which(iran.tweets.hist$counts > 30), col=2)
# Set up the time series for SMA (moving average)
iran.tweets.ts = ts(iran.tweets.hist$counts, start=c(1244745260,1))
plot.ts(iran.tweets.ts)
iran.tweets.ts.sma = SMA(iran.tweets.ts)
plot.ts(iran.tweets.ts.sma)
# Build a basic event detection algorithm with the diff() function
# and a lag of 5
iran.tweets.velocity = diff(iran.tweets.ts.sma, lag=5)
plot.ts(iran.tweets.velocity)
# Show both the SMA graph and the velocity graph
par(mfrow=c(2,1))
plot.ts(iran.tweets.ts.sma, type='l', main="Moving Average of Tweets")
plot.ts(iran.tweets.velocity, type='l', main="Velocity")
# What do you see?
# The highest increase in tweet volume corresponds to the increase
# in the moving average of tweets
# Can we figure out what time the tweets started increasing using your 
# results from diff?
# Pull 20 or so tweets from around that time and write down why you think
# they’re increasing based on what people are saying.
# Where is the spike on the velocity chart?
which.max(iran.tweets.velocity)
# row 38
# Now look at tweets near that peak
iran.tweets[38:58, "text"]
# People are talking about:
# Iranian election results are reported; both candidates claim victory...

