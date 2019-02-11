library(tidyverse)
library(dplyr)
library(data.table)
library(lubridate)

##Assigns variables to data and brings in column names
features <- read.table("/Users/Soapnerd/Desktop/UCI HAR Dataset/features.txt", quote="\"", stringsAsFactors=FALSE) ## Bring in feature names
ActivityLabel <- read.table("/Users/Soapnerd/Desktop/UCI HAR Dataset/activity_labels.txt", quote="\"", stringsAsFactors=FALSE)  ##labels

trainsetX <- read.table("/Users/Soapnerd/Desktop/UCI HAR Dataset/train/X_train.txt", quote="\"", stringsAsFactors=FALSE) ## Read train data set to table
testsetX <- read.table("/Users/Soapnerd/Desktop/UCI HAR Dataset/test/X_test.txt", quote="\"", stringsAsFactors=FALSE) ## Read test data set to table
colnames(trainsetX) <- features[,2] ##Assigns Column Names
colnames(testsetX) <- features[,2]


trainsetY <- read.table("/Users/Soapnerd/Desktop/UCI HAR Dataset/train/Y_train.txt", quote="\"", stringsAsFactors=FALSE)
testsetY <- read.table("/Users/Soapnerd/Desktop/UCI HAR Dataset/test/Y_test.txt", quote="\"", stringsAsFactors=FALSE)
colnames(trainsetY) <-"activityId"
colnames(testsetY) <-"activityId"

SubTrain <- read.table("/Users/Soapnerd/Desktop/UCI HAR Dataset/train/subject_train.txt", quote="\"", stringsAsFactors=FALSE)
SubTest <- read.table("/Users/Soapnerd/Desktop/UCI HAR Dataset/test/subject_test.txt", quote="\"", stringsAsFactors=FALSE)
colnames(SubTrain) <- "subjectId"
colnames(SubTest) <- "subjectId"


##Merge the Data
Xset <- rbind(trainsetX, testsetX)
Yset <- rbind(trainsetY, testsetY)
Sset <- rbind(SubTest, SubTrain)


##STD DEV and Mean
MeanSD <- features[grep("mean|std",features[,2]),]
Xset <- Xset[,MeanSD[,1]]

##Add Activity Names
colnames(Yset) <- "label"
Yset$activity <- factor(Yset$label, labels = as.character(ActivityLabel[,2]))
activity <- Yset$activity

##Assigns variable names
colnames(Xset) <- features[features_selected[,1],2]
colnames(Sset) <- "subject" ##subject=sub_all$subject


##Creates Tidy Data and writes to file
CombineData <- cbind(Xset, activity, Sset)
TempData <- group_by(CombineData,activity, subject)
TidyData <- summarize_all(TempData,funs(mean))
write.table(TidyData, file = "/Users/Soapnerd/Desktop/UCI HAR Dataset/tidy_data.txt", row.names = FALSE, col.names = TRUE)
