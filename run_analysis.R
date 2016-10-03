run_analysis <- function(){
  
  print("Starting the Analysis")
  
  print("Downloading andunzipping the file")
  setwd("~/Data Science/Data/")
  
  filename <- "Dataset.zip"
  
  
  ## Download and unzip the dataset:
  if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
    download.file(fileURL, filename, method="curl")
  }  
  if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
  }
  
  setwd("~/Data Science/Data/UCI HAR Dataset")
  
  print("Creating data frames from the source files")
  #Creating data frames from source files
  data_Feat_Names <- read.table("features.txt", header = FALSE) 
  data_Act_Names <- read.table("activity_labels.txt", header = FALSE)
  #Naming the activity data frames columns accordingly
  names(data_Act_Names) <- c("activity","activity_name")
  
  data_Act_lbl_Test <- read.table(file.path("./test","Y_test.txt"), header = FALSE)
  data_Act_Feat_Test <- read.table(file.path("./test","X_test.txt"), header = FALSE)
  data_Sub_Test <- read.table(file.path("./test","subject_test.txt"), header = FALSE)
  
  data_Act_lbl_Train <- read.table(file.path("./train","Y_train.txt"), header = FALSE)
  data_Sub_Train <- read.table(file.path("./train","subject_train.txt"), header = FALSE)
  data_Act_Feat_Train <- read.table(file.path("./train","X_train.txt"), header = FALSE)
  
  print("Merging the training and test data sets to create one data set")
  print("Subject, Activity label and Activity files are merged")
  #Combining the training and test data of related files
  data_Sub_All <- rbind(data_Subj_Train, data_Sub_Test)
  data_Act_Feat_All <- rbind(data_Act_Feat_Test, data_Act_Feat_Train)
  data_Act_lbl_All <- rbind(data_Act_lbl_Test,data_Act_lbl_Train)
  
  print("Adding names to subject and activity data set")
  #Adding column name to subject and activity data set
  names(data_Sub_All) <- c("subject")
  names(data_Act_lbl_All) <- c("activity")
  
  print("Renaming the columns name of activity data frame as per the features.txt")
  #Adding columns names to the Acitivity Feature data set
  names(data_Act_Feat_All) <- data_Feat_Names$V2
  
  print("Creating one Data Set by joining activities, subject and test data")
  #Creating one Data set with activities, subject and test data
  data_fnl <- cbind(data_Act_Feat_All,cbind(data_Act_lbl_All,data_Sub_All))
  
  print("Selecting only mean and std columns from the Data Set")
  #Using grep to select mean() and std() columns from Featutures
  Feat_Name <- grep("mean\\(\\)|std\\(\\)",data_Feat_Names$V2, value= TRUE)
  
  #Adding subject and activity columns to the list of columns to select from final data set
  data_cols <- c(as.character(Feat_Name),"activity","subject")
  
  
  #Subsetting the data with mean and std columns
  data <- data_fnl[,data_cols]
  data <- subset(data_fnl, select = data_cols) # Using subset function
  
  
  print("Merging the data set with Acitivity label to give descriptive activity names")
  library(dplyr)
  #Merging with Activity label data frame and replacing activity column with activity name
  data_act <- merge(data,data_Act_Names, by = "activity")
  data_act <- select(data_act, -activity)
  
  print("Giving descriptive names to remaining column names")
  #Providing dscriptive names to column names
  names(data_act) <-gsub("^t", "time",names(data_act))
  names(data_act) <-gsub("^f", "frequency",names(data_act))
  names(data_act) <-gsub("Acc", "Accelerometer",names(data_act))
  names(data_act) <-gsub("Gyro", "Gyroscope",names(data_act))
  names(data_act) <-gsub("Mag", "Magnitude",names(data_act))
  names(data_act) <-gsub("BodyBody", "Body",names(data_act))
  
  print("Creating new data set with mean value of all variables based on subject and activity")
  #Creating a new data frame with mean values of all variables based on subject and activity
  data_act_mean <- aggregate(.~ subject + activity_name, data_act, mean)
  #Ordering the data by Subject and activity type
  data_act_mean <- data_act_mean[order(data_act_mean$subject, data_act_mean$activity_name),]
  
  print("Creating new tidy file  from the new data set ")
  write.table(data_act_mean,"uci_har_dataset.txt",row.names = FALSE)
}