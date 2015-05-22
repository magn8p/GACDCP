## Preprocessing
        print("Preprocessing")
        if (dir.exists("UCI HAR Dataset")){setwd("UCI HAR Dataset")}else {stop("Dataset not found")}
        library("dplyr")

## Step 1: Merging the training and the test sets into one data set.
        print("Step 1: Merging the training and the test sets into one data set")
### Reading in the data

        X_test <- read.table("test/X_test.txt")
        Y_test <- read.table("test/y_test.txt")
        subject_test <- read.table("test/subject_test.txt")

        X_train <- read.table("train/X_train.txt")
        Y_train <- read.table("train/y_train.txt")
        subject_train <- read.table("train/subject_train.txt")

### Merging the data
        merged <- rbind(cbind(subject_train,Y_train,X_train),cbind(subject_test,Y_test,X_test))

## Step 2: Extracting only the measurements on the mean and standard deviation for each measurement \n
        print("Step 2: Extracting only the measurements on the mean and standard deviation for each measurement")
        
features <-read.table("features.txt")
        selected_features <- features[,2] %>%  grep(pattern="mean|std")
        # +2 since the feature variables start at position 3
        extracted_df <- merged[,c(1,2,selected_features+2)]
        
## Step 3: Descriptive activity names for the activities in the data set 
        print("Step 3: Descriptive activity names for the activities in the data set")
        
### Turn second variable/column into factor and set the levels according to "activity_labels.txt", 
        extracted_df[,2]<- factor(extracted_df[,2])
        levels(extracted_df[,2])<-c("walking","walkingupstairs","walkingdownstairs","sitting","standing","laying")
       

## Step 4: Appropriate labelling of the data set with descriptive variable names
        print("Step 4: Appropriate labelling of the data set with descriptive variable names")
        
        colnames(extracted_df) <- c("subject_ID", "activity",as.character(features[selected_features,2]))
        
## Step 5: From the data set in step 4, create a second, independent tidy data set 
##         with the average of each variable for each activity and each subject
        
        print("Step 5: Create second tidy data set")

### Use summarise_each from dplyr to obtain the desired output
        
        tidy <- as.tbl(extracted_df) %>% group_by(subject_ID,activity) %>% summarise_each(funs(mean,sd))       
        

## Postprocessing
        print("Postprocessing")
        setwd("../")
        write.table(tidy, "tidy.txt", row.name=FALSE)
