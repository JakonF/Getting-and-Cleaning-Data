Getting and Cleaning Data
===========

This is the course project README file. The purpose of this project is to demonstrate our ability to collect, work with, and clean a data set. 

The goal is to prepare tidy data (from raw data) that can be used for later analysis.

A full description of raw data is available at the [UCI Machine Learning Repository](
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones); here you can [download the dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

Let's see how the script run_analysis.R work.

First of all I read the activity labels file and the features file (that contains variables name):
<!-- -->
      # activity names
      file <- ".\\activity_labels.txt"
      anames <- read.table(file)
      anames <- as.vector(anames[,2])
      
      # variable names
      file <- "features.txt"
      cnames <- read.table(file)
      cnames <- c("subject", "activity", as.vector(cnames$V2))

To merge training and test set I read, for both training and test, the raw data file, the activity file (activity performed for each record) and the subject file (the id of the subject who performed the activity):
<!-- -->
      # join training and test set
      file <- ".\\train\\X_train.txt"
      file_a <- ".\\train\\y_train.txt"
      file_s <- ".\\train\\subject_train.txt"
      dset <- cbind(read.table(file_s), apply(read.table(file_a),1,function(idx) anames[idx]), read.table(file))
      
      file <- ".\\test\\X_test.txt"
      file_a <- ".\\test\\y_test.txt"
      file_s <- ".\\test\\subject_test.txt"
      dset <- rbind(dset, cbind(read.table(file_s), apply(read.table(file_a),1,function(idx) anames[idx]), read.table(file)))

      # set variables names
      colnames(dset) <- cnames

Next step I select only the measurements on the mean and standard deviation for each measurement:
<!-- -->
      mean_std <- c(1, 2, grep("-mean()", cnames), grep("-std()", cnames))
      dset_ms <- data.table(dset[mean_std])

The conversion to a data.table object makes easier the creation of the tidy data set as we can calculate in one step the mean for each distinct occurrence of the key sucject-activity:
<!-- -->
      tidy_d <- dset_ms[,lapply(.SD,mean),by="subject,activity"]

Finally I write the tidy dataset to a file:
<!-- -->
      file <- ".\\tidy.txt"
      write.table(tidy_d, file)
