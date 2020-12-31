# This script analyzes data extracted from IPUMS 
# https://usa.ipums.org/usa/index.shtml
# 
# Part of workflow demonstration
# by Kelly Raley
#***************************************************************************
  
# We assume that you are working from your scripts directory 
# (../github/workflow/scripts/R). Change to this directory using 
# the terminal (or cntl-Shift-H) before executing any of the scripts.

# This will run your personal setup file. 
# as well as load the necessary libraries. 

# scripts
scripts <- getwd()
source(paste0(scripts, "/setup_project.R"))

# read in and label raw datafile downloaded from IPUMS
source(paste0(scripts, "/usa_00011.R"))

# create analysis variables
source(paste0(scripts, "/marcoh_wrangle.R"))

# output a descriptive table
source(paste0(scripts, "/marcoh_describe.R"))
