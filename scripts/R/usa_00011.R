# This file reads in the original data extracted from IPUMS 
# and formats and labels the variables. The only data transformations
# involve moving a decimal place. 

# log using "$logdir/usa_00011_logdate.log", t replace # Don't know how to log yet

# we defined object "original" in the setup file
# now we are creating an object that combines the file location and 
# file name (same for everyone on the project and so you should not change)
# to be able to easily read in the data.
original_usadata <- paste0(original,"usa_00011.dat")

usadata <- read.fwf(paste(original_usadata),
                    c(4,6,8,13,10,13,12,1,4,10,2,1,1,3,1,1,3),
                    col.names=c("year","sample","serial","cbserial","hhwt","cluster","strata","gq","pernum","perwt","sploc","nchild","sex","age","marst","race","raced"),
                    strip.white=TRUE)

usadata <- mutate(usadata, hhwt = hhwt/100, perwt = perwt/100)

#format serial   %8.0f
#format cbserial %13.0f
#format hhwt     %10.2f
#format cluster  %13.0f
#format strata   %12.0f
#format perwt    %10.2f

usadata = apply_labels(usadata, 
                       year = "Census year",
                       sample = "IPUMS sample identifier",
                       serial = "Household serial number",
                       cbserial = "Original Census Bureau household serial number",
                       hhwt  =   "Household weight",
                       cluster = "Household cluster for variance estimation",
                       strata  = "Household strata for variance estimation",
                       gq    =  "Group quarters status",
                       pernum = "Person number in sample unit",
                       perwt =  "Person weight",
                       sploc  = "Spouses location in household",
                       nchild = "Number of own children in the household",
                       sex   = "Sex",
                       age   = "Age",
                       marst = "Marital status",
                       race  = "Race [general version]",
                       raced = "Race [detailed version]"
)

val_lab(usadata$sample) = c("2018 ACS"	=	201801,
                            "2017 ACS"	=	201701,
                            "2008 ACS"	=	200801,
                            "2007 ACS"	=	200701,
                            "2002 ACS"	=	200201,
                            "2001 ACS"	=	200101
)

val_lab(usadata$gq) = c("Vacant unit" = 0,
                        "Households under 1970 definition" = 1,
                        "Additional households under 1990 definition" = 2,
                        "Group quarters--Institutions" = 3,
                        "Other group quarters" = 4,
                        "Additional households under 2000 definition" =5, 
                        "Fragment" = 6
)

val_lab(usadata$nchild) = c("0 children present" = 0,
                            "1 child present" = 1,
                            "2" = 2,
                            "3" = 3,
                            "4" = 4,
                            "5" = 5,
                            "6" = 6,
                            "7" = 7,
                            "8" = 8,
                            "9+" = 9
)

val_lab(usadata$nchild) = c("Male" = 1,
                            "Female" = 2
)

val_lab(usadata$marst) = c("Married, spouse present" = 1,
                          "Married, spouse absent" = 2,
                          "Separated" = 3,
                          "Divorced" = 4,
                          "Widowed" = 5,
                          "Never married/single" = 6
)

val_lab(usadata$race) = c("White" = 1,
  "Black/African American/Negro" = 2,
  "American Indian or Alaska Native" = 3,
  "Chinese" = 4,
  "Japanese" = 5,
  "Other Asian or Pacific Islander" = 6,
  "Other race, nec" = 7,
  "Two major races" = 8,
  "Three or more major races" = 9
  )

# we created an object with the interim directory in the setup file.
# and now use this to save an interim data file to that directory.

# Why save an interim data file? Sometimes you will be working with large files
# and wont want to have to recreate all of your data files every time you 
# pick up the project. By commenting out lines in your master script, you can
# skip steps that you completed in earlier sessions. (Provided that neither you 
# nor your collaborators have made any changes to the earlier steps). 
# Note that before you finish your project, you'll want to make sure to 
# run the whole master script from start to finish. 

interim_usadata <- paste0(interim,"usadata")

saveRDS(usadata, file=paste0(interim_usadata))

# this is the end of the file
