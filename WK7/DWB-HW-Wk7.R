# DWB Homework Assignment 7

# Crime Mapping

# Create a common column between the snf dataset and geo dataset

# Import data sets
snf = read.csv("/Users/evanemolo/Dropbox/_ITP/_Fall_2012/DWB/HW/WK7/snf_3.csv", as.is=T, header=T)
geo = read.csv("/Users/evanemolo/Dropbox/_ITP/_Fall_2012/DWB/HW/WK7/geo.csv", as.is=T, header=T)
# Combine the x and y values in snf into their own column
snf$xy = paste(snf$x, ",", snf$y, sep="")
# Combine the x and y values in geo into their own column
geo$xy = paste(geo$xcoord, ",", geo$ycoord, sep="")
# Now merge the two datasets by the 'xy' column
merged = merge(snf, geo, by="xy")

# Mapping

# Let's map the merged data

# Import the maps library
library(maps)
# Load up New York City
map('county', 'new york', xlim=c(-74.25026, -73.70196), ylim=c(40.50553, 40.91289), mar=c(0,0,0,0))
# Add the data points from our merged data
points(merged$lon, merged$lat, col=rgb(200, 0, 0, 50, maxColorVal=255), pch=19, cex=0.8)
# Q: What do you see?
# The data points overlap each other, so there's not much to extrapolate. However, the points do fall
# within the boundaries of the city

# Colors

# Plot the points using colors to explore where each race is being stopped

# Method 1 — using hardcoded numbers for col=
map('county', 'new york', xlim=c(-74.25026, -73.70196), ylim=c(40.50553, 40.91289), mar=c(0,0,0,0))
# Factor the race coding from qualitative to numerical data
race.factored = as.factor(merged$race)
race.numeric = as.numeric(race.factored)
# Append this subset to the merged data frame:
merged$race.numeric = race.numeric
# Plot the points on the map, iterating through the race codes 
points(merged$lon, merged$lat, col=merged$race.numeric, pch=19, cex=0.8)

# Method 2 — custom colors
map('county', 'new york', xlim=c(-74.25026, -73.70196), ylim=c(40.50553, 40.91289), mar=c(0,0,0,0))
# Create a data frame of races and corresponding rgb colors
colors = read.table("/Users/evanemolo/Dropbox/_ITP/_Fall_2012/DWB/HW/WK7/colors3.csv", sep=",", as.is=T, header=T)
# Merge it with your "merged" dataframe 
merged.colors = merge(merged, colors, by="race")
# Create variables to accept the rgba values per column
r=merged.colors$r
g=merged.colors$g
b=merged.colors$b
a=merged.colors$a
points(merged.colors$lon, merged.colors$lat, col=rgb(r, g, b, a, maxColorVal=255), pch=19, cex=0.8)

# Method 3 — color brewer palettes
map('county', 'new york', xlim=c(-74.25026, -73.70196), ylim=c(40.50553, 40.91289), mar=c(0,0,0,0))
# Pick a color brewer scheme
brewer = brewer.pal(8, "Set1")
brewer.colors = read.table("/Users/evanemolo/Dropbox/_ITP/_Fall_2012/DWB/HW/WK7/brewer-colors.csv", sep=",", as.is=T, header=T)
merged.brewer.colors = merge(merged, brewer.colors, by="race")
points(merged.brewer.colors$lon, merged.brewer.colors$lat, col=merged.brewer.colors$brewer, pch=19, cex=0.8)

# Lets make a movie

# Animate the stops as they occur over the course of a month
library(animation)
# convert the times into a POSIXlt format
library(lubridate)
times = as.POSIXlt(merged$time)
# Seperate out the days with mday()
days = mday(times)
# Append "days" to it
merged$days = days
# Create the animation for loop
saveHTML( {
  for (i in 1:30) {
    # plot map
    map('county', 'new york', xlim=c(-74.25026, -73.70196), ylim=c(40.50553, 40.91289), mar=c(0,0,0,0))
    # get subset of data where the day == i 
    points(merged.days$lon[merged.days$days == i], merged.days$lat[merged.days$days == i], col=2, pch=18, cex=0.8)
    ani.pause()
  }
})
# Q: What do you see?
# Points are plotted within or around the boundaries of NYC as each day passes.