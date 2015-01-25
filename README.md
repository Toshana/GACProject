README for run_analysis.R

Using the "Human Activity Recognition using Smartphones" dataset located https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip run_analysis creates a tidy data set of the average of each variable for each activity and each subject.

This script uses the R packages plyr and dplyr available at the CRAN repository and should be downloaded before running the script.

It uses read.table to read the test, train, subject, features and activity data into R and then merges it together using cbind and rbind. The "features.txt" file must first be made into a vector of names using the make.names function. The dataframe of merged data is called "mergeData".

Once the data is merged, the relevant average and standard deviation measurements are extracted and used to form a new table called "newData".

At this point, the activity names are not descriptive and must be renamed using the corresponding labels in the "activity_labels.txt" document of the original dataset. The numerical values are replaced using the gsub function. 

The variables are also not appropriately named. They are expanded using the "features_info.txt" document of the original dataset, and replaced again using the gsub function. For easy reading, the data is then sorted by subject using the arrange function.

From this dataset (newData), the ddply function is used to extract into a new tidy dataframe, the average of each variable for each activity and each subject. This new dataframe is called tidydata. Finally, it is written to the text file "tidydata.txt", using the function write.table. 