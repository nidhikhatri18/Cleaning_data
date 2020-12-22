features contains orignial feature vector names
X_train contains train data
subject_train contains subjects
y_train contains labeling of training data
X_test contains test data
subject_test contains subjects
y_test contains labeling of testing data
activities contain the list of activities with descriptive names
x combines x_train and x_test
y combines y_train and y_test
subject combine subject_train and subject_test
merged_data combines subject,y and x

TidyData contains specific column from merged_data such as subject,activity,mean and std only.

FinalData select the data by same subject and activity and conatin average of each activity.source('~/RProject/cleaningdata/project.R')
