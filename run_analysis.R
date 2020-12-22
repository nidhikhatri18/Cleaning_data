if (!require("dplyr")) {
  message("Installing dplyr")
  install.packages("dplyr")
}

# 2. Create project data directory
if (!file.exists("./Data")) 
{
  message("Creating data directory")
  dir.create("./Data")
}

# 3. Download Human Activity Recognition dataset
if (!file.exists("./Data/UCI_HAR_Dataset.zip")) 
{
  message("Downloading dataset")
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = "./Data/UCI_HAR_Dataset.zip", mode = "wb")
}
#4.Extract dataset
if (!file.exists("./Data/UCI HAR Dataset")) 
{
  message("Extracting dataset")
  unzip("./Data/UCI_HAR_Dataset.zip", 
        overwrite = FALSE, 
        exdir = "./Data")
}
#5.Read all the files
features <- tbl_df(
  read.table("./Data/UCI HAR Dataset/features.txt", 
             col.names = c("Id", "Feature")))

X_train<-tbl_df(read.table("./Data/UCI HAR Dataset/train/X_train.txt",col.names = features$Feature))
subject_train<-tbl_df(read.table("./Data/UCI HAR Dataset/train/subject_train.txt",col.names = c("subject")))
y_train<-tbl_df(read.table("./Data/UCI HAR Dataset/train/y_train.txt",col.names = c("activity")))


X_test<-tbl_df(read.table("./Data/UCI HAR Dataset/test/X_test.txt",col.names = features$Feature))
subject_test<-tbl_df(read.table("./Data/UCI HAR Dataset/test/subject_test.txt",col.names = c("subject")))
y_test<-tbl_df(read.table("./Data/UCI HAR Dataset/test/y_test.txt",col.names = c("activity")))

activities<-tbl_df(read.table("./Data/UCI HAR Dataset/activity_labels.txt",col.names = c("id","activity")))

#6.Merge train,test data
x<-rbind(X_train,X_test)  
y<-rbind(y_train,y_test)
subject<-rbind(subject_train,subject_test)
merged_data<-cbind(subject,y,x)

#7. Select only mean and standard deviation column from dataset
TidyData<-merged_data %>% select(subject,activity,contains("mean"),contains("std"))

#8.Give descriptive name to the activities
TidyData$activity<-activities[TidyData$activity,2]                  

#9.give proper name to the column of dataset
names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

#10.New tidy data set with the average of each variable for each activity and each subject.
FinalData <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)