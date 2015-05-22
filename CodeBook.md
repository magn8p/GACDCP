---
title: "Getting and Cleaning Data Course Project"
author: "Jan-Christopher Koch"
date: "Friday, May 22, 2015"
output: html_document
    
---
 
## Project Description

This Coursera project consists of generating two tidy data sets from publically  available (non-tidy) data.
The regime of the provided data is wearable computing. Beside a tidy data set, 
we are asked to submit a Codebook.md, README.md and run_analysis.R. The last three files can be found im my [github repository](https://github.com/JaKo84/GACDCP)

 
##Study design and data processing

The data wer presented during a course project in the Getting and Cleaning data Coursera course. Originally, the data we work with can be found in reference [1]. 

From my point of view, the raw data, i.e. the data we are going to transform, are the following files (including files for information, like readme.txt), found in the "UCI HAR Dataset"-folder contained in the [zip file](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) :

* "activity_labels.txt" 
* "features.txt"
* "features_info.txt"
* "README.txt"
* "test/subject_test.txt"
* "test/X_test.txt"
* "test/y_test.txt"
* "train/subject_train.txt"
* "train/X_train.txt"
* "train/y_train.txt"

Let me quote how these data were obtained

>The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its mbedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

>The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

>For each record in the dataset it is provided: 
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment


#### Raw data variables

Essentially in the raw data (found in the files listed above), there are 563 variables.
For each variable there are 2947 test and  train 7352 observations

Summary of the variables

1. subject - for train and test observations. integer format, range from 1 to 30. 
2. activity - for train and test observations. integer format, range from 1 to 6. 
3. measurement variables (exact names can be found in "features.txt" and information in "features_info.txt"), double format, **normalized** between -1 and 1, 561 variables


 
##Creating the tidy datafile
 The following instruction worked for me under RStudio version 0.98.1103 and
 
```{r} 
R version 3.2.0 (2015-04-16)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows 7 x64 (build 7601) Service Pack 1
...
attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] dplyr_0.4.1
...
```

###Guide to create the tidy data file
1. Download the data from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) 
2. Unzip the data file to your desired directory
3. Store the [run_analysis.R](https://github.com/JaKo84/GACDCP/blob/master/run_analysis.R) script in the same directory (not in the "UCI HAR Directory", but in its parent)
4. Make sure that your R working directory is where the run_analysis.R file is located in (use``setwd``)
5. Download the dplyr package for r
6. Run the run_analysis.R script using source
7. After succesfully performing this procedure, you find the ``"tidy.txt"`` in the same directory as the run_analysis.R script

For step 1 and 2 using R-Studio, you can use
```{r}
if(!(file.exists("data.zip"))){download.files("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")}
unzip("data.zip")
```
For steps 5 and 6 you can use
```{r}
install.packages("dplyr")
source('run_analysis.R')

```

###Cleaning of the data
A full description of the run_analysis.R script can be found in my [README.md](https://github.com/JaKo84/GACDCP/blob/master/README.md)

In short the script does the following.

1. The raw training and test data are merge into one data frame. The first two columns are related to the subject and activity. Both variables are fixed variables in the sense of Hadley Wickham [2] and thus should come first in the data frame.
2. From this data frame the script extracts a smaller data frame, by neglecting the measruement variables that are not related to a mean or a standard deviation. Additionally, the various angles, though containing several **M**ean(s) are also neglected, since these quantities can be computed from the other quantities. Nevertheless, the README.md file explains how to include these variables
3. Appropriate labels for the activity levels are introduced. Type is of the variable is changed from numeric(integer) to factor.
4. Appropriate column names are chosen (using the KISS-principle, since the original ones are quite descriptive). And the data set in this step is tidy. Each column corresponds to one variable and each row describes one observation of the measurement variables for one person and one activity
5. From the tidy data set in step 4 another tidy data set is obtained by grouping the activities for each subject. In these groups, the mean and standard deviation of each measurement variable is computed. Again, this data set is tidy, since each column consists of one variable and each row describes for one subject and one group the mean and standard devitation of the measurement variables.
6. The tidy data frame is saved on the hard drive


## CodeBook

###Description of the variables in the tidy.txt file
Dimension of the dataset (tidy)
 
```{r}
dim(tidy)
[1] 180 160
```

Variable names:

```{r}
> colnames(tidy)
  [1] "subject_ID"                           "activity"                             "tBodyAcc-mean()-X_mean"              
  [4] "tBodyAcc-mean()-Y_mean"               "tBodyAcc-mean()-Z_mean"               "tBodyAcc-std()-X_mean"               
  [7] "tBodyAcc-std()-Y_mean"                "tBodyAcc-std()-Z_mean"                "tGravityAcc-mean()-X_mean"           
 [10] "tGravityAcc-mean()-Y_mean"            "tGravityAcc-mean()-Z_mean"            "tGravityAcc-std()-X_mean"            
 [13] "tGravityAcc-std()-Y_mean"             "tGravityAcc-std()-Z_mean"             "tBodyAccJerk-mean()-X_mean"          
 [16] "tBodyAccJerk-mean()-Y_mean"           "tBodyAccJerk-mean()-Z_mean"           "tBodyAccJerk-std()-X_mean"           
 [19] "tBodyAccJerk-std()-Y_mean"            "tBodyAccJerk-std()-Z_mean"            "tBodyGyro-mean()-X_mean"             
 [22] "tBodyGyro-mean()-Y_mean"              "tBodyGyro-mean()-Z_mean"              "tBodyGyro-std()-X_mean"              
 [25] "tBodyGyro-std()-Y_mean"               "tBodyGyro-std()-Z_mean"               "tBodyGyroJerk-mean()-X_mean"         
 [28] "tBodyGyroJerk-mean()-Y_mean"          "tBodyGyroJerk-mean()-Z_mean"          "tBodyGyroJerk-std()-X_mean"          
 [31] "tBodyGyroJerk-std()-Y_mean"           "tBodyGyroJerk-std()-Z_mean"           "tBodyAccMag-mean()_mean"             
 [34] "tBodyAccMag-std()_mean"               "tGravityAccMag-mean()_mean"           "tGravityAccMag-std()_mean"           
 [37] "tBodyAccJerkMag-mean()_mean"          "tBodyAccJerkMag-std()_mean"           "tBodyGyroMag-mean()_mean"            
 [40] "tBodyGyroMag-std()_mean"              "tBodyGyroJerkMag-mean()_mean"         "tBodyGyroJerkMag-std()_mean"         
 [43] "fBodyAcc-mean()-X_mean"               "fBodyAcc-mean()-Y_mean"               "fBodyAcc-mean()-Z_mean"              
 [46] "fBodyAcc-std()-X_mean"                "fBodyAcc-std()-Y_mean"                "fBodyAcc-std()-Z_mean"               
 [49] "fBodyAcc-meanFreq()-X_mean"           "fBodyAcc-meanFreq()-Y_mean"           "fBodyAcc-meanFreq()-Z_mean"          
 [52] "fBodyAccJerk-mean()-X_mean"           "fBodyAccJerk-mean()-Y_mean"           "fBodyAccJerk-mean()-Z_mean"          
 [55] "fBodyAccJerk-std()-X_mean"            "fBodyAccJerk-std()-Y_mean"            "fBodyAccJerk-std()-Z_mean"           
 [58] "fBodyAccJerk-meanFreq()-X_mean"       "fBodyAccJerk-meanFreq()-Y_mean"       "fBodyAccJerk-meanFreq()-Z_mean"      
 [61] "fBodyGyro-mean()-X_mean"              "fBodyGyro-mean()-Y_mean"              "fBodyGyro-mean()-Z_mean"             
 [64] "fBodyGyro-std()-X_mean"               "fBodyGyro-std()-Y_mean"               "fBodyGyro-std()-Z_mean"              
 [67] "fBodyGyro-meanFreq()-X_mean"          "fBodyGyro-meanFreq()-Y_mean"          "fBodyGyro-meanFreq()-Z_mean"         
 [70] "fBodyAccMag-mean()_mean"              "fBodyAccMag-std()_mean"               "fBodyAccMag-meanFreq()_mean"         
 [73] "fBodyBodyAccJerkMag-mean()_mean"      "fBodyBodyAccJerkMag-std()_mean"       "fBodyBodyAccJerkMag-meanFreq()_mean" 
 [76] "fBodyBodyGyroMag-mean()_mean"         "fBodyBodyGyroMag-std()_mean"          "fBodyBodyGyroMag-meanFreq()_mean"    
 [79] "fBodyBodyGyroJerkMag-mean()_mean"     "fBodyBodyGyroJerkMag-std()_mean"      "fBodyBodyGyroJerkMag-meanFreq()_mean"
 [82] "tBodyAcc-mean()-X_sd"                 "tBodyAcc-mean()-Y_sd"                 "tBodyAcc-mean()-Z_sd"                
 [85] "tBodyAcc-std()-X_sd"                  "tBodyAcc-std()-Y_sd"                  "tBodyAcc-std()-Z_sd"                 
 [88] "tGravityAcc-mean()-X_sd"              "tGravityAcc-mean()-Y_sd"              "tGravityAcc-mean()-Z_sd"             
 [91] "tGravityAcc-std()-X_sd"               "tGravityAcc-std()-Y_sd"               "tGravityAcc-std()-Z_sd"              
 [94] "tBodyAccJerk-mean()-X_sd"             "tBodyAccJerk-mean()-Y_sd"             "tBodyAccJerk-mean()-Z_sd"            
 [97] "tBodyAccJerk-std()-X_sd"              "tBodyAccJerk-std()-Y_sd"              "tBodyAccJerk-std()-Z_sd"             
[100] "tBodyGyro-mean()-X_sd"                "tBodyGyro-mean()-Y_sd"                "tBodyGyro-mean()-Z_sd"               
[103] "tBodyGyro-std()-X_sd"                 "tBodyGyro-std()-Y_sd"                 "tBodyGyro-std()-Z_sd"                
[106] "tBodyGyroJerk-mean()-X_sd"            "tBodyGyroJerk-mean()-Y_sd"            "tBodyGyroJerk-mean()-Z_sd"           
[109] "tBodyGyroJerk-std()-X_sd"             "tBodyGyroJerk-std()-Y_sd"             "tBodyGyroJerk-std()-Z_sd"            
[112] "tBodyAccMag-mean()_sd"                "tBodyAccMag-std()_sd"                 "tGravityAccMag-mean()_sd"            
[115] "tGravityAccMag-std()_sd"              "tBodyAccJerkMag-mean()_sd"            "tBodyAccJerkMag-std()_sd"            
[118] "tBodyGyroMag-mean()_sd"               "tBodyGyroMag-std()_sd"                "tBodyGyroJerkMag-mean()_sd"          
[121] "tBodyGyroJerkMag-std()_sd"            "fBodyAcc-mean()-X_sd"                 "fBodyAcc-mean()-Y_sd"                
[124] "fBodyAcc-mean()-Z_sd"                 "fBodyAcc-std()-X_sd"                  "fBodyAcc-std()-Y_sd"                 
[127] "fBodyAcc-std()-Z_sd"                  "fBodyAcc-meanFreq()-X_sd"             "fBodyAcc-meanFreq()-Y_sd"            
[130] "fBodyAcc-meanFreq()-Z_sd"             "fBodyAccJerk-mean()-X_sd"             "fBodyAccJerk-mean()-Y_sd"            
[133] "fBodyAccJerk-mean()-Z_sd"             "fBodyAccJerk-std()-X_sd"              "fBodyAccJerk-std()-Y_sd"             
[136] "fBodyAccJerk-std()-Z_sd"              "fBodyAccJerk-meanFreq()-X_sd"         "fBodyAccJerk-meanFreq()-Y_sd"        
[139] "fBodyAccJerk-meanFreq()-Z_sd"         "fBodyGyro-mean()-X_sd"                "fBodyGyro-mean()-Y_sd"               
[142] "fBodyGyro-mean()-Z_sd"                "fBodyGyro-std()-X_sd"                 "fBodyGyro-std()-Y_sd"                
[145] "fBodyGyro-std()-Z_sd"                 "fBodyGyro-meanFreq()-X_sd"            "fBodyGyro-meanFreq()-Y_sd"           
[148] "fBodyGyro-meanFreq()-Z_sd"            "fBodyAccMag-mean()_sd"                "fBodyAccMag-std()_sd"                
[151] "fBodyAccMag-meanFreq()_sd"            "fBodyBodyAccJerkMag-mean()_sd"        "fBodyBodyAccJerkMag-std()_sd"        
[154] "fBodyBodyAccJerkMag-meanFreq()_sd"    "fBodyBodyGyroMag-mean()_sd"           "fBodyBodyGyroMag-std()_sd"           
[157] "fBodyBodyGyroMag-meanFreq()_sd"       "fBodyBodyGyroJerkMag-mean()_sd"       "fBodyBodyGyroJerkMag-std()_sd"       
[160] "fBodyBodyGyroJerkMag-meanFreq()_sd"  
```

 
### Variable 1 --- subject_ID
The subject_ID is used to refer to a specific person that took part in the experiment.

Properties:

1. subject_id is the same as in the original data set, i.e. it is derived from the subject*.txt-files
2. 30 Person participated in the experiment, thus subject_ID takes integer values betwen 1 and 30
3. No Unit of measurement known

### Variable 2 --- activity
Describes the activity of the subject performed during one observation of the experiment

Properties:

1. Factor variable
2. "walking","walkingupstairs","walkingdownstairs","sitting","standing","laying"
3. It is derived from the y*.txt-files by mapping the values of 1 to 6 to the list shown in bullet 2. This is according to
the activity_labels.txt file

### Variables 3-160 --- *_mean or *_sd

The following variable all correspond to certain measurement and computation of sensors used in the experiment.

Properties:

1. The variables are numerical real/rational variables in the interval [-1,1] (due to normalization)
2. No unit of measurement known

The names of the variables follow the following scheme:

From the original 561 measurement variables, the script select the following 79 variables

```{r}
features[selected_features,2]
 [1] tBodyAcc-mean()-X               tBodyAcc-mean()-Y               tBodyAcc-mean()-Z               tBodyAcc-std()-X               
 [5] tBodyAcc-std()-Y                tBodyAcc-std()-Z                tGravityAcc-mean()-X            tGravityAcc-mean()-Y           
 [9] tGravityAcc-mean()-Z            tGravityAcc-std()-X             tGravityAcc-std()-Y             tGravityAcc-std()-Z            
[13] tBodyAccJerk-mean()-X           tBodyAccJerk-mean()-Y           tBodyAccJerk-mean()-Z           tBodyAccJerk-std()-X           
[17] tBodyAccJerk-std()-Y            tBodyAccJerk-std()-Z            tBodyGyro-mean()-X              tBodyGyro-mean()-Y             
[21] tBodyGyro-mean()-Z              tBodyGyro-std()-X               tBodyGyro-std()-Y               tBodyGyro-std()-Z              
[25] tBodyGyroJerk-mean()-X          tBodyGyroJerk-mean()-Y          tBodyGyroJerk-mean()-Z          tBodyGyroJerk-std()-X          
[29] tBodyGyroJerk-std()-Y           tBodyGyroJerk-std()-Z           tBodyAccMag-mean()              tBodyAccMag-std()              
[33] tGravityAccMag-mean()           tGravityAccMag-std()            tBodyAccJerkMag-mean()          tBodyAccJerkMag-std()          
[37] tBodyGyroMag-mean()             tBodyGyroMag-std()              tBodyGyroJerkMag-mean()         tBodyGyroJerkMag-std()         
[41] fBodyAcc-mean()-X               fBodyAcc-mean()-Y               fBodyAcc-mean()-Z               fBodyAcc-std()-X               
[45] fBodyAcc-std()-Y                fBodyAcc-std()-Z                fBodyAcc-meanFreq()-X           fBodyAcc-meanFreq()-Y          
[49] fBodyAcc-meanFreq()-Z           fBodyAccJerk-mean()-X           fBodyAccJerk-mean()-Y           fBodyAccJerk-mean()-Z          
[53] fBodyAccJerk-std()-X            fBodyAccJerk-std()-Y            fBodyAccJerk-std()-Z            fBodyAccJerk-meanFreq()-X      
[57] fBodyAccJerk-meanFreq()-Y       fBodyAccJerk-meanFreq()-Z       fBodyGyro-mean()-X              fBodyGyro-mean()-Y             
[61] fBodyGyro-mean()-Z              fBodyGyro-std()-X               fBodyGyro-std()-Y               fBodyGyro-std()-Z              
[65] fBodyGyro-meanFreq()-X          fBodyGyro-meanFreq()-Y          fBodyGyro-meanFreq()-Z          fBodyAccMag-mean()             
[69] fBodyAccMag-std()               fBodyAccMag-meanFreq()          fBodyBodyAccJerkMag-mean()      fBodyBodyAccJerkMag-std()      
[73] fBodyBodyAccJerkMag-meanFreq()  fBodyBodyGyroMag-mean()         fBodyBodyGyroMag-std()          fBodyBodyGyroMag-meanFreq()    
[77] fBodyBodyGyroJerkMag-mean()     fBodyBodyGyroJerkMag-std()      fBodyBodyGyroJerkMag-meanFreq()
477 Levels: angle(tBodyAccJerkMean),gravityMean) angle(tBodyAccMean,gravity) ... tGravityAccMag-std()
```

For every of the variables, we compute the mean and standard deviation with respect to the subject_ID and activity. The dplyr package automatically append either ``_mean`` for the mean or ``_sd`` for the standard deviation to the column names.
This gives the list at the beginning of the CodeBook-section.
Note that first all *_mean variables appear in the list. The *_sd variables appear at the end of the list

 
##Sources
This CodeBook was inspired by the https://gist.github.com/JorisSchut/dbc1fc0402f28cad9b41 from Joris Schut.

I appreciate the authors of [1] for providing the dataset for free non-commercial use. The data set can also be found on 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
Additionally, I recommend the nice free article [2] by Hadley Wickham on tidy date. It helped a lot.


[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

[2] Hadley Wickham, Tidy Data, Journal of Statistical Software Vol. 59, Issue 10, Sep 2014


