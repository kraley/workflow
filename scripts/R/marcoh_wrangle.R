#***************************************************************************
# This file transforms (or "wrangles") the original variables into variables 
# we want for our analysis. In this case, the script creates a variable 
# describing marital-cohabitation status. 
# 
# Part of workflow demonstration
# by Kelly Raley
#***************************************************************************
  
#  log using paste0(logdir,"marcoh_wrangle.log")

# read in the data produced in earlier step
interim_usadata <- paste0(interim,"usadata") 
readRDS(usadata, file=paste0(interim_usadata))

usadata <- mutate(usadata, marcoh= ifelse(marst==6 & sploc==0, "single",
                  ifelse(marst==1 | marst==2, "married",
                  ifelse(marst==6 & sploc > 0, "cohabiting", "sep/wid/div"))))

usadata <- mutate(usadata, yr= ifelse(year==2002, 2,
                                ifelse(year==2007, 3,
                                ifelse(year==2008, 4,
                                ifelse(year==2017, 5,
                                ifelse(year==2018, 6, 1)))))
)

val_lab(usadata$yr) = c("2001" = 1,
                        "2002" = 2, 
                        "2007" = 3,
                        "2008" = 4,
                        "2017" = 5,
                        "2018" = 6
)

# save the result

interim_recoded <- paste0(interim,"recoded")
saveRDS(usadata, file=paste0(interim_recoded))

#log close
