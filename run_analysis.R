
setwd("./UCI HAR Dataset")

## Task No.1 | Merge the training and the test sets to create one data set.
# Loadig labels and variable names
activities <- read.table("./activity_labels.txt")[,2]
variables <- read.table("./features.txt")[,2]

# Loading test and training data sets (incl. labels): x_test, y_test,X_train & y_train s
X_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
X_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")

# Merging test and train data (+ labels) into one test set 
subject_test <- read.table("./test/subject_test.txt")
subject_train <- read.table("./train/subject_train.txt")

testSet <- cbind(as.data.frame(subject_test), y_test, X_test)
trainSet <- cbind(as.data.frame(subject_train), y_train, X_train)
fullSet <- rbind(testSet, trainSet)


## Taks No.2 | Extract only the measurements on the mean and standard deviation for each measurement.
extract_mean_sd <- grepl("mean|std", variables)
fullSet_selection <- fullSet[,extract_mean_sd]


## Task No.3 | Use descriptive activity names to name the activities in the data set
fullSet_selection[,82] <- activities[fullSet_selection[,2]]
names(fullSet_selection)[c(2,82)] <- c("ActivityID", "ActivityName")


## Task No.4 | Appropriately label the data set with descriptive variable names.
names(fullSet_selection)[1] <- "SubjectID"
names(fullSet_selection)[c(3:81)] <- as.character(variables[extract_mean_sd])


## Task No.5 | From the data set in step 4, create a second, 
## independent tidy data set with the average of each variable for each activity and each subject.
install.packages("reshape2")
library(reshape2)
id_names   = c("SubjectID", "ActivityID", "ActivityName")
measure_names = setdiff(colnames(fullSet_selection), id_names)
melt <- melt(fullSet_selection, id = id_names, measure.vars = measure_names)
tidySet <- dcast(melt, SubjectID + ActivityID ~ variable, mean)
write.csv(tidySet, file = "./tidySet.csv", sep=";")












