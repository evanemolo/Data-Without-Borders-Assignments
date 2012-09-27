snf <- read.csv("http://www.jakeporway.com/teaching/data/snf_2.csv", as.is=TRUE)

# Part 1


# Write code to return the percentage of people who were frisked for each race.

race.code = c(-1,1,2,3,4,5,6)

for(i in race.code) {
  race = snf$race 
  stops = length(which(race == i))
  frisks = length(which(race == i & snf$frisked == 1))
  print(paste("race.code", i, "percentage:", frisks/stops))
}

# Plot the number of times each crime occurs in descending order
crimes = rev(sort(table(snf$crime.suspected)))
plot(crimes, type='l', xlab="crime", ylab="")
# The plots skews heavily towards the top five crimes

# If we were to just look at stops where the crime.suspected was 
# one of the top 30 crimes, what percentage of the stops would that cover?
top.crimes = crimes[1:30]
sum(top.crimes)/sum(crimes)

# Write code to create a variable called “crime.abbv” that consists of just 
# the first three letters of crime.suspected and show the code to add it to 
# our main data frame. Now what percentage of the stops do the top 30 crime.abbvs 
# account for?
crime.abbr = substr(snf$crime.suspected, 1, 3)
snf$crime.abbr = crime.abbr
crime.suspected.clean = rev(sort(table(snf$crime.abbr)))
sum(crime.suspected.clean[1:30]) / sum(crime.suspected.clean)

# Write code to show the top 3 crimes each race is suspected of.

race.code = c(-1,1,2,3,4,5,6)

for(i in race.code) {
  # create subset
  which.race = which(snf$race == i)
  subset.race = snf[which.race, ]
  # target crime.abbr col in subset
  subset.race.crime.abbr = subset.race$crime.abbr
  # keep it organized...
  print(paste("racecode", i, "results:"))
  # reverse sort table, target top 3 crimes, then print
  print(rev(sort(table(subset.race.crime.abbr)))[1:3])
}


# Part 2


# Let’s create an “hour” variable that tells us what 
# hour of the day each stop happened during and add it to our dataset.
hour = as.numeric(substr(snf$time, 12, 13))

# Create a line plot (i.e. a plot with type=”l”) of the stops by hour. 
# Which hour of the day has the most stops? Which hour has the fewest?
stops.by.hour = table(hour)
plot(as.vector(stops.by.hour), type="l", ylab="stops", main="arrest per hour")
which(stops.by.hour == min(stop.by.hour))
  # column name: 6
  # index 7
which(stops.by.hour == max(stop.by.hour))
  # column name: 20
  # index: 21

# Create the same plot but with points instead of lines. Use a different
# plotting symbol than the default and color the max point and min points 
# different colors.
plot(stops.by.hour, type="p", pch=2, ylab="stops", main="arrest per hour", col=((stops.by.hour == max(stops.by.hour) | stops.by.hour == min(stops.by.hour))+1)


# Part 3


# First create a subset of the data only consisting of “good” weights and heights.
# Note to self: use combined height and weight subset for correct answer 
clean.subset = snf[snf$height > 40 & snf$weight > 90 & snf$weight < 400, ]
# Add a BMI variable to our dataset, where BMI is computed as (weight)*703/(height*height).
bmi = (clean.subset$weight)*703/(clean.subset$height*clean.subset$height)
# What percentage of people with BMI’s greater than or equal to 30 who were stopped were 
# ultimately arrested?
obese.subset = clean.subset[bmi >= 30, ]
obese.arrested.subset = which(obese.subset$arrested == 1)
length(which(obese.subset$arrested == 1)) / nrow(obese.subset)

# What percentage of people with BMI’s less than 30 who were stopped were ultimately arrested?
normal.weight.subset = snf[bmi <= 30, ]
normal.weight.arrested.subset = which(normal.weight.subset$arrested == 1)
