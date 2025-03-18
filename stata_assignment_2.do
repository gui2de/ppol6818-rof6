
//Setup for Jacob
if c(username)=="jacob" {
	
	global wd "C:/Users/jacob/OneDrive/Desktop/PPOL_6818"
}

if c(username)=="rubyfrazerdalby" { 
	
	global wd "/Users/rubyfrazerdalby/Desktop/ppol6818" 
}

//Globals
	
	global q1_tanzania "$wd/week_05/03_assignment/01_data/q1_psle_student_raw.dta"
	global q2_civ "$wd/week_05/03_assignment/01_data/q2_CIV_Section_0.dta"
	global q2_civ_excel "$wd/week_05/03_assignment/01_data/q2_CIV_populationdensity.xlsx" 
	global q3_enum "$wd/week_05/03_assignment/01_data/q3_GPS Data.dta"
	global q4_tanzania "$wd/week_05/03_assignment/01_data/q4_Tz_election_2010_raw.xls"
	global q5_data_one "$wd/week_05/03_assignment/01_data/q5_school_location.dta"
	global q5_data_two "$wd/week_05/03_assignment/01_data/q5_psle_2020_data.dta"



//Q1 apologies because this code takes a while to run but spoke with Ali and he said it was ok to submit and acceptable for question 1 

use "$q1_tanzania", clear


split s, parse(SUBJECTS)
rename s2 student_info  
split s1, parse(:)
keep s12 s schoolcode student_info 
split s12, parse(<) 
destring s121, replace 
drop s12 s122 
rename s121 stdnumb
order student_info, a(stdnumb)

split student_info, parse(PS01)
drop student_info student_info1 
reshape long student_info, i(schoolcode) j(studentnumber)

drop if student_info == "" 

split student_info, parse(<) 
rename student_info1 pscode
split pscode, parse(<) 
drop pscode
rename pscode1 pscode
order pscode, a(stdnumb)

split student_info6, parse(<)
rename student_info6 prem
split prem, parse(>)
drop prem
rename prem2 prem
order prem, a(pscode)


drop student_info2 student_info3 student_info4 student_info5 student_info6 student_info7 student_info8 student_info9 student_info10 

split student_info11, parse(>)
drop student_info11
rename student_info112 sex 
order sex, a(prem)

drop student_info12 student_info13 student_info14 student_info15

split student_info16, parse(>) 
drop student_info16
rename student_info162 name
order name, a(sex)

drop student_info17 student_info18 student_info19 student_info20 

rename student_info21 subjects
split subjects, parse(>)
drop subjects
rename subjects2 subjects 
drop subjects1 
split subjects, parse(,)
drop subjects student_info26 student_info161 student_info student_info22 student_info23 student_info24 student_info25 student_info27 student_info28 prem1 student_info111


split subjects1, parse(-)
rename subjects12 Kiswahili
drop subjects1 subjects11


split subjects2, parse(-)
rename subjects22 English
drop subjects2 subjects21

split subjects3, parse(-)
rename subjects32 Maarifa
drop subjects3 subjects31

split subjects4, parse(-)
rename subjects42 Hisabati
drop subjects4 subjects41

split subjects5, parse(-)
rename subjects52 Science
drop subjects5 subjects51

split subjects6, parse(-)
rename subjects62 Uraia
drop subjects6 subjects61

split subjects7, parse(-)
rename subjects72  Average_Grade
drop subjects7 subjects71

split schoolcode, parse(_)
split schoolcode2, parse(.)
drop schoolcode schoolcode2 schoolcode22 schoolcode1
rename schoolcode21 school
order school, a(s)

split pscode, parse(-)
rename pscode2 cand_number 
order cand_number, a(school)
drop pscode1 s pscode studentnumber


//Q2



tempfile temp
save `temp', replace emptyok

import excel using "$q2_civ_excel", clear
rename D density 
drop B C 	
rename A department 
drop if department == "NOM CIRCONSCRIPTION"
keep if regexm(department, "DEPARTEMENT") == 1 

split department, parse("DEPARTEMENT D")
drop department department1 
rename department2 department
split department, parse(" ")
drop department
rename department2 department 
rename department1 now
split now, parse( ' )
replace department = now2 if department == ""
drop now now1 now2
replace department = strlower(department)
replace department = "arrha" if department == "arrah"

save `temp', replace


use "$q2_civ", clear

decode b06_departemen, gen(department)

merge m:1 department using `temp'
drop _merge 
drop department



//Q3


clear
tempfile enums
gen id =.
save `enums'


use "$q3_enum", clear
	gen enum = .
	sort longitude
	
