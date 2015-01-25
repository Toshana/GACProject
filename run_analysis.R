# Read data into R
## NOTE: R should have the packages 'plyr' and 'dplyr' installed prior to running this script

xtest <- read.table("~/Coursera/Getting and Cleaning Data/Project/Dataset/test/X_test.txt", quote="\"", stringsAsFactors=FALSE)
xtrain <- read.table("~/Coursera/Getting and Cleaning Data/Project/Dataset/train/X_train.txt", quote="\"", stringsAsFactors=FALSE)
ytest <- read.table("~/Coursera/Getting and Cleaning Data/Project/Dataset/test/Y_test.txt")
ytrain <- read.table("~/Coursera/Getting and Cleaning Data/Project/Dataset/train/Y_train.txt")
subtest <- read.table("~/Coursera/Getting and Cleaning Data/Project/Dataset/test/subject_test.txt", quote="\"", stringsAsFactors=FALSE) 
subtrain <- read.table("~/Coursera/Getting and Cleaning Data/Project/Dataset/train/subject_train.txt", quote="\"", stringsAsFactors=FALSE)
features <- read.table("~/Coursera/Getting and Cleaning Data/Project/Dataset/features.txt")
activity <- read.table("~/Coursera/Getting and Cleaning Data/Project/Dataset/activity_labels.txt")


## Add features names

listofnames<- as.character(features[,2])
names <- make.names(listofnames, unique=TRUE)
colnames(xtest) <- names
colnames(xtrain) <- names

##rename columns in subjects
library(plyr)
library(dplyr)
subtest<- rename(subtest, c("V1" = "subject"))
subtrain <- rename(subtrain, c("V1" = "subject"))

## column bind the subjects to the corresponding observations
y <- rbind(ytrain, ytest)
subject <- rbind(subtest, subtrain)
test <- cbind(subtest, ytest, xtest)
train <- cbind(subtrain, ytrain, xtrain)

## merge the two resulting datasets into one
mergeData <- rbind(train, test)

## select measurements of mean and standard deviation and merge into a new dataframe

meanData <- select(mergeData, contains("mean"))
stdData <- select(mergeData, contains("std"))
newData <- cbind(subject, y, meanData, stdData)

# Name activity in the dataset using the activity_labels.txt file and the function gsub

newData$V1 <- gsub("1", "walking", newData$V1)
newData$V1 <- gsub("2", "walkingup", newData$V1)
newData$V1 <- gsub("3", "walkingdown", newData$V1)
newData$V1 <- gsub("4", "sitting", newData$V1)
newData$V1 <- gsub("5", "standing", newData$V1)
newData$V1 <- gsub("6", "laying", newData$V1)

# Appropriately label dataset with descriptive label names
## Expand the column names using the features_info.txt file and the function gsub

cnam <- colnames(newData)
cnam <- gsub("t", "time", cnam)
cnam <- gsub("Acc", "accelerometer", cnam) 
cnam <- gsub("Gyro", "gyroscope", cnam)
cnam <- gsub("Mag", "magnitude", cnam)
cnam <- gsub("f", "frequency", cnam)
cnam <- gsub("[.]", "", cnam)
cnam <- gsub("X", "xaxis", cnam)
cnam <- gsub("Y", "yaxis", cnam)
cnam <- gsub("Z", "zaxis", cnam)
cnam <- gsub("BodyBody", "body", cnam)
cnam <- gsub("V1", "activity", cnam)
cnam <- gsub("subjectime", "subject", cnam)
cnam <- tolower(cnam)

colnames(newData) <- cnam

# arrange by subject for readability

newData <- arrange(newData, subject)

#create tidy data set with the average of each variable for each activity and each subject. ddply applies numcolwise(mean) to the columns 'subject' and 'activity'

tidydata <- ddply(newData, .(subject, activity), numcolwise(mean))

View(tidydata)

write.table(tidydata, "tidydata.txt", row.name=FALSE)







