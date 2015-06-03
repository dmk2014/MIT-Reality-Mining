library("neuralnet")

# Note: Months & Days of Week have Zero Index, e.g. Jan = 0

# Read pre-processed data
interactions <- read.csv("H:/College 4th Year/OwnStuff/Sem 8/Big Data/CA2/PreProcessedData/MergedDeviceData/onePerson.csv")

# View data count for each month
table(interactions$month_of_year)

# Extract Training Data - one month will be used
trainset <- interactions[interactions$month_of_year == 2, ]
trainset$month_of_year <- NULL

# Extract Testing Data - one month will be used
testset <- interactions[interactions$month_of_year == 8, ]
testset$month_of_year <- NULL

# Add people_meet column to indicate training output
trainset$people_meet <- 1

# Train neural network
# The captured person, day of week and time of day are predictor variables
# They are used to train the network of when two people are likely to meet
neuralNet <- neuralnet(people_meet ~ captured_person + day_of_week + time_of_day,
                       trainset,
                       hidden = 2,
                       threshold = 0.01)

# Test the network
predictMeetResults <- compute(neuralNet, testset)

# Store results in a neatly formatted data frame for comparision
results <- as.data.frame(predictMeetResults$net.result)
names(results)[names(results)=="V1"] <- "Actual"
results$Expected <- 1
head(results)

# Visualise the data
plot(neuralNet)
