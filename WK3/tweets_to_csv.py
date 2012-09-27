#!/usr/bin/python

import json  # Import the library that lets us work with JSON
import csv   # Import the library that lets us read/write CSVs
import time  # We're going to need to deal with a quick time conversion in here

# The path to the file we want to open (change this for your machine)
# This should be the result of the streaming API
infilename = "/Users/Jake/teaching/ITP 2012/data/libya_tweets.json"  

infile = open(infilename, "r") # Open up the file.  "r" says we want to read from it (as opposed to write)

tweets = []  # An empty list to hold the tweets we're going to load
for line in infile:  # Iterate over every line in the file and call it the variable "line"
    try:
        new_tweet = json.loads(line)  # Load in the text and convert it from JSON to a Python dictoinary
    except:
        continue                      # try/except basically says to just keep moving if we fail to
                                      # convert the JSON to a tweet (maybe there's malformed data or something)

    tweets.append(new_tweet)          # Add it to our list of tweets

# Whoa!  That was easy!  Now we have a list of tweets, where each tweet is a dictionary!

first_tweet = tweets[0]
first_tweet["text"]  # The text of the first tweet.  Boom.  

# Here's an example of what's in a typical tweet:

# {
#  "in_reply_to_status_id_str":null,
#  "id_str":"247530200278114304",
#  "text":"Nice work @AnnCoulter: Libya commemorates 9\/11 | http:\/\/t.co\/8yVjg5Ej http:\/\/t.co\/fSPlkhSK",
#  "in_reply_to_screen_name":null,
#  "in_reply_to_user_id_str":null,
#  "favorited":false,
#  "source":"web",
#  "possibly_sensitive_editable":true,
#  "entities":{
#       "hashtags":[],
#       "user_mentions":[
#               {"id_str":"196168350",
#               "indices":[10,21],
#               "screen_name":"AnnCoulter",
#               "name":"Ann Coulter",
#               "id":196168350}
#               ],
#       "urls":[
#               {"indices":[49,69],
#                "url":"http:\/\/t.co\/8yVjg5Ej",
#                "display_url":"StAugustine.com",
#                "expanded_url":"http:\/\/StAugustine.com"
#               },
#               {"indices":[70,90],
#                "url":"http:\/\/t.co\/fSPlkhSK",
#                "display_url":"staugustine.com\/opinions\/2012-\u2026",
#                "expanded_url":"http:\/\/staugustine.com\/opinions\/2012-09-16\/coulter-libya-commemorates-911#.UFaRvlv8T5w.twitter"
#               }
#               ]
#  },
#  "truncated":false,
#  "created_at":"Mon Sep 17 02:59:33 +0000 2012",
#  "place":null,
#  "in_reply_to_user_id":null,
#  "contributors":null,
#  "geo":null,
#  "retweet_count":0,
#  "retweeted":false,
#  "coordinates":null,
#  "user":{
#        "id_str":"131546419",
#        "follow_request_sent":null,
#        "default_profile_image":false,
#        "profile_use_background_image":true,
#        "friends_count":207,
#        "profile_image_url":"http:\/\/a0.twimg.com\/profile_images\/2617221744\/d0sblw2ynv4aqbwmj9wa_normal.png",
#        "is_translator":false,
#        "statuses_count":475,
#        "profile_background_image_url_https":"https:\/\/si0.twimg.com\/profile_background_images\/90887244\/Walleye_Puck.bmp",
#        "favourites_count":0,
#        "profile_text_color":"333333",
#        "followers_count":93,
#        "geo_enabled":false,
#        "profile_background_image_url":"http:\/\/a0.twimg.com\/profile_background_images\/90887244\/Walleye_Puck.bmp",
#        "description":"PROUD Conservative, Full Time Student, Former Business Owner, and Full Time Musician",
#        "profile_link_color":"0084B4",
#        "lang":"en",
#        "notifications":null,
#        "created_at":"Sat Apr 10 16:04:24 +0000 2010",
#        "profile_image_url_https":"https:\/\/si0.twimg.com\/profile_images\/2617221744\/d0sblw2ynv4aqbwmj9wa_normal.png","listed_count":1,
#        "profile_background_color":"C0DEED",
#        "url":null,
#        "contributors_enabled":false,
#        "verified":false,
#        "profile_background_tile":true,
#        "time_zone":"Eastern Time (US & Canada)",
#        "protected":false,
#        "screen_name":"TTownD",
#        "default_profile":false,
#        "following":null,
#        "profile_sidebar_fill_color":"DDEEF6",
#        "name":"Doug ",
#        "location":"TTown",
#        "id":131546419,
#        "utc_offset":-18000,
#        "profile_sidebar_border_color":"C0DEED"
#    },
#    "id":247530200278114304,
#    "possibly_sensitive":false,
#    "in_reply_to_status_id":null
#  }
#
# http://www.scribd.com/doc/30146338/map-of-a-tweet

# Wow, there's a *ton* of stuff in there.  We have all the information about the tweet, including
# structure information about the mentions, hashtags, and links in it, as well as all the user info.  Awesome!

# So all we need to do is iterate through the tweets, pull out the fields we want into a list,
# then save them as a row in a CSV file.  

# Open up the file we want to write to (libya_tweets.csv)
# csvwriter is an object that will write to that file
csvwriter = csv.writer(open("libya_tweets.csv", "w"))
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


    # Having the time be a string is annoying.  Let's use the Python time library to convert
    # the time this tweet was created to a UNIX timestamp (learn more about these here - http://en.wikipedia.org/wiki/Unix_timestamp)
    created_at_seconds = time.mktime(time.strptime(tweet["created_at"], "%a %b %d %H:%M:%S +0000 %Y"))
    
    # Two other quick things we should think about:
    # 1)  I'd like us to record the hashtags, links, and mentions in each tweet, but they're in this variable length
    #     format (i.e. there could be 0, 1, 3, 100, who knows).  Since CSVs are fixed width, why don't we just
    #     take the first two of each, accounting for the case where there are none.
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
            mention2 = tweet["entities"]["user_mentions"][1]["screen_name"]

    # 2)  I'd also like us to record geo data, if it exists
    lat = None
    lon = None
    if tweet["geo"]:
        lat = tweet["geo"]["coordinates"][0]
        lon = tweet["geo"]["coordinates"][1]

    # OK!  Let's write this tweet!
    newrow = [tweet_id, retweet, text, source, screen_name, name, location, description, followers, following, created_at, created_at_seconds, hashtag1, hashtag2, url1, url2, mention1, mention2, lat, lon]
    # Oop, one thing we need to do is convert everything to UTF8 before we write...
    for i in range(len(newrow)):  # For every value in our newrow
        if hasattr(newrow[i], 'encode'):
            newrow[i] = newrow[i].encode('utf8')

    # Write it!
    csvwriter.writerow(newrow)

# Done!