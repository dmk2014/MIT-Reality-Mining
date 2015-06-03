# Extract one person from deviceinteractions

deviceinteractions <- read.csv("H:/College 4th Year/OwnStuff/Sem 8/Big Data/CA2/PreProcessedData/MergedDeviceData/deviceinteractions.csv")

# Extract data for person 29
onePerson <- deviceinteractions[deviceinteractions$source_person == 29,]
onePerson$source_person <- NULL

# Change starttime column from String to time format
onePerson$starttime <- as.POSIXlt(onePerson$starttime)

# Add month, day and hour columns
onePerson$month_of_year <- onePerson$starttime$mon
onePerson$day_of_week <- onePerson$starttime$wday
onePerson$hour_of_day <- onePerson$starttime$hour

# Round hours up if minutes greater than 30
# First set hour of day column using mapply with minutes and hours as input
# Then ensure any hours with value "24" are set to 0 (midnight - 24 hour clock)

# Round hour up by one if minutes are greater than 30
onePerson$hour_of_day_R <- mapply(function(x, y) (if (x > 30) {y + 1} else {y}),
                                  onePerson$starttime$min,
                                  onePerson$starttime$hour)

# Some hours will be 24 following rounding, these must be changes to 0 (24 hour clock)
onePerson$hour_of_day_R <- lapply(onePerson$hour_of_day_R,
                                  function(x) (if (x==24) {0} else {x}))

# Cleanup data
onePerson$starttime <- NULL
onePerson$hour_of_day <- NULL
names(onePerson)[names(onePerson)=="hour_of_day_R"] <- "hour_of_day"

# Flatten list in hour_of_day column and convert to numeric data type (required later in neural network)
onePerson$hour_of_day <- lapply(onePerson$hour_of_day, as.character)
onePerson$hour_of_day <-as.numeric(as.character(onePerson$hour_of_day))

# Use a grouped time of day, oppposed to hour of day
# Morning: 6 - 12, 1
# Afternoon: 13-17, 2
# Evening: 18-21, 3
# Night: 22-5, 4

onePerson$hour_of_day <- lapply(onePerson$hour_of_day,
                                function(x) (ifelse(x >= 6 & x <= 12, 1,
                                                    ifelse(x >= 13 & x <= 17, 2,
                                                           ifelse(x >= 18 & x <= 21, 3, 4)))))

# Flatten and ensure numeric
onePerson$hour_of_day <- lapply(onePerson$hour_of_day, as.character)
onePerson$hour_of_day <-as.numeric(as.character(onePerson$hour_of_day))

# Use appropriate column name
names(onePerson)[names(onePerson)=="hour_of_day"] <- "time_of_day"

# Save data
filePath <- "H:/College 4th Year/OwnStuff/Sem 8/Big Data/CA2/PreProcessedData/MergedDeviceData/onePerson.csv"
write.csv(onePerson, filePath, row.names=FALSE, na="")
