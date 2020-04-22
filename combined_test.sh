#!/bin/bash

# This bash script: 
#   - Creates a directory for text files (e.g. an audit file, lists of images) to be saved to
#   - Create train and test directories that will later contain both rps_RL and rps_CGI images 
#   - Make lists of rps_RL images for each class (randomly selecting 10% of the images) that will be moved to the test directory  
#   - Move the rps_RL images in the test lists to the test directory
#   - Move the rps_CGI test images to the new test directory 

# The variables:
# $1 = name of an audit txt file  e.g. 17mar2020_audit.txt
# $2 = the textfile name to save the classes to  e.g. asl_classes.txt


# Create a directory to hold future lists that will be iterated through
mkdir -p "rps_lists"
# Sanity verbose
echo "A new directory 'rps_lists' was created."
echo "A new directory 'rps_lists' was created." >> "rps_lists/$1"


# Creating a list of the class filenames to iterate through
ls "rps_RL/training_set" > "rps_lists/$2"
# Sanity verbose
echo "A list of classes was saved to 'rps_lists/$2'."
echo "A list of classes was saved to 'rps_lists/$2'." >> "rps_lists/$1"

# Setting deliminator
IFS="\n"

# Iterate through every class listed in $2 to create directories and make a list of random rps_RL images to be moved to the test directories
while read rps
do 
    # Create a class directory in both the train and test directories
    mkdir -p training_set/"$rps"
    mkdir -p test_set/"$rps"

    # Sanity verbose
    echo "Directory '$rps/' was created in 'training_set/' and 'test_set/'."
    echo "Directory '$rps/' was created in 'training_set/' and 'test_set/'." >> "rps_lists/$1"

    # A count of images in that rps_RL class directory 
    num_images=$(ls -1q "rps_RL/training_set/$rps" | wc -l)
    # Calculate 20% of num_images
    test_size=$(expr $num_images / 5)
  
    # Saving the list of random images to a text file
    ls "rps_RL/training_set/$rps" | sort -R | tail -$test_size > "rps_lists/test_$rps.txt"
    # Sanity verbose 
    echo "The 'rps_lists/test_$rps.txt' was created."
    echo "The 'rps_lists/test_$rps.txt' was created." >> "rps_lists/$1"

done < "rps_lists/$2"

# Update
echo "Now to move the images into the new training and test directories..."
echo "Now to move the images into the new training and test directories..." >> "rps_lists/$1"

while read rps
do
    # First, moving the designated preprocessed rps_RL test images to the new test directory
    while read image 
    do
        # Move the images listed in testlist to test_set in designated class
        mv "rps_RL/training_set/$rps/$image" "test_set/$rps/"

        # Sanity verbose
        echo "$image was moved to test_set/$rps"
        echo "$image was moved to test_set/$rps" >> "rps_lists/$1"

    done < "rps_lists/test_$rps.txt"

    # Update
    echo "For rps_RL: Class {$rps} test images moved."
    echo "For rps_RL: Class {$rps} test images moved." >> "rps_lists/$1"


    # Next, moving the remaining preprocessed rps_RL images to the new training directory
    mv rps_RL/training_set/$rps/* "training_set/$rps/"

    # Update
    echo "Remaining $rps rps_RL images moved to training_set/$rps"
    echo "Remaining $rps rps_RL images moved to training_set/$rps" >> "rps_lists/$1"


    # Finally, combining the rps_CGI dataset 
    # Training set
    mv rps_CGI/training_set/$rps/* "training_set/$rps/"
    # Test set
    mv rps_CGI/test_set/$rps/* "test_set/$rps/"

    # Update
    echo "rps_CGI and rps_RL $rps training and test sets combined"
    echo "rps_CGI and rps_RL $rps training and test sets combined" >> "rps_lists/$1"

done < "rps_lists/$2"
