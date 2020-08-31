##Getting and Cleaning Data - Course Project

##Loading the necessary packages
library(dplyr)

##Downloading the Data from Website
fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL,destfile="Project_Data.zip",method="curl")

##Unzipping the file

unzip("Project_Data.zip")

##Extracting files
features<-read.table("UCI HAR Dataset/features.txt",col.names=c("Sl.No.","variables"))
head(features)

activities<-read.table("UCI HAR Dataset/activity_labels.txt",col.names=c("Label", "activity"))
head(activities)

##Extracting Test Data sets
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt",col.names="subject")
head(subject_test)

x_test<-read.table("UCI HAR Dataset/test/X_test.txt",col.names=features$variables)
str(x_test)

y_test<-read.table("UCI HAR Dataset/test/y_test.txt",col.names="Label")
str(y_test)

##Extracting train Data sets
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt",col.names="subject")
head(subject_train)

x_train<-read.table("UCI HAR Dataset/train/X_train.txt",col.names=features$variables)
str(x_train)

y_train<-read.table("UCI HAR Dataset/train/y_train.txt",col.names ="Label")
str(y_train)

##Merge of test and train data
X<-merge(x_train,x_test,all=TRUE)
str(X)

Y<-rbind(y_train,y_test)
str(Y)

Subject<-rbind(subject_train,subject_test)
str(Subject)

Merged_Data<-cbind(Subject,Y,X)
str(Merged_Data)

##Variables containing mean and standard deviation
Data<-Merged_Data %>% select(subject,Label,contains("mean"),contains("std"))
str(Data)

##Changing the Label of activities to descriptive names
Data$Label<-activities[Data$Label,2]
str(Data)


##Labeling the variable names in descriptive form 
View(Data)
names(Data)[2]="Activity"

names(Data)<-gsub("^t","Time",names(Data))
names(Data)<-gsub("^f","Frequency",names(Data))
names(Data)<-gsub("Acc","Accelerometer",names(Data))
names(Data)<-gsub("Gyro","Gyroscope",names(Data))
names(Data)<-gsub("BodyBody","Body",names(Data))
names(Data)<-gsub("Mag","Magnitude",names(Data))
names(Data)<-gsub("-mean()","Mean",names(Data),ignore.case=TRUE)
names(Data)<-gsub("-std()","STD",names(Data),ignore.case=TRUE)
names(Data)<-gsub("-freq()","Frequency",names(Data),ignore.case=TRUE)

str(Data)

###Creating Tidy Data set 
TidyData <-Data%>%group_by(subject,Activity) %>%summarise_all(funs(mean))
write.table(TidyData,"TidyData.txt",row.name=FALSE)
