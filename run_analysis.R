library(data.table)

# activity names
file <- ".\\activity_labels.txt"
anames <- read.table(file)
anames <- as.vector(anames[,2])

# variable names
file <- "features.txt"
cnames <- read.table(file)
cnames <- c("subject", "activity", as.vector(cnames$V2))

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

# extracts only the measurements on the mean and standard deviation for each measurement
mean_std <- c(1, 2, grep("-mean()", cnames), grep("-std()", cnames))
dset_ms <- data.table(dset[mean_std])

tidy_d <- dset_ms[,lapply(.SD,mean),by="subject,activity"]
file <- ".\\tidy.txt"
write.table(tidy_d, file)
