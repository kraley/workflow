****************************************************************************
* This file creates a variable describing marital-cohabitation status 
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

save "$interim/marcoh_recode.dta", replace

log close
