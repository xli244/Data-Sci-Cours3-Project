# Load data
features<-read.table("features.txt",col.names = c("serial_n","features"))
activity<-read.table("activity_labels.txt",col.names=c("code","activity"))
subjecttest<-read.table("subject_test.txt",col.names="subject")
xtest<-read.table("X_test.txt",col.names=features$features)
ytest<-read.table("y_test.txt",col.names="code")
subjecttrain<-read.table("subject_train.txt",col.names="subject")
xtrain<-read.table("X_train.txt",col.names=features$features)
ytrain<-read.table("y_train.txt",col.names="code")
# Merge 
X<-rbind(xtrain,xtest)
Y<-rbind(ytrain,ytest)
subject<-rbind(subjecttrain,subjecttest)
mergedata<-cbind(subject,Y,X)
# extracts mean and std for each measurement
mergedata<-mergedata %>% select(subject,code,contains("mean"),contains("std"))%>% select(-contains("meanFreq"),-contains("angle"))
# Put in names for each activity type
mergedata$code<-activity[mergedata$code,2]
# Change to proper names 
mergedata<-rename(mergedata,"Activity_type"="code","Subject"="subject")
names(mergedata)<-gsub("Acc", "Accelerometer", names(mergedata))
names(mergedata)<-gsub("^t", "Time", names(mergedata))
names(mergedata)<-gsub("^f", "Frequency", names(mergedata))
names(mergedata)<-gsub("Gyro", "Gyroscope", names(mergedata))
names(mergedata)<-gsub(".std..|.std...", "STD", names(mergedata))
names(mergedata)<-gsub(".mean...|.mean..", "Mean", names(mergedata))
names(mergedata)
# Create an independent tidy data set with the average of each variable for each activity and each subject
datasum<-mergedata%>%group_by(Activity_type,Subject)%>%summarise_all(funs(mean))
