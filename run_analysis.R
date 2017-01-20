

# uploading all the data

y_test<-read.table("y_test.txt" )
X_test<-read.table("X_test.txt" )
y_train<-read.table("y_train.txt" )
X_train<-read.table("X_train.txt" )
activity_labels<- read.table("activity_labels.txt")
featurs<- read.table("features.txt")
subject_test<- read.table("subject_test.txt")
subject_train<- read.table("subject_train.txt")

#  4  Appropriately labels the data set with descriptive variable names.
colnames(X_test)<- featurs$V2
colnames(X_train)<- featurs$V2
#adding subject and activity columns  to test and train data

#test data 
X_test["subject"]<- subject_test$V1
X_test["activity"]<- y_test$V1

#train data
X_train["subject"]<- subject_train$V1
X_train["activity"]<- y_train$V1

#order data colmuns  starting with subject and activity
X_test = X_test[, c(562:563, 1:561)]
X_train = X_train[,c(562:563, 1:561)]

#  1  merge data test data with train data
Mdata<- rbind(X_test,X_train)

#  2  Extracts only the measurements on the mean and standard deviation for each measurement.
install.packages("dplyr")
library(dplyr)
Extractdata<-Mdata%>%
  select(contains("mean()"),contains("STD"))

# 3  Uses descriptive activity names to name the activities in the data set
Mdata$activity<-factor(Mdata$activity,levels = activity_labels$V1, labels = activity_labels$V2)

# 5  From the data set in step 4, creates a second, independent tidy data
#set with the average of each variable for each activity and each subject.
tidy_data<- Mdata %>%
  group_by(activity,subject)%>%
  summarise_each (funs (mean) )%>%
  arrange(subject, activity)
  

write.table(tidy_data, "tidy_data.txt", row.name=FALSE)
