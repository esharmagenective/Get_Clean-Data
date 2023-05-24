# Read in all of the data files
testX<-read.table("UCI HAR Dataset/test/X_test.txt")
testY<-read.table("UCI HAR Dataset/test/y_test.txt")
testsub<-read.table("UCI HAR Dataset/test/subject_test.txt")

trainX<-read.table("UCI HAR Dataset/train/X_train.txt")
trainY<-read.table("UCI HAR Dataset/train/y_train.txt")
trainsub<-read.table("UCI HAR Dataset/train/subject_train.txt")

# Combine the test and train sets into one big set of data
X<-rbind(testX,trainX)
Y<-rbind(testY,trainY)
SUB<-rbind(testsub,trainsub)

# Add all the data into one dataframe
data<-data.frame(SUB,Y,X)

# Remove all other files
remove(SUB,testsub,testX,testY,trainsub,trainX,trainY,X,Y)

# Read in feature names and add them to the dataset as labels
features<-read.table("UCI HAR Dataset/features.txt", header = FALSE)
featnames<-as.vector(features[,2])
colnames(data)<-c("Subject","Activity",featnames)

library(dplyr)

# Subset data for only the mean and std data
data<-data %>% select(contains(c("Subject","Activity","mean","std")), -contains(c("freq", "angle")))


# Read in the labels and print them
activity<-read.table("UCI HAR Dataset/activity_labels.txt")
activity

# Replace the number with the corresponding activity
data$Activity[data$Activity==1]<-"Walking"
data$Activity[data$Activity==2]<-"Walking Upstairs"
data$Activity[data$Activity==3]<-"Walking Downstairs"
data$Activity[data$Activity==4]<-"Sitting"
data$Activity[data$Activity==5]<-"Standing"
data$Activity[data$Activity==6]<-"Laying"

# Group data by subject and activity, then find the mean of the data
data.sum<-data %>%
    group_by(Subject, Activity) %>%
    summarise_each(funs(mean))

# Dump results into a csv file
write.table(data.sum,file = "Data Summary.txt", row.names = FALSE)

