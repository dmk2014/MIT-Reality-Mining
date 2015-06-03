library(rmr2)
library(rhdfs)

callspancount <- function(input){
  
  csc.map <- function(k, v) {
    descriptionColumnIndex <- 3
    directionColumnIndex <- 4
    description <- paste(v[[descriptionColumnIndex]])
    direction <- paste(v[[directionColumnIndex]])
    
    key <- ifelse(direction == "Outgoing" & description == "Voice Call", "Outgoing Voice Call",
                  ifelse(direction == "Outgoing" & description == "Short Message", "Outgoing SMS",
                         ifelse(direction == "Incoming" & description == "Voice Call", "Incoming Voice Call",
                                ifelse(direction == "Incoming" & description == "Short Message", "Incoming SMS", "Missed Call"))))
    
    keyval(key, 1)
  }
  
  csc.reduce <- function(description, counts){
    keyval(description, length(counts))
  }
  
  mapreduce(
    input = input,
    map = csc.map,
    reduce = csc.reduce)
}

hdfs.init()

# Read input - processed callspan data
inputData <- read.csv("CA2 Scripts/callspan.csv")
inputMapRed <- to.dfs(inputData)

resultsMapRed <- callspancount(input = inputMapRed)
results = from.dfs(resultsMapRed)

keys <- c(results$key)
values <- c(results$val)


# Graphs: http://www.harding.edu/fmccown/r/
# Color Palettes: http://www.r-bloggers.com/color-palettes-in-r/

### Visualise the Analysis Results ###

# Bar Plot
barplot(values, 
        names.arg = keys,
        axes = TRUE,
        xlab = "Type",
        ylab = "Freq.",
        ylim = c(0,25000),
        main="Overall Contact",
        col = terrain.colors(5))

# Pie Chart
pieLabels <- round(values/sum(values) * 100, 1)
pieLabels <- paste(pieLabels, "%", sep="")

pie(values,
    labels = pieLabels,
    main = "Overall Contact",
    col = terrain.colors(6))

legend("topright",keys, cex = 0.8, fill=terrain.colors(6))


### Visualise Calls ###

# Extract Call Specific Results
callLabels <- c(keys[2], keys[3], keys[5])
callValues <- c(values[2], values[3], values[5])

# Bar Plot
barplot(callValues,
        names.arg = callLabels,
        axes = TRUE,
        xlab = "Type",
        ylab = "Freq.",
        ylim = c(0,25000),
        main="Call Data",
        col = terrain.colors(3))

# Pie Chart
pieLabels <- round(callValues/sum(callValues) * 100, 1)
pieLabels <- paste(pieLabels, "%", sep="")

pie(callValues,
    labels = pieLabels,
    main = "Voice Calls",
    col = terrain.colors(4))

legend("topright", callLabels, cex = 0.8, fill=terrain.colors(4))


### Visualise SMS ###

# Extract SMS Specific Results
smsLabels <- c(keys[1], keys[4])
smsValues <- c(values[1], values[4])

# Bar Plot
barplot(smsValues,
        names.arg = smsLabels,
        axes = TRUE,
        xlab = "Type",
        ylab = "Freq.",
        ylim = c(0,2500),
        main="SMS Data",
        col = terrain.colors(2))

# Pie Chart
pieLabels <- round(smsValues/sum(smsValues) * 100, 1)
pieLabels <- paste(pieLabels, "%", sep="")

pie(smsValues,
    labels = pieLabels,
    main = "SMS",
    col = terrain.colors(4))

legend("topright", smsLabels, cex = 0.8, fill=terrain.colors(2))
