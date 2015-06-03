# callspan$phonenumber_oid is ID of number that was called
# Get phone number ids of all people from the person table
# Remove call where the phonenumber_oid was not to a person in the dataset

# Ref: http://stackoverflow.com/questions/15227887/how-can-i-subset-rows-in-a-data-frame-in-r-based-on-a-vector-of-values

person <- read.csv("H:/College 4th Year/OwnStuff/Sem 8/Big Data/CA2/All Subject Data CSVs/person.csv")

phoneNums <- c(person$phonenumber_oid)
remove <- c(0) # Remove any phone number IDs of 0
phoneNums <- setdiff(phoneNums, remove)

# Read initial callspan data
callspan <- read.csv("H:/College 4th Year/OwnStuff/Sem 8/Big Data/CA2/All Subject Data CSVs/callspan.csv")

# Extract data containing phone number ID's representing people in the study 
callspan <- callspan[callspan$phonenumber_oid %in% phoneNums,]

# Cleanse callspan data by removing non-required columns
callspan$oid <- NULL
callspan$endtime <- NULL
callspan$starttime <- NULL
callspan$callid <- NULL
callspan$contact <- NULL
callspan$remote <- NULL
callspan$status <- NULL
callspan$number <- NULL
callspan$duration <- NULL

# Save the processed callspan data to disk
callSpanOutFile <- "H:/College 4th Year/OwnStuff/Sem 8/Big Data/CA2/PreProcessedData/callspan.csv"
write.csv(callspan, callSpanOutFile, row.names=FALSE, na="")
