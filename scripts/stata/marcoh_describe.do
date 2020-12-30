****************************************************************************
* This file describes trends in marital cohabitation status of black men and 
* women age 20-24 from 2001-2018
* 
* Part of workflow demonstration
* by Kelly Raley
****************************************************************************
log using "$logdir/marcoh_describe_`logdate'.log", t replace

use "$interim/marcoh_recode.dta", clear

svyset cluster [pweight=perwt], strata(strata)

gen yr=1 if year==2001
replace yr=2 if year==2002
replace yr=3 if year==2007
replace yr=4 if year==2008
replace yr=5 if year==2017
replace yr=6 if year==2018

forvalues y=1/6 {
	svy, subpop(if sex==1): tab year marcoh if yr == `y'
	* storing the proportions in a matrix, one for each year
	* Note that stored results from the svy:tab command are described here:
	* https://www.stata.com/manuals13/svysvytabulatetwoway.pdf
	matrix menprop`y' = e(Prop)

	svy, subpop(if sex==2): tab year marcoh if yr == `y'
	matrix womenprop`y' = e(Prop)
}

putexcel set "$results/Table1.xlsx", replace

*********************************************************************************
* Create Table Shell
********************************************************************************

* Headers (column then row)
putexcel A1:H1 = "Trends in Marital-Cohabitation Status for Black Men and Women age 20-24", merge border(bottom) 
putexcel B2:D2 = "Men", merge border(bottom) 
putexcel F2:H2 = "Women", merge border(bottom) 
putexcel A3 = "Year", border(bottom) 
* this is doing it the hard way, but it demonstrates an approach that is generalizeable
// start by creating a local macro with the column letters and headings"
local columns B C D F G H
local heads Single Married Cohabiting
local years 2001 2002 2007 2008 2017 2018

// first for men and then women
forvalues sex=0/1 {
    local s = 3*`sex'
	forvalues m=1/3 {
		local c = `m' + `s'
        local col : word `c' of `columns'
		display "col is `col'"
		local heading : word `m' of `heads'
		macro list
		putexcel `col'3 = "`heading'", border(bottom) 
	}
}

local startyear  = 2001
local year = `startyear'

forvalues r=4/9 {
    local y = `r' - 3
    local year : word `y' of `years' 
	display "year is `year'"
	putexcel A`r' = `year'
}

* Content

* calculate row totals
forvalues r=4/9 {
  local y=`r'-3
  putexcel B`r' = matrix(menprop`y'), nformat(number_d2)
  putexcel F`r' = matrix(womenprop`y'), nformat(number_d2)
}

log close
