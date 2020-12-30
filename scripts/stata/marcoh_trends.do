* This script analyzes data extracted from IPUMS 
* https://usa.ipums.org/usa/index.shtml
* 
* Part of workflow demonstration
* by Kelly Raley
****************************************************************************

* Before running this file, be sure you are in the scripts directory

* This will run both the project setup file and your personal setup file. 
* as well as check to make sure that you have all the necessary packages installed
do setup_project.do

* read in and label raw datafile downloaded from IPUMS
do usa_00011.do

* create analysis variables
do marcoh_recode.do

* output a descriptive table
do marcoh_describe.do
