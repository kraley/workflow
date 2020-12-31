#***************************************************************************
# This file describes trends in marital cohabitation status of black men and 
# women age 20-24 from 2001-2018
# 
# Part of workflow demonstration
# by Kelly Raley
#
# Still some details to work out
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
            select(year, single, married, cohabiting) %>%
            as.data.frame()

women_marcoh_year <- marcoh_year %>%
            filter(sex == 2) %>%
            select(marcoh, year, wpmarcoh) %>%
  
            #put marital-cohab status in columns
            spread(marcoh, wpmarcoh, fill = NA, convert = FALSE) %>%
  
            #put columns in the order I want them. don't need year b/c it
            # is in the men's table, which we will put in the excel file
            # to the left (first)
            select(single, married, cohabiting) %>%
            as.data.frame()

######################################################
# write results to excel spreadsheetp
#####################################################

results_file  <- paste0(results,"Table1R.xlsx")

#write.xlsx(men_marcoh_year, file = paste0(results_file), sheetName = "Table 1R",
#           col.names = TRUE, row.names = FALSE, append = FALSE)

#write.xlsx(women_marcoh_year, file = paste0(results_file), sheetName = "Table 1R",
#           col.names = TRUE, row.names = FALSE, append = TRUE)

wb <- createWorkbook(type="xlsx")
sheet <- createSheet(wb, sheetName = "Table 1R")

title_style <- CellStyle(wb) + Border(color="black", position="BOTTOM", pen = "BORDER_THIN")

column_name_style <- CellStyle(wb)+ Border(color="black", position="BOTTOM", pen = "BORDER_THIN")

xlsx.addTitle <- function(sheet, rowIndex, title, titleStyle){
  rows <- createRow(sheet,rowIndex=rowIndex)
  sheetTitle <-  createCell(rows,colIndex=1)
  setCellValue(sheetTitle[[1,1]], title)
  setCellStyle(sheetTitle[[1,1]], titleStyle)
}

xlsx.addTitle(sheet, rowIndex=1, title="Trends in Marital-Cohabitation Status for Black Men and Women age 20-24",
              titleStyle = title_style)

# add subtitles

xlsx.addsubtitle  <- function(sheet, rowIndex, colIndex, title, titleStyle){
  rows <- createRow(sheet,rowIndex = rowIndex)
  subTitle <-  createCell(rows,colIndex=colIndex)
  setCellValue(subTitle[[1,1]], title)
  setCellStyle(subTitle[[1,1]], titleStyle)
}

# for men -- not sure why it isn't working
xlsx.addsubtitle(sheet, rowIndex=2, colIndex=2, title="Men", titleStyle = title_style)

# for men
xlsx.addsubtitle(sheet, rowIndex=2, colIndex=6, title="Women", titleStyle = title_style)

addDataFrame(men_marcoh_year, sheet, startRow=3, startColumn = 1,
             colnamesStyle = column_name_style,
             row.names = FALSE)

addDataFrame(women_marcoh_year, sheet, startRow=3, startColumn = 6,
             colnamesStyle = column_name_style,
             row.names = FALSE)

setColumnWidth(sheet, colIndex=5, colWidth=3)

saveWorkbook(wb, paste0(results_file))

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
