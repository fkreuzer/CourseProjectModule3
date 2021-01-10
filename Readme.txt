run_Analysis.R
===============

This script performs the following data preparation tasks on the dataset:

==================================================================
Human Activity Recognition Using Smartphones Dataset
Version 1.0
==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Universit‡ degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================



Step 1:
=======
Preprocessing of data files:

In order to prepare the .txt files X_test/train for import with read.delim(), double whitespaces are replaced with single whitespaces.
The resulting strings are then written to two new files X_test/train_p

Step 2:
=======
Reading in the feature names

Feature names are being read from the features.txt file

Step 3:
=======
Reading in X data

The data in X_test/train is read in.

Step 4:
=======
Reading in y data

The y data are read from the y_test/train files.

Step 5:
=======
Activity labels are changed

The activity labels 1-6 are changed to meaningful activity names.

Step 6:
=======
Reading in subject data

Subject data is read in from subject_test/train files.

Step 7:
=======
Building tibbles for test and train data and subsequently only the mean and std variables are kept

Step 8:
=======
Add subject and y data

Subject and y data are added to the X data tibbles for test and train.

Step 9:
=======
Cleaning up label names

Cleaning up label names by replacing/removing "-" and "()" and and "mean/std" with "Mean" and "Standard Deviation"

Step 10:
========
Combine datasets

Combine the test and train datasets

Step 11:
========
Get the mean data of all the features per subject and activity.

Using pipeline operator from dplyr package to summarize the combined dataset and obtain the mean of all the features grouped by subject and activity.

Step 12:
========
Write mean data to .txt file

Write mean data to .txt file


