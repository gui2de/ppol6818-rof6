
//Setup for Jacob
if c(username)=="jacob" {
	
	global wd "C:/Users/jacob/OneDrive/Desktop/PPOL_6818"
}

if c(username)=="ronin" { 
	
	global wd "C:/Users/rubyfrazerdalby/Desktop/ppol6818" 
}

//Globals
	global q1_school "$wd/week_03/04_assignment/01_data/q1_data/school.dta"
	global q1_subject "$wd/week_03/04_assignment/01_data/q1_data/subject.dta"
	global q1_student "$wd/week_03/04_assignment/01_data/q1_data/student.dta"
	global q1_teacher "$wd/week_03/04_assignment/01_data/q1_data/teacher.dta"
	
	global q2_village "$wd/week_03/04_assignment/01_data/q2_village_pixel.dta"

	global q3_proposal "$wd/week_03/04_assignment/01_data/q3_proposal_review.dta"
	
	global excel_t21 "$wd/week_03/04_assignment/01_data/q4_Pakistan_district_table21.xlsx"
	
	global q5_tanzania "$wd/week_03/04_assignment/01_data/q5_Tz_student_roster_html.dta"
	

	
// question 1

// merge data sets to have all variables aligned 
use "$q1_student", clear
rename primary_teacher teacher
merge m:1 teacher using "$q1_teacher"
drop _merge
merge m:1 school using "$q1_school"
drop _merge
merge m:1 subject using "$q1_subject"
drop _merge 


// (a)
sum attend if loc == "South"
// mean attendance at southern schools is  177.4776
// 177.4776 


// (b)
sum tested if level == "High"
// proportion of students with teacher who teaches tested subject is .4423495 
// 0.44 

// (c) 
sum gpa
// mean gpa is 3.60144
// 3.60

// (d)
tabstat attendance if level == "Middle", by(school) statistics(mean)
// Joseph Darby Mid 177.4408 days
// Mahatma Ghandi M  177.3344 days
// Malala Yousafzai  177.5478 days 


// question 2 

use "$q2_village", clear 



// (a)
gen pixel_consistent = 0
bysort pixel: egen mean_payout_pixel =  mean(payout)
bysort pixel: replace pixel_consistent = 1 if mean_payout_pixel == 1 | mean_payout_pixel == 0

// (b)
gen pixel_village = 0
encode pixel, gen(pixel_value)
bysort village: egen mean_pixel_value = mean(pixel_value)
replace pixel_village = 1 if pixel_value != mean_pixel_value 

// (c) 
gen payout_status = 0

//(c) (i) 
replace payout_status = 1 if pixel_village == 0

// (c) (ii) 
gen village_consistent = 0
bysort village: egen mean_pay_vill = mean(payout)
bysort village: replace village_consistent = 1 if mean_pay_vill == 1 | mean_pay_vill == 0
replace payout_status = 2 if village_consistent == 1 & pixel_village == 1


//(c)) (iii)
replace payout_status = 3 if pixel_village == 1 & village_consistent == 0


// question 3 
use "$q3_proposal", clear

rename Rewiewer1 Reviewer1
rename Review1Score S1
rename Reviewer2Score S2
rename Reviewer3Score S3
reshape long Reviewer S, i(proposal_id) j(Review_number)

bysort Reviewer: egen mean_rev_score = mean(S)
bysort Reviewer: egen sd_rev = sd(S)
gen s_norm = ((S - mean_rev_score)/sd_rev)
sort proposal_id

reshape wide Reviewer S sd_rev s_norm mean_rev_score, i(proposal_id) j(Review_number)
rename s_norm1 stand_r1_score 
rename s_norm2 stand_r2_score 
rename s_norm3 stand_r3_score 

// normalize 
gen average_stand_score = ((stand_r1_score + stand_r2_score + stand_r3_score)/3)
gsort -average_stand_score


// rank
gen rank = _n




// question 4

clear

