#!/bin/bash

## ----------------------------------
# Step #1: Define variables
# ----------------------------------
EDITOR=vim
PASSWD=/etc/passwd
RED='\033[0;41;30m'
STD='\033[0;0;39m'
columns="$(tput cols)"
threshold= 0.0
 
# ----------------------------------
# Step #2: User defined function
# ----------------------------------
pause(){
  read -p "Press [Enter] key to continue..." fackEnterKey
}

print_center(){
	printf "%*s\n" $(( (${#1} + $columns) / 2)) "$1"
}

run_change_classifier(){		
	echo
        print_center "**** EXECUTING THE CHANGE CLASSIFIER ****"
	echo 
	echo
	echo "**********************************************************************"
	echo "Do you want to run linear regression or have you done it already ??"
	echo "**********************************************************************"
	echo "1. YES"
	echo "2. NO"
	local choice
	read -p "Enter choice [ 1 or 2] " choice
	case $choice in
		1) print_center "Step 1) Resolving Background pixel inconsistencies"
		   python3 Resolve_Background_Inconsistency.py
		   print_center "Step 2) Converting Landcover Images to BU/NBU maps"
	           python3 compressClasses_to_BU_NBU.py
		   print_center "Step 3) Performing Linear Regression on Pixel Values"
                   echo "--- This script takes time execute. Please keep patience. --"
		   python3 Linear_regression_on_pixels.py ;;
		2) echo "\n#### Make sure that you have the Cost/Error Values in Cost_results_from_Regression directory!! ####\n" ;;		
		*) echo "${RED}Error...Wrong Choice!! Wait for 4 seconds and enter the new choice! ${STD}" && sleep 4
	esac
	echo 
	print_center "Step 4) Executing Change Classifier"
	#local threshold
	read -p "Enter the fixed threshold for change classification: " threshold
        python3 Change_classifier.py $threshold	 
	python3 Create_Colored_Change_Maps.py
	pause
}
 
# do something in two()
test_change_classifier_accuracy (){
	echo
        print_center "**** TESTING THE ACCURACY OF THE CHANGE CLASSIFIER ****"
	echo 
	echo
	print_center "Step 1) Converting PNG Images of CBU/CNBU/Changing Maps into TIFF files"
	python3 png_to_tif.py
	print_center "Step 2) Cutting The Tiffiles Using Groundtruth Shapefiles"
	python3 Cut_tifffile_using_groundtruth_shapefiles.py
	print_center "Step 3) Balancing The Groundtruth For Better Accuracy Testing"
	python3 groundtruth_preprocessing.py
	print_center "Step 4) Compute Accuracy"
	#mkdir Results
	python3 Compute_accuracies_change_classifier.py > Results/result_change_classifier_accuracies_$threshold.txt
	echo "#### Check Results/result_change_classifier_accuracies_$threshold.txt file for the accuracy results ####\n"
        pause
}
 
# function to display menus
show_menus() {
	echo 	
	echo "~~~~~~~~~~~~~~~~~~~~~"	
	echo " M A I N - M E N U"
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Run Change Classifier"
	echo "2. Test Accuracy of Change Classifier"
	echo "3. Exit"
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
	local choice
	read -p "Enter choice [ 1 - 3] " choice
	case $choice in
		1) run_change_classifier ;;
		2) test_change_classifier_accuracy ;;
		3) exit 0;;
		*) echo "${RED}Error...Wrong Choice!! Wait for 4 seconds and enter the new choice! ${STD}" && sleep 4
	esac
}
 
 
# -----------------------------------
# Step #4: Main logic - infinite loop
# ------------------------------------
while true
do
 
	show_menus
	read_options
done