local groups = ceil(_N/6)
forvalues i=1/`groups'{	
merge 1:1 id using `enums'
drop _merge
drop if enum !=.
sort longitude 
gen baselat = latitude[1]
gen baselong = longitude[1]
geodist baselat baselong latitude longitude, gen(distance)
sort distance
gen dist_rank = _n
replace enum = `i' if dist_rank <=6	
drop dist_rank baselat baselong distance
keep if enum!=.
append using `enums'
save `enums', replace
use "$q3_enum", clear
}

merge 1:1 id using `enums'
sort enum
drop _merge


// Q4 
import excel using "$q4_tanzania", clear


rename A REGION
rename B district
rename C costituency
rename D Ward 
rename E CandidateName
rename F Sex
rename H party
rename I votes
rename J Elected
drop K G
drop if CandidateName ==""
drop if CandidateName == "CANDIDATE NAME"
replace Sex = "F" if Sex ==""
replace Elected = "NOT ELECTED" if Elected ==""


replace REGION = REGION[_n-1] if REGION == ""
replace district = district[_n-1] if district == ""
replace costituency = costituency[_n-1] if costituency == ""
replace Ward = Ward[_n-1] if Ward == ""

egen ward_id = group(REGION district Ward)
bysort ward_id: gen candidate_num = _n
bysort ward_id: egen total_candidates = max(candidate_num)
fillin party ward_id
gsort ward_id -REGION

replace REGION = REGION[_n-1] if REGION == ""
replace district = district[_n-1] if district == ""
replace costituency = costituency[_n-1] if costituency == ""
replace Ward = Ward[_n-1] if Ward == ""

replace votes = "0" if votes == "UN OPPOSSED"
destring votes, gen(Votes)
drop votes
rename Votes votes  

bysort ward_id: gen rank = _n
drop _fillin CandidateName Sex Elected candidate_num
sort ward_i party

reshape wide party total_candidates votes, i(ward_id) j(rank)
egen totalvotes = rowtotal(votes*)


gen AFPvotes =.
gen APPT_MAENDELEOvotes =.
gen CCMvotes =.
gen CHADEMAvotes =.
gen CHAUSTAvotes =.
gen CUFvotes =.
gen DPvotes =.
gen JAHAZIASILIAvotes =.
gen MAKINvotes =.
gen NCCRMAGEUZIvotes =.
gen NLDvotes =.
gen NRAvotes =.
gen SAUvotes =.
gen TADEAvotes =.
gen TLPvotes =.
gen UDPvotes =.
gen UMDvotes =.
gen UPDPvotes =.

forvalues i=1/18 {
	replace AFPvotes = votes`i' if party`i' == "AFP"
	replace APPT_MAENDELEOvotes = votes`i' if party`i' == "APPT - MAENDELEO"
	replace CCMvotes = votes`i' if party`i' == "CCM"
	replace CHADEMAvotes = votes`i' if party`i' == "CHADEMA"
	replace CHAUSTAvotes = votes`i' if party`i' == "CHAUSTA"
	replace CUFvotes = votes`i' if party`i' == "CUF"
	replace DPvotes = votes`i' if party`i' == "DP"
	replace JAHAZIASILIAvotes = votes`i' if party`i' == "JAHAZI ASILIA"
	replace MAKINvotes = votes`i' if party`i' == "MAKIN"
	replace NCCRMAGEUZIvotes = votes`i' if party`i' == "NCCR-MAGEUZI"
	replace NLDvotes = votes`i' if party`i' == "NLD"
	replace NRAvotes = votes`i' if party`i' == "NRA"
	replace SAUvotes = votes`i' if party`i' == "SAU"
	replace TADEAvotes = votes`i' if party`i' == "TADEA"
	replace TLPvotes = votes`i' if party`i' == "TLP"
	replace UDPvotes = votes`i' if party`i' ==  "UDP"
	replace UMDvotes = votes`i' if party`i' == "UMD"
	replace UPDPvotes = votes`i' if party`i' == "UPDP"	
}

drop total_candidates* 
drop party* votes* 
order REGION district costituency Ward 



// Q5 

tempfile data
use "$q5_data_one", clear 
rename NECTACentreNo school
drop if school == "n/a" 
duplicates drop school, force
save `data'
 
use "$q5_data_two", clear 
split school_code_address, parse(_)
split school_code_address2, parse(.) 
replace school_code_address21 = strupper(school_code_address21)
rename school_code_address21 school 
drop school_code_address22 school_code_address2 school_code_address1
merge 1:1 school using `data'
drop if _merge==2









