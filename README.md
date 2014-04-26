# Getting and Cleaning Data Project

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

You should create one R script called run_analysis.R that does the following. 
* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive activity names. 
* Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 



## Running the script

- Clone this repository
- Download the [data set](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and extract. It should result in a UCI HAR Dataset  folder that has all the files in the required structure.
- Change current directory to the folder where `UCI HAR Dataset` is located.
- Run `Rscript <path to>/run_analysis.R` 
- The tidy dataset should get created in the current directory as `tidy.txt`


## Assumptions

- The training and test data are available in folders named `train` and `test` respectively.
- For each of these data sets:
    - Measurements are present in `X_<dataset>.txt` file
    - Subject information is present in `subject_<dataset>.txt` file
    - Activity codes are present in `y_<dataset>.txt` file
- All activity codes and their labels are in a file named `activity_labels.txt`.
- Names of all measurements taken are present in file `features.txt` ordered and indexed as they appear in the `X_<dataset>.txt` files.
- All columns representing means contain `...mean()` in them.
- All columns representing standard deviations contain `...std()` in them.


## Data Preparation Steps

1. For each of the training and test datasets, 
    1.1 Read the `X` values
    1.2 Only read the columns related with mean and std defining the respective class. This is helping performance and saving memory avoiding to load the entire dataset.
    1.3 Associate additional columns to represent activity IDs and subject IDs read from `y_<dataset>.txt` and `subject_<dataset>.txt` files respectively.
    1.4 Assign column names by manipulating the measurement names in `features.txt` to remove spaces and convert them to camel case.
2. Merge the training and the test sets, read as in step 1 to create one data set.
3. Associate an additional column with descriptive activity names as specified in `activity_labels.txt`.
4. Melt the dataset by specifying activity ID, name and subject ID as the only ID variables.
5. Re cast the melted dataset in step 4 with activity name and subject id as the only IDs and `mean` as the aggregator function.
6. Save the resultin re-casted dataset as `tidy.txt`


