* This file sets up the base project environment. 
* It is the same for all project members
* 
* parts of this code are taken from scripts written by Joanna Pepin and Robert Reynolds

* The current directory is assumed to be base directory of your scripts.

* We expect to find your setup file, named setup_<username>.do
* in the current directory.

* Find home directory, depending on OS.
if ("`c(os)'" == "Windows") {
    local temp_drive : env HOMEDRIVE
    local temp_dir : env HOMEPATH
    global homedir "`temp_drive'`temp_dir'"
    macro drop _temp_drive _temp_dir`
}
else {
    if ("`c(os)'" == "MacOSX") | ("`c(os)'" == "Unix") {
        global homedir : env HOME
    }
    else {
        display "Unknown operating system:  `c(os)'"
        exit
    }
}

// Checks that the setup file exists and runs it.
capture confirm file "setup_`c(username)'.do"
if _rc==0 {
    do setup_`c(username)'
      }
  else {
    display as error "The file setup_`c(username)'.do does not exist"
	exit
  }

// Checks to make sure that a log directory is set. 
if ("$logdir" == "") {
    display as error "logdir macro not set."
    exit
}

********************************************************************************
* Check for package dependencies 
********************************************************************************
* This checks for packages that the user should install prior to running the project do files.

// project
capture : which project
if (_rc) {
    display as error in smcl `"Please install package {it:project} from SSC in order to run these do-files;"' _newline ///
        `"you can do so by clicking this link: {stata "ssc install project":auto-install project}"'
    exit 199
}

// fre: https://ideas.repec.org/c/boc/bocode/s456835.html
capture : which fre
if (_rc) {
    display as error in smcl `"Please install package {it:fre} from SSC in order to run these do-files;"' _newline ///
        `"you can do so by clicking this link: {stata "ssc install fre":auto-install fre}"'
    exit 199
}

********************************************************************************
* Create macro for current date
local logdate = string( d(`c(current_date)'), "%dCY.N.D" ) 		// create a macro for the date