*setting up an empty tempfile
tempfile table21
save `table21', replace emptyok

*Run a loop through all the excel sheets (135) this will take 1-5 mins because it has to import all 135 sheets, one by one
forvalues i=1/135 {
	import excel "$excel_t21", sheet("Table `i'") firstrow clear allstring //import
	display as error `i' //display the loop number

	keep if regexm(TABLE21PAKISTANICITIZEN1, "18 AND" )==1 //keep only those rows that have "18 AND"
	*I'm using regex because the following code won't work if there are any trailing/leading blanks
	*keep if TABLE21PAKISTANICITIZEN1== "18 AND" 
	keep in 1 //there are 3 of them, but we want the first one
	rename TABLE21PAKISTANICITIZEN1 table21

		foreach x of varlist * {
		count if `x' == "" 
		if `r(N)' !=0 {
			drop `x'
		}
	}
	
	local col = 1 
	foreach x of varlist * {
		rename `x' column_`col'
		local col = `col' + 1 
	}

	
	
	
	gen table="`i'"
	append using `table21' 
	order table, last
	save `table21', replace //saving the tempfile so that we don't lose any data
}

*load the tempfile
* use `table21', clear
*fix column width issue so that it's easy to eyeball the data


	foreach x of varlist column_* {
		split `x', generate(bin)
		replace `x' = bin1
		replace `x' = "0" if `x'==""
		replace `x' = "0" if strpos(`x',"-") > 0
		foreach x of varlist bin* {
			drop `x'
		}
		
		
	}
	


//order 
replace column_1 = table
drop table
rename column_1 table_number
destring table_number, replace
gsort table_number


// question 5 

use "$q5_tanzania", clear 

split s, parse(:)

rename s2 number_students
split number_students, parse(<)
replace number_students = number_students1
destring number_students, replace

rename s3 school_average
split school_average, parse(<)
replace school_average = school_average1
destring school_average, replace


rename s4 groupsize 
split groupsize 
rename groupsize4 schoolgroupsize
split schoolgroupsize, parse(<)
destring schoolgroupsize1, replace 
drop schoolgroupsize 
rename schoolgroupsize1 schoolgroupsize
drop schoolgroupsize2

rename s5 rankcouncil
split rankcouncil
local rank = rankcouncil1
local outof = rankcouncil4
gen councilrank = "`rank' out of `outof'"
split councilrank, parse(<)
drop councilrank2 councilrank
rename councilrank1 councilrank
split councilrank 
destring councilrank1 councilrank4, replace
local rank = councilrank1
local total = councilrank4
gen rank_council = "`rank' out of `total'"
drop councilrank councilrank1 councilrank2 councilrank3 councilrank4


rename s6 region
split region 
local regionrank = region1 
local regionoutof = region4 
gen regionrank = "`regionrank' out of `regionoutof'"
split regionrank, parse(<)
split regionrank1 
destring regionrank11 regionrank14, replace 
local rank = regionrank11
local total = regionrank14
gen rank_region = "`rank' out of `total'"
drop regionrank14 regionrank13 regionrank12 regionrank11 regionrank2 regionrank1 


rename s7 national 
split national 
local nationalrank = national1
local nationaloutof = national4 
gen nationalrank = "`nationalrank' out of `nationaloutof'"
split nationalrank, parse(<)
split nationalrank1 
destring nationalrank11 nationalrank14, replace
local rank = nationalrank11
local total = nationalrank14
gen rank_national = "`rank' out of `total'"
drop nationalrank14 nationalrank13 nationalrank12 nationalrank11 nationalrank3 nationalrank2 nationalrank1 


rename s t
split t, parse(>)
rename t15 school
split school
rename school1 schoolname
rename school5 schoolcode 
split schoolcode, parse(<)
drop schoolcode schoolcode2 
split schoolcode1, parse(PS)
destring schoolcode12, replace 
tostring schoolcode12, replace
local schoolnumber = schoolcode12
replace schoolcode12 = "PS`schoolnumber'"
rename schoolcode12 schoolcode 

 
keep number_students schoolgroupsize rank_council rank_region rank_national schoolname schoolcode




