# Data Without Borders Assignment 8

# Predicting the Future

library(psych)
# snf = read.csv("http://jakeporway.com/teaching/data/snf_4.csv", as.is=T, header=T)
snf = read.csv("/Users/evanemolo/Dropbox/_ITP/_Fall_2012/DWB/HW/WK8/snf_4.csv", as.is=T, header=T)
# Make a height column
height = (snf$feet * 12) + snf$inches
snf$height = height
# Plot and describe the variables “height”, “weight”, “period_obs”, and “period_stop”.
# What do you see?
# Height
hist(snf$height[snf$height > 50 & snf$height < 90], breaks=100)
mean(snf$height) # 68.57884
median(snf$height) # 69
# Weight
hist(snf$weight[snf$weight < 400], breaks=100)
mean(snf$weight) # 169.2797
median(snf$weight) # 165
# Period Obs
hist(snf$period_obs[snf$period_obs < 20], breaks=50)
mean(snf$period_obs) # 2.369037
median(snf$period_obs) # 1
# Period Stops
hist(snf$period_stop[snf$period_stop < 100], breaks=50)
mean(snf$period_stop) # 5.590146
median(snf$period_stop) # 5
# A: Period stops and period obs are skewed right, while height and weight appear to have
# a normal distribution

# Slippery Slopes

# Create a subset of the data where period_obs and period_stop are less than 40.
minutes.clean = snf[snf$period_obs < 40 & snf$period_stop < 40, ]
# Create a jittered() scatterplot of the data. What do you see?
plot(jitter(minutes.clean$period_obs), jitter(minutes.clean$period_stop))
# A: values tend to be rounded off to the nearest five minutes. Minutes oberserved and
# minutes stopped are concentrated in less five minutes total
# Build a linear model predicting the period_stop variable from period_obs. What is
# the slope of your model? Based on your intuition, would you say this is a good model?
plot(minutes.clean$period_obs, minutes.clean$period_stop)
stops.period.model = lm(minutes.clean$period_stop ~ minutes.clean$period_obs)
abline(stops.period.model)
summary(stops.period.model)
# A: No, this does not appear to be a good model. The slope is 0.092358
# Using your model, predict how long you expect someone to be stopped if they’re
# observed for 5 minutes.
snf.minutes.slope = stops.period.model$coefficients[[2]]
snf.minutes.intercept = stops.period.model$coefficients[[1]]
obs.time = 5
predicted.stop.time = snf.minutes.slope * obs.time + snf.minutes.intercept
# A: 5.6 minutes
# Using your model, predict how long you expect someone to be stopped if they’re
# observed for 60 minutes.
obs.time = 60
predicted.stop.time = snf.minutes.slope * obs.time + snf.minutes.intercept
# A: 10.7 minutes
# Create a scatterplot of the height and weight variables. Jitter() or use transparency() 
# so we can see where the bulk of the data lies.
plot(jitter(snf$height), jitter(snf$weight))
# Trim your data to exclude extreme height or weight values
plot(jitter(snf$height), jitter(snf$weight), xlim=c(45,85), ylim=c(80,400))
# Run a linear model predicting weight from height. What is the slope of that model?
snf.wh.clean = snf[snf$height < 85 & snf$height > 45 & snf$weight < 400 & snf$weight > 80, ]
plot(snf.wh.clean$height, snf.wh.clean$weight)
snf.wh.model = lm(snf.wh.clean$weight ~ snf.wh.clean$height)
abline(snf.wh.model)
snf.wh.model$coefficients[[2]] 
# A: The slope is 4.31813
# How much do you expect someone who’s 6’ 0” to weight?
snf.wh.slope = snf.wh.model$coefficients[[2]]
snf.wh.intercept = snf.wh.model$coefficients[[1]]
person.height = 72
predicted.weight = snf.wh.slope * person.height + snf.wh.intercept
# A: 183.6973 lbs