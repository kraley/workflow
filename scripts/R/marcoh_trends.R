# This script analyzes data extracted from IPUMS 
# https://usa.ipums.org/usa/index.shtml
# 
# Part of workflow demonstration
# by Kelly Raley
#***************************************************************************
  
# Before running this file, be sure you are in the scripts directory

# This will run your personal setup file. 
# as well as load the necessary libraries. 
I don't have this worked out yet
source(setup_project.R)

# read in and label raw datafile downloaded from IPUMS
source(usa_00011.R)

# create analysis variables
source(marcoh_wrangle.R)

# output a descriptive table
source(marcoh_describe.R)
