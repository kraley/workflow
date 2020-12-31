* This file reads in the original data extracted from IPUMS 
* 
* It has been modified from the file distributed with the data
* to add this documentation, specify the directory location
* of the original data, and to create a log file 

log using "$logdir/usa_00011_`logdate'.log", t replace

set more off

clear
quietly infix              ///
  int     year      1-4    ///
  long    sample    5-10   ///
  double  serial    11-18  ///
  double  cbserial  19-31  ///
  double  hhwt      32-41  ///
  double  cluster   42-54  ///
  double  strata    55-66  ///
  byte    gq        67-67  ///
  int     pernum    68-71  ///
  double  perwt     72-81  ///
  byte    sploc     82-83  ///
  byte    nchild    84-84  ///
  byte    sex       85-85  ///
  int     age       86-88  ///
  byte    marst     89-89  ///
  byte    race      90-90  ///
  int     raced     91-93  ///
  using "$original/usa_00011.dat"
  
* Note that we defined a global macro $original in the setup file 
* and we use it in the last line of the infix command to tell stata where to find the data

replace hhwt     = hhwt     / 100
replace perwt    = perwt    / 100

format serial   %8.0f
format cbserial %13.0f
format hhwt     %10.2f
format cluster  %13.0f
format strata   %12.0f
format perwt    %10.2f

label var year     `"Census year"'
label var sample   `"IPUMS sample identifier"'
label var serial   `"Household serial number"'
label var cbserial `"Original Census Bureau household serial number"'
label var hhwt     `"Household weight"'
label var cluster  `"Household cluster for variance estimation"'
label var strata   `"Household strata for variance estimation"'
label var gq       `"Group quarters status"'
label var pernum   `"Person number in sample unit"'
label var perwt    `"Person weight"'
label var sploc    `"Spouse's location in household"'
label var nchild   `"Number of own children in the household"'
label var sex      `"Sex"'
label var age      `"Age"'
label var marst    `"Marital status"'
label var race     `"Race [general version]"'
label var raced    `"Race [detailed version]"'

label define year_lbl 2001 `"2001"'
label define year_lbl 2002 `"2002"', add
label define year_lbl 2007 `"2007"', add
label define year_lbl 2008 `"2008"', add
label define year_lbl 2017 `"2017"', add
label define year_lbl 2018 `"2018"', add
label values year year_lbl

label define sample_lbl 201801 `"2018 ACS"'
label define sample_lbl 201701 `"2017 ACS"', add
label define sample_lbl 200801 `"2008 ACS"', add
label define sample_lbl 200701 `"2007 ACS"', add
label define sample_lbl 200201 `"2002 ACS"', add
label define sample_lbl 200101 `"2001 ACS"', add
label values sample sample_lbl

label define gq_lbl 0 `"Vacant unit"'
label define gq_lbl 1 `"Households under 1970 definition"', add
label define gq_lbl 2 `"Additional households under 1990 definition"', add
label define gq_lbl 3 `"Group quarters--Institutions"', add
label define gq_lbl 4 `"Other group quarters"', add
label define gq_lbl 5 `"Additional households under 2000 definition"', add
label define gq_lbl 6 `"Fragment"', add
label values gq gq_lbl

label define nchild_lbl 0 `"0 children present"'
label define nchild_lbl 1 `"1 child present"', add
label define nchild_lbl 2 `"2"', add
label define nchild_lbl 3 `"3"', add
label define nchild_lbl 4 `"4"', add
label define nchild_lbl 5 `"5"', add
label define nchild_lbl 6 `"6"', add
label define nchild_lbl 7 `"7"', add
label define nchild_lbl 8 `"8"', add
label define nchild_lbl 9 `"9+"', add
label values nchild nchild_lbl

label define sex_lbl 1 `"Male"'
label define sex_lbl 2 `"Female"', add
label values sex sex_lbl

label define marst_lbl 1 `"Married, spouse present"'
label define marst_lbl 2 `"Married, spouse absent"', add
label define marst_lbl 3 `"Separated"', add
label define marst_lbl 4 `"Divorced"', add
label define marst_lbl 5 `"Widowed"', add
label define marst_lbl 6 `"Never married/single"', add
label values marst marst_lbl

label define race_lbl 1 `"White"'
label define race_lbl 2 `"Black/African American/Negro"', add
label define race_lbl 3 `"American Indian or Alaska Native"', add
label define race_lbl 4 `"Chinese"', add
label define race_lbl 5 `"Japanese"', add
label define race_lbl 6 `"Other Asian or Pacific Islander"', add
label define race_lbl 7 `"Other race, nec"', add
label define race_lbl 8 `"Two major races"', add
label define race_lbl 9 `"Three or more major races"', add
label values race race_lbl

label define raced_lbl 100 `"White"'
label define raced_lbl 200 `"Black/African American/Negro"', add
label values raced raced_lbl

* we created a global macro with the interim directory in the setup file.
* and now use this to save an interim data file to that directory.

* Why save an interim data file? Sometimes you will be working with large files
* and wont want to have to recreate all of your data files every time you 
* pick up the project. By commenting out lines in your master script, you can
* skip steps that you completed in earlier sessions. (Provided that neither you 
* nor your collaborators have made any changes to the earlier steps). 
* Note that before you finish your project, you'll want to make sure to 
* run the whole master script from start to finish. 

save "$interim/marcoh", replace

log close
