#***************************************************************************
# This file describes trends in marital cohabitation status of black men and 
# women age 20-24 from 2001-2018
# 
# Part of workflow demonstration
# by Kelly Raley
#***************************************************************************
#  log using "$logdir/marcoh_describe_`logdate'.log", t replace

interim_recoded <- paste0(interim,"recoded")
readRDS(usadata, file=paste0(interim_recoded))

usadata <- usadata %>%
           filter(marcoh != "sep/wid/div") #drop the formerly married

marcoh_year <- 
            usadata %>% 
            group_by(sex) %>% #seperate analyses for men and women
  
            # calc denominator: weighted n obs in each year 
            add_count(yr, wt=perwt, name="wnyr") %>%
  
            # calc numerator: weighted n of obs in each year by marital-cohab status
            group_by(sex, yr) %>% 
            add_count(marcoh, wt=perwt, name="wnmarcoh") %>%
  
            # calc percent 
            mutate(wpmarcoh = round(wnmarcoh/wnyr,2), 
                   mcy = paste0(marcoh,yr)) %>% 

            # select one observation per marcoh X year combo
            group_by(sex, mcy) %>% 
            filter(row_number()==1) %>%
            ungroup() %>%
  
            # select the variables we want
            select(marcoh, year, wpmarcoh, sex) %>%
              
            # arrange
            arrange(sex, year, marcoh)

men_marcoh_year <- marcoh_year %>%
            filter(sex == 1) %>%
            select(marcoh, year, wpmarcoh) %>%

            #put marital-cohab status in columns
            spread(marcoh, wpmarcoh, fill = NA, convert = FALSE) %>%
      
            #put columns in the order I want them
            select(year, single, married, cohabiting)

women_marcoh_year <- marcoh_year %>%
            filter(sex == 2) %>%
            select(marcoh, year, wpmarcoh) %>%
  
            #put marital-cohab status in columns
            spread(marcoh, wpmarcoh, fill = NA, convert = FALSE) %>%
  
            #put columns in the order I want them
            select(year, single, married, cohabiting)

######################################################
# write results to excel spreadsheetp
#####################################################

results_file  <- paste0(results,"Table1.xlsx")

wb <- createWorkbook()
addWorksheet(wb, "Table 1")

writeDataTable(
  wb,
  "Table 1",
  men_marcoh_year,
  startCol = 1,
  startRow = 3,
  xy = NULL,
  colNames = TRUE,
  rowNames = FALSE,
  tableStyle = "TableStyleLight9",
  tableName = NULL,
  headerStyle = NULL,
  withFilter = TRUE,
  keepNA = FALSE,
  na.string = NULL,
  sep = "",
  stack = FALSE,
  firstColumn = FALSE,
  lastColumn = FALSE,
  bandedRows = TRUE,
  bandedCols = FALSE
)

saveWorkbook(wb, paste0(results_file), overwrite = TRUE)

# stata code
# putexcel set "$results/Table1.xlsx", replace
#
#*********************************************************************************
#  * Create Table Shell
#********************************************************************************
#  
#  * Headers (column then row)
#putexcel A1:H1 = "Trends in Marital-Cohabitation Status for Black Men and Women age 20-24", merge border(bottom) 
#putexcel B2:D2 = "Men", merge border(bottom) 
#putexcel F2:H2 = "Women", merge border(bottom) 
#putexcel A3 = "Year", border(bottom) 
#* this is doing it the hard way, but it demonstrates an approach that is generalizeable
#// start by creating a local macro with the column letters and headings"
#local columns B C D F G H
#local heads Single Married Cohabiting
#local years 2001 2002 2007 2008 2017 2018

#// first for men and then women
#forvalues sex=0/1 {
#    local s = 3*`sex'
#	forvalues m=1/3 {
#		local c = `m' + `s'
#        local col : word `c' of `columns'
#		display "col is `col'"
#		local heading : word `m' of `heads'
#		macro list
#		putexcel `col'3 = "`heading'", border(bottom) 
#}
#}

#local startyear  = 2001
#local year = `startyear'

#forvalues r=4/9 {
#    local y = `r' - 3
#local year : word `y' of `years' 
#	display "year is `year'"
#	putexcel A`r' = `year'
#}

#* Content

#* calculate row totals
#forvalues r=4/9 {
#  local y=`r'-3
#  putexcel B`r' = matrix(menprop`y'), nformat(number_d2)
#  putexcel F`r' = matrix(womenprop`y'), nformat(number_d2)
#}
#
#log close
