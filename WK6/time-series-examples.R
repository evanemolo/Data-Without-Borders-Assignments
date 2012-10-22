# import the data
# note: scan() can only be used with a file that has one column of data
kings <- scan("http://robjhyndman.com/tsdldata/misc/kings.dat",skip=3)
# now store in a time series object
kingstimeseries <- ts(kings)
# plot the time series of the age of death of 42 successive 
# kings of England:
plot.ts(kingstimeseries)
# model is additive: random flucuations are roughly constant over time
# decomposing non-seasonal data:
library("TTR")
# you must specify the order, which takes some trial and error to find
# the right amount of smoothing
kingstimeseriesSMA3 <- SMA(kingstimeseries,n=3)
plot.ts(kingstimeseriesSMA3)
# still a lot of random flucuations, try another order
kingstimeseriesSMA8 <- SMA(kingstimeseries,n=8)
plot.ts(kingstimeseriesSMA8)
# ok, this gives a clearer picture of the trend component


# another data set:
births <- scan("http://robjhyndman.com/tsdldata/data/nybirths.dat")
# store in a ts object, specify 1946 as the first data point
birthstimeseries <- ts(births, frequency=12,start=c(1946,1))
# plot it
plot.ts(birthstimeseries)
# again, an additive model
# decomposing seasonal data:
birthstimeseriescomponents <- decompose(birthstimeseries)
# plot it
plot(birthstimeseriescomponents)
