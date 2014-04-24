readFile <- function (path, type, suffix, cnames, cclasses) {
  fname <- file.path(path,type,paste0(suffix, type, ".txt"))
  print(paste("Reading:",fname))
  if (missing(cclasses))
    data <- read.table(fname,header=F,col.names=cnames)
  else
    data <- read.table(fname,header=F,col.names=cnames,colClasses=cclasses)
  
  data
}

#Read the data set using a type that can be Test or Train
readDataSet<- function (path, type) {
  require(data.table)
  #read column names
  col_names <- readFile(path,"","features",c("MeasureID", "MeasureName"))
  col_class <- as.character(col_names$MeasureName)
  col_class[grep(".*mean\\(\\)|.*std\\(\\)",col_class)]<-"numeric"
  col_class[col_class!="numeric"]<-"NULL"
  
  #read Y data
  y_data <- readFile(path,type,"y_",c("ActivityID"))  
  subject_data <- readFile(path,type,"subject_",c("SubjectID"))
  
  #read X Data
  x_data <- readFile(path,type,"X_",col_names$MeasureName,col_class)
  x_data$ActivityID <- y_data$ActivityID
  x_data$SubjectID <- subject_data$SubjectID
  
  x_data
}

#Merge train and test data sets
#Make readable the column names
#Add the Activity Name labels
getMergeDataSet <- function () {
  path <- "UCI HAR Dataset"
  test_data <- readDataSet(path,"test")
  train_data <- readDataSet(path,"train")
  
  #Merge the train and test dataset
  print("Merging the train and test dataset")
  
  data <- rbind(test_data,train_data)
  
  #Make the column names readable
  print("Renaming measure columns")
  col_names <- colnames(data)
  col_names  <- gsub("\\.+mean\\.+", col_names, replacement="Mean")
  col_names  <- gsub("\\.+std\\.+",  col_names, replacement="Std")
  colnames(data) <- col_names

  # Add the activity names
  print("Adding activity names")
  activity_labels <- readFile(path,"","activity_labels",c("ActivityID", "ActivityName"))
  activity_labels$ActivityName <- as.factor(activity_labels$ActivityName)
  data <- merge(data, activity_labels)
  
  data
}

#Create the tidy dataset and save with a given file name
createTidyData <- function (filename) {
  
  require(reshape2)
  library(reshape2)
  
  merged_dataset <- mergeDataSet()
  
  #Melt and Reshape the dataset
  print("Melting dataset")
  id_columns<-c("ActivityID", "ActivityName", "SubjectID")
  measure_columns = setdiff(colnames(merged_dataset),id_columns)
  melted_data <- melt(merged_dataset, id=id_columns,measure.vars=measure_columns)
  tidy_data <- dcast(melted_data,ActivityName+SubjectID ~ variable, mean)
  
  print(paste("Creating tidy file: ",filename))
  if (file.exists(filename))
    file.remove(filename)
  write.table(tidy_data,filename)
  print(paste("The tidy file: ",filename,"was created sucessfully!"))
}
  

createTidyData("tidy.txt")