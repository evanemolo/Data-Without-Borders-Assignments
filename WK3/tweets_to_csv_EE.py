#!/usr/bin/python

# library imports
import json
import csv
import time

# path to file:
infilename = "/Users/evanemolo/Dropbox/_ITP/_Fall_2012/DWB/HW/WK3/NYC_tweets.json"

infile = open(infilename, "r") # open the file. "r" says we want to read from it

tweets = [] # empty list
for line in infile:
    try:
        new_tweet = json.loads(line) # load in text and convert to dictionary
    except:
        continue 

    tweets.append(new_tweet) # add it to our list of tweets

first_tweet = tweets[0] # first tweet in list
first_tweet["text"]

csvwriter = csv.writer(open("nyc_tweets.csv", "w"))
csvwriter.writerow(["tweet_id", "retweet", "text", "source", "screen_name", "name", "location", "description", "followers", "following", "created_at", "created_at_seconds", "hashtag1", "hashtag2", "url1", "url2", "mention1", "mention2", "lat", "lon"])
for tweet in tweets:
    # This will loop over the tweets list and, for each iteration, the "tweet" variable will stand in for each tweet.
    # csv writer writes out whatever list of things you give it to a row of the CSV, so let's construct a row
    # of the variables we want.
    tweet_id = tweet["id_str"]
    retweet = tweet["in_reply_to_status_id_str"]
    # Sometimes the retweet ID isn't in that field, so let's check and see if it's in this other field
    if not retweet and "retweeted_status" in tweet and tweet["retweeted_status"]:
        retweet = tweet["retweeted_status"]["id_str"]
    text = tweet["text"]
    source = tweet["source"]
    screen_name = tweet["user"]["screen_name"]
    name = tweet["user"]["name"]
    location = tweet["user"]["location"]
    description = tweet["user"]["description"]
    followers = tweet["user"]["followers_count"]
    following = tweet["user"]["friends_count"]
    created_at = tweet["user"]["created_at"]

    # convert time in tweet to UNIX time stamp
    created_at_seconds = time.mktime(time.strptime(tweet["created_at"], "%a %b %d %H:%M:%S +0000 %Y"))
    # record hashtags, links, and mentions in each tweet
    # convert from variable length format to fixed width for .csv
    hashtag1 = None
    hashtag2 = None
    if "hashtags" in tweet["entities"] and len(tweet["entities"]["hashtags"]):
        hashtag1 = tweet["entities"]["hashtags"][0]["text"]
        if len(tweet["entities"]["hashtags"]) > 1:
            hashtag2 = tweet["entities"]["hashtags"][1]["text"]

    url1 = None
    url2 = None
    if "urls" in tweet["entities"] and len(tweet["entities"]["urls"]):
        url1 = tweet["entities"]["urls"][0]["url"]
        if len(tweet["entities"]["urls"]) > 1:
            url2 = tweet["entities"]["urls"][1]["url"]

    mention1 = None
    mention2 = None
    if "user_mentions" in tweet["entities"] and len(tweet["entities"]["user_mentions"]):
        mention1 = tweet["entities"]["user_mentions"][0]["screen_name"]
        if len(tweet["entities"]["user_mentions"]) > 1:
            mentions2 = tweet["entities"]["user_mentions"][1]["screen_name"]

    # record geo data if it exists
    lat = None
    lon = None
    if tweet["geo"]:
        lat = tweet["geo"]["coordinates"][0]
        lon = tweet["geo"]["coordinates"][0]

    # write the tweet in UTF-8
    newrow = [tweet_id, retweet, text, source, screen_name, name, location, description, followers, following, created_at, created_at_seconds, hashtag1, hashtag2, url1, url2, mention1, mention2, lat, lon]
    for i in range(len(newrow)): # for every value in new row
        if hasattr(newrow[i], 'encode'):
            newrow[i] = newrow[i].encode('utf8')

    csvwriter.writerow(newrow)

# DONE