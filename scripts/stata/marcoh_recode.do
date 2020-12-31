****************************************************************************
* This file creates the variables we need for the analysis
* 
* Part of workflow demonstration
* by Kelly Raley
****************************************************************************

log using "$logdir/marcoh_recode_`logdate'.log", t replace

use "$interim/marcoh.dta", clear

gen marcoh=0 if marst==6 & sploc==0
replace marcoh=1 if inlist(marst,1,2)
replace marcoh=2 if marst==6 & sploc > 0

#delimit ;

label define marcoh 0 "not married or cohabiting"
                    1 "married"
					2 "cohabiting";
# delimit cr

label var marcoh marcoh

gen yr=1 if year==2001
replace yr=2 if year==2002
replace yr=3 if year==2007
replace yr=4 if year==2008
replace yr=5 if year==2017
replace yr=6 if year==2018

save "$interim/marcoh_recode.dta", replace

log close
