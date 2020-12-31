# This file sets up the base project environment. 
# It is the same for all project members
# 
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# This assumes that you are working from your scripts directory 
# (../github/workflow/scripts/R). Change to this directory using 
# the terminal (or cntl-Shift-H) before executing any of the scripts.
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# We expect to find your setup file, named setup_<username>.do
# in the scripts/R directory.

# pull in necessary packages
library(tidyverse) # for data wrangling and analysis
library(expss)     # for labeling
library(xlsx)  # to write excel file, note that you need to have the right java 
               # installed. I needed to install a 64-bit version to match my R session
#library(openxlsx)  # to write excel file

username <- Sys.getenv("USERNAME")
personal_setup <- paste0("setup_", username, ".R")

# scripts
scripts <- getwd()

source(paste0(scripts, "/", personal_setup))

