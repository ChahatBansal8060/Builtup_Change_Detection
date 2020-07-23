#!/bin/bash

## ----------------------------------
# Step #1: Define variables
# ----------------------------------
EDITOR=vim
PASSWD=/etc/passwd
RED='\033[0;41;30m'
STD='\033[0;0;39m'
columns="$(tput cols)"
 
# ----------------------------------
# Step #2: User defined function
# ----------------------------------
pause(){
  read -p "Press [Enter] key to continue..." fackEnterKey
}

print_center(){
	printf "%*s\n" $(( (${#1} + $columns) / 2)) "$1"
}
 
# function to test accuracy of BU/NBU sentinel maps
test_bu_nbu_accuracy (){
	echo
        print_center "**** TESTING THE BU/NBU ACCURACY OF SENTINEL MAPS ****"
	echo 
	echo
	print_center "Step 1) Create BU/NBU Maps"
	python3 compressClasses_to_BU_NBU.py
	print_center "Step 1) Converting PNG Images of BU/NBU Maps into TIFF files"
	python3 png_to_tif.py
	print_center "Step 2) Cutting The Tiffiles Using Groundtruth Shapefiles"
	python3 Cut_tifffile_using_groundtruth_shapefiles.py
	print_center "Step 3) Balancing The Groundtruth For Better Accuracy Testing"
	python3 groundtruth_preprocessing.py
	print_center "Step 4) Compute Accuracy"
	python3 Compute_bu_nbu_accuracies.py > result_accuracies.txt
	echo "#### Check result_accuracies.txt file for the accuracy results ####\n"
        pause
}
 
# function to display menus
show_menus() {
	echo 	
	echo "~~~~~~~~~~~~~~~~~~~~~"	
	echo " M A I N - M E N U"
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Test BU/NBU Accuracy of Landcover Images"
	echo "2. Exit"
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
	local choice
	read -p "Enter choice [ 1 - 2] " choice
	case $choice in
		1) test_bu_nbu_accuracy ;;
		2) exit 0;;
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

