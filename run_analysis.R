## First we will check for, If the directory where the dataset we want to download exists or not
# If the directory does not exist, we will create that directory as follows

if(!file.exists("E:/personal/Johns hopkins university/Data science specialization/Getting and Cleaning the data")){
  dir.create("E:/personal/Johns hopkins university/Data science specialization/Getting and Cleaning the data")
}

## Downloading the dataset from URL
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "E:/personal/Johns hopkins university/Data science specialization/Getting and Cleaning the data/dataset.zip")

## Unzipping the dataset
unzip("E:/personal/Johns hopkins university/Data science specialization/Getting and Cleaning the data/dataset.zip",
      exdir = "E:/personal/Johns hopkins university/Data science specialization/Getting and Cleaning the data")

## get your current working and change if you want change working environment
getwd()
setwd("E:/personal/Johns hopkins university/Data science specialization/Getting and Cleaning the data")

## here we will read and load the training observations for x,y and subject
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")


## Here we will read and load the testing observations for x,y and subject
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")


## Read feature variable
features <- read.table("./UCI HAR Dataset/features.txt")

## Read activity labels 
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

## renaming columns of x,y and subject of training data according to activity labels and type
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityId"
colnames(subject_train) <- "subjectId"


## renaming columns of x,y and subject of testing  data according to activity labels and type
colnames(x_test) <- features[,2]
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"


## now we will combine the datasets of training and testing 
train <- cbind(x_train, y_train, subject_train)
test <- cbind(x_test, y_test, subject_test)
data_combined <- rbind(train,test)

colnames(activity_labels) <- c("activityId", "activityTypes")

## Reading column names of combined data 
columns <- colnames(data_combined)

## getting data for mean and standard deviation only from combined data
mean_and_sd <- (grepl("activityId" , columns) | 
                grepl("subjectId" , columns) | 
                grepl("mean.." , columns) | 
                grepl("std.." , columns) 
                )


## subsetting the mean and std. deviation data
MeanSdData <- data_combined[ ,mean_and_sd == TRUE]

## Descriptive variable names for data
Activityset <- merge(MeanSdData,activity_labels, by = "activityId", all.x = TRUE)


## making a second Tidy data set with the average of each variable for each activity and each subject.
TidyData <- aggregate(. ~subjectId + activityId, Activityset, mean)
TidyData <- TidyData[order(TidyData$subjectId, TidyData$activityId),]

## converting the second tidy data set in text file
write.table(TidyData,"TidyData.txt", row.names = FALSE)








