#***************************************************************************
# This file transforms (or "wrangles") the original variables into variables 
# we want for our analysis. In this case, the script creates a variable 
# describing marital-cohabitation status. 
# 
# Part of workflow demonstration
# by Kelly Raley
#***************************************************************************
  
#  log using "$logdir/marcoh_recode_`logdate'.log", t replace

interim_usadata <- paste0(interim,"usadata") 
readRDS(usadata, file=paste0(interim_usadata))

usadata <- mutate(usadata, marcoh= ifelse(marst==6 & sploc==0, 0,
                  ifelse(marst==1 | marst==2, 1,
                  ifelse(marst==6 & sploc > 0, 2, 3))))

val_lab(usadata$marcoh) = c("no union" = 0,
                            "married" = 1, 
                            "cohabiting" = 2,
                            "sep/wid/div" = 3
)

interim_recoded <- paste0(interim,"recoded")
saveRDS(usadata, file=paste0(interim_recoded))

#log close
