# Merge devices and devicespan by the device identifier
# Data represents only interactions between those involed in the study

# Read required raw data
# Device name column in device.csv had errors - it was manually removed using Microsoft Excel
device <- read.csv("H:/College 4th Year/OwnStuff/Sem 8/Big Data/CA2/PreProcessedData/device.csv")
devicespan <- read.csv("H:/College 4th Year/OwnStuff/Sem 8/Big Data/CA2/All Subject Data CSVs/devicespan.csv")

# Merge the data
# device.oid corresponded with device_span.device_oid
# These columns to merge the data - the result contained person_oid which was of interest
# person_oid columns in result represented both the source person and the person who was captured
deviceInteractions <- merge(devicespan, device, by.x="device_oid", by.y="oid")

# Final format: source person, captured person, start-time
# Drop unused columns
deviceInteractions$device_oid <- NULL
deviceInteractions$oid <- NULL
deviceInteractions$macaddr <- NULL
deviceInteractions$endtime <- NULL

# Rename person columns
# person_oid.x is id of person who's device captured the data
# person_oid.y is id of person who's device was captured
names(deviceInteractions)[names(deviceInteractions)=="person_oid.x"] <- "source_person"
names(deviceInteractions)[names(deviceInteractions)=="person_oid.y"] <- "captured_person"

# Save data
deviceInteractionsFile <- "H:/College 4th Year/OwnStuff/Sem 8/Big Data/CA2/PreProcessedData/MergedDeviceData/deviceinteractions.csv"
write.csv(deviceInteractions, deviceInteractionsFile, row.names=FALSE, na="")
