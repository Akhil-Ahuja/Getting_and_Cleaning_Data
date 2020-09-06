##--------------------------------------------------------------
## Please view README.md and CodeBook.md for variable names/descriptions and other useful information
## Data source: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## -------------------------------------------------------------
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## load necessary package
library(dplyr)

## reads the data
features <- read.table("./UCI HAR Dataset/features.txt", fill = TRUE)
features <- gsub("[()]", "", features[,2]) %>% gsub(pattern = "[-,]", replacement="_")

## reads data from train folder
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt", fill=TRUE, strip.white = TRUE, skipNul = TRUE)
names(train_subject) <- c("subject")

train_X <- read.table("./UCI HAR DAtaset/train/X_train.txt", fill=TRUE, strip.white = TRUE, skipNul = TRUE)
names(train_X) <- features

train_Y <- read.table("./UCI HAR Dataset/train/Y_train.txt", fill=TRUE, strip.white = TRUE, skipNul = TRUE)
names(train_Y) <- c("activity")

train_df <- cbind(train_subject,train_Y,train_X)

## reads the data from test folder
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt", fill=TRUE, strip.white = TRUE, skipNul = TRUE)
names(test_subject) <- c("subject")

test_X <- read.table("./UCI HAR DAtaset/test/X_test.txt", fill=TRUE, strip.white = TRUE, skipNul = TRUE)
names(test_X) <- features

test_Y <- read.table("./UCI HAR Dataset/test/Y_test.txt", fill=TRUE, strip.white = TRUE, skipNul = TRUE)
names(test_Y) <- c("activity")

test_df <- cbind(test_subject,test_Y,test_X)

## 1. Merges the training and the test sets to create one data set.
merged_df <- rbind(train_df, test_df)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
all_features <- names(merged_df)
needed_cols <- c(1, 2, grep("(mean|std)",all_features, ignore.case = TRUE))
needed_df <- merged_df[,needed_cols]

## 3. Uses descriptive activity names to name the activities in the data set.
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", fill=TRUE, header=FALSE)
needed_df <- mutate(needed_df, activity = activity_labels[activity,2])

## 4. Appropriately labels the data set with descriptive variable names.
## ANSWER: already done in step 1 (within process_data function)

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
output <- needed_df %>% group_by(subject, activity) %>% summarise(across(cols=c(-subject, -activity), .fns=mean))
write.table(output, 'output.txt', row.names = FALSE)

