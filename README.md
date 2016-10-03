# Getting-and-Cleaning-Data-Project
This is final project in Coursera's Getting and Cleaning Data
## run_analysis.R

The clean up script is used to perform following 
  1. Merges the training and test data
  2. Extracts mean and std varialble related data
  3. Provides descriptive names to activity
  4. Provides descriptive names to all varialbe columns
  4. Creates new file by calculating mean values of all variables based on subject and activity

## Process

  1. Download the zip file and extract the data into local directory
  2. Creates data frames from the source files
  3. Merges training and test related data frames and creates below related files
    i. subject
    ii. Activity Features
    iii. Activity Label
  4. Merge above three data frames by column wise to created one data set with all details
  5. JOIN the data set with Activity name data frame to retrieve activity name for corresponding activity in data set.
  6. Gives descriptive names to all variable columns
  7. Create new dataset by calculating mean value of all variables based on subject and activity
  
## Clean Data
The resulting dataset is writtedn to disc/directory as text file.
