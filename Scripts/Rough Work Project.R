# One data set
testX<-read.table("UCI HAR Dataset/test/X_test.txt")
testY<-read.table("UCI HAR Dataset/test/y_test.txt")
testsub<-read.table("UCI HAR Dataset/test/subject_test.txt")

trainX<-read.table("UCI HAR Dataset/train/X_train.txt")
trainY<-read.table("UCI HAR Dataset/train/y_train.txt")
trainsub<-read.table("UCI HAR Dataset/train/subject_train.txt")

X<-rbind(testX,trainX)
Y<-rbind(testY,trainY)
SUB<-rbind(testsub,trainsub)

data<-data.frame(SUB,Y,X)

remove(SUB,testsub,testX,testY,trainsub,trainX,trainY,X,Y)

# Subset mean sand standard deviation

features<-read.table("UCI HAR Dataset/features.txt", header = FALSE)
featnames<-as.vector(features[,2])
colnames(data)<-c("Subject","Activity",featnames)

library(dplyr)

data<-data %>% select(contains(c("Subject","Activity","mean","std")), -contains(c("freq", "angle")))


# Replace activity numbers with labels

activity<-read.table("UCI HAR Dataset/activity_labels.txt")

data$Activity[data$Activity==1]<-"Walking"
data$Activity[data$Activity==2]<-"Walking Upstairs"
data$Activity[data$Activity==3]<-"Walking Downstairs"
data$Activity[data$Activity==4]<-"Sitting"
data$Activity[data$Activity==5]<-"Standing"
data$Activity[data$Activity==6]<-"Laying"

# Summarize data into new tidy data set

data_sum<-split(data, data$Subject)

data.sum<-data %>%
    group_by(Subject, Activity) %>%
    summarise_each(funs(mean))

write.csv(data.sum,file = "Data Summary.csv", row.names = FALSE)

