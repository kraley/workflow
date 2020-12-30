# This file sets up the base project environment. 
# It is the same for all project members
# 
# This assumes that you are working from your scripts directory (../github/workflow/scripts/R).
# Change to this directory using the terminal before executing any of the scripts

# We expect to find your setup file, named setup_<username>.do
# in the scripts directory.

# pull in necessary packages
library(tidyverse)
library(xlsx)
library(fixest)

username <- Sys.getenv("USERNAME")
personal_setup <- paste0("setup_", username, ".R")

# scripts
scripts <- getwd()

source(paste0(scripts, "/", personal_setup))

