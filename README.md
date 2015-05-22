---
#title: "Readme"
#author: "Jan-Christopher Koch"
#date: "Friday, May 22, 2015"
output: html_document
---
# README

This README filex explain the steps of the run_analysis.R function in greater detail.
It is assumed that run_analysis.R as well as a folder with the name "UCI HAR Dataset" 
(containing the data of the zip file https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
are present in the current working directory of R.

The following works  on my system, i.e. with RStudio in version 0.98.1103 and
```{r}
R version 3.2.0 (2015-04-16)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows 7 x64 (build 7601) Service Pack 1

locale:
[1] LC_COLLATE=German_Germany.1252  LC_CTYPE=German_Germany.1252    LC_MONETARY=German_Germany.1252 LC_NUMERIC=C                   
[5] LC_TIME=German_Germany.1252    

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] dplyr_0.4.1

loaded via a namespace (and not attached):
 [1] Rcpp_0.11.6     digest_0.6.8    assertthat_0.1  bitops_1.0-6    DBI_0.3.1       magrittr_1.5    swirl_2.2.21    httr_0.6.1      stringi_0.4-1  
[10] lazyeval_0.1.10 testthat_0.9.1  rmarkdown_0.6.1 tools_3.2.0     stringr_1.0.0   RCurl_1.95-4.6  yaml_2.1.13     parallel_3.2.0  htmltools_0.2.6
```
obtained from 
```{r}
sessionInfo()
```

**Note:** I'm working with the dplyr package



## Preprocessing
The run_analyis.R script (in the following refered to simply as script) changes the working directory to the "UCI HAR Dataset"-folder if the folder exists. Otherwise the script stops with an error.
Next the dply package is loaded

## Step 1
The relevant data from the test and train subdirectory are loaded. It is important to recall that ``read.table`` uses at least one white space as a separator by default.

From these data a new data frame merged with the dimension $10299* 563$ is constructed in the following way:

1. The first column of merged contains the subject IDs (obtained from  "subject_*.txt")
2. The second column contains the activity IDs (obtained from "y_*.txt")
3. The remaining 561 columns consinst of  several sensor measurement values (obtained from ("X_*.txt")
4. The first 7352 rows consist of the training data
5. The last 2947 rows consist of the test data

Thus, each row contains a lot of measurement values assigned to a subject and an activty. 

## Step 2

A subset of merged is extracted and stored in extracted_df. 
From the columns containing (as a prefix)
one of

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

the ones also containing (as a postfix) mean and std were selected.

**Note:**  The data containing one of

* gravityMean
* tBodyAccMean
* tBodyAccJerkMean
* tBodyGyroMean
* tBodyGyroJerkMean,

used to calculate the angle between vectors,
are not chosen. Essentially, these values can be reconstructed from the other data. Thus, to obtain a more compact data set I decided to neglect these features. 

**Note:** Only in the last features Mean starts with an uppercase letter!

To select these features, the second column of the features.txt file is passed to grep
```{r}
selected_features <- features[,2] %>%  grep(pattern="mean|std")
```
**Note:**
Changing the pattern to ``pattern="[Mm]ean|std`` yields a data set that contains also the variables with uppercase "Mean"

Finally, the extracted dataframe contains the subject id, activity and the selected features

## Step 3

The activity colum is transformed into a factor variable. To map the numeric values to descriptive names, we refer to the "activity_labels.txt"
and use 
```{r}
levels(extracted_df[,2])<-c("walking","walkingupstairs","walkingdownstairs","sitting","standing","laying")
```
**Note:** Particularly, due to the ordering of the vector ``1:6``, level 1 is replaced by ``"walking"``, level 2 is replaced by ``"walkingupstairs"``, etc.  
Here, it is convenient to use lowercase labels, as suggested by the coursera lecture on "Editing text variables"

## Step4
We set more descriptive labels for the columns from extracted_df
Obviously, I chose ``"subject_ID"`` and ``"activity"`` for the first two columns.

From my point of view the labels describe in the ``"features.txt"`` file are quite descriptive. Since I like the KISS-principle, I simply chose the lables from that file that correspond to the selected features for the remaining columns. 

## Step 5

Using the dplyr-package, a second tidy data set is constructed starting from extracted_df. 
We apply``as.tbl`` to extracted_df to use the dplyr package afterwards. 
Then we group first by ``"subject_ID"`` and then by ``"activity"``.
On these groups, we compute from every measurement/variable the mean and standard deviation (thus almost doubling the number of columns) and store it in a data frame calles ``tidy``. Dplyr automatically attaches _mean and _sd to the respective column name. I refrained from transforming the variable names to lowercase letters due to worse readability

## Postprocessing
The script changes the working directory back to the original and writes tidy into the ``"tidy.txt"``-file







