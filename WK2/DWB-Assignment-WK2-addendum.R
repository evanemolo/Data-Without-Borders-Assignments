# Question 2-3, repetition method for coloring max and min in plot:

# create a vector with a repetition of "1" (black) 24 times, to represent the 24 hours
colors = rep(1,24)
# after finding the min and max, min is at index 7, max at index 21, 
# target them in the vector, and give them a number for a color:
colors[7] = 3 # 7th index, col=3 (green)
colors[21] = 2 # color 21st index col=2 (red)
# plot, col=colors var (the vector with matching index number)
plot(stops.by.hour, type="p", pch=2, ylab="stops", main="arrest per hour", col=colors)
# so: max is red, min is green, the rest are black