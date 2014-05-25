## Introduction
This script processes a raw data set that was compiled on wearable
computing data, and transforms it into a tidy data set.

## Usage
Prior to running the script, the data must be obtained from
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR
%20Dataset.zip and must be extracted to the same folder containing the
script.

The only required library is reshape2, which can be installed at your
leasure using install.packages(reshape2). The code requires the library,
but does not install it.

In order to produce tidy_data.txt, run the following commands in an R
prompt:

df <- MergeFiles()
WriteTidyData(df)


## Decisions made
The test and training data sets were first merged into a single data
frame using rbind. This was acceptable because they each measured the
same features (had the same number of columns). Then, the subject and
activity labels were added using cbind, because they contained the same
number of columns as this resulting data frame.

After adding headers to the merged data frame, a subset of this data
frame was selected using only columns that contained the string "mean()"
or "std()". Presumably, these were the mean and standard deviation
measurements in the project description.

Then, the data is reshaped and summarized by calculating the mean and
standard deviation for each combination of subject and activity.

