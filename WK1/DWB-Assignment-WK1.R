# DWB - Assignment 1

# Part One

# How many women were stopped?  
sum(data$sex == "F")
[1] 3927

# What percentage of the stops is this?
sum(data$sex == "F") / length(data$sex)
[1] 0.06760316

# How many different kinds of suspected crimes are there?
length(table(data$crime.suspected))
[1] 1356

# What do you think about that?
# A lot of the suspected crimes are duplicates due to mispellings and abbrevations.

# Which precinct had the most stops?  How many were there?
max(table(data$precinct))
[1] 2597
which(table(data$precinct) == 2597)
47

# Which precinct had the least stops?
min(table(data$precinct))
[1] 139
which(table(data$precinct) == 139)
13

# How many people between 18 and 30 were stopped?
sum(data$age >= 18 & data$age <= 30)
[1] 29865

# Find the number of people who were given the full treatment:  frisked, searched, 
# and then arrested
length(which(data$frisked == 1 & data$searched == 1 & data$arrested == 1))
[1] 1829

# Make a histogram of their ages.
frisk.search.arrest = which(data$frisked == 1 & data$searched == 1 & data$arrested == 1)
# create subset from rows selected in above variable
subset.of.people = data[frisk.search.arrest, ]
# target "age" column
subset.of.people.age = subset.of.people$age
hist(subset.of.people.age)

# Part Two

# NYC Bike Rack Locations

# URL: https://www.google.com/fusiontables/DataSource?docid=1IjJSw2MpTXL64gqUWKN45-FgnbISMs_sVcC1Kw

# This dataset contains the latitude, longitude, address, and a brief description of bike rake locations within NYC. 
# The description details the address, the number of bike racks, and classifies the racks as large or small.
# Speaking specifically to how the dataset is organized, it would be helpful to parse out bike rack size 
# classifications and number of bike racks into their own columns.
# Based on a plot of the latitude and longitude columns, it appears most bike rakes are between 
# 40.7 and 40.8 latitude, and -74 longitude, which spans the across Manhattan.

# I achieved the plot with the following code in R:

bike.rack.data = read.csv("/Users/evanemolo/Dropbox/_ITP/_Fall_2012/DWB/HW/NYC-Bike-Rack-locations.csv", header=TRUE, as.is=TRUE)
bike.racks.lat.long = bike.rack.data[,c("Latitude","Longitude")]
plot(bike.racks.lat.long)