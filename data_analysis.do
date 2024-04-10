global PROJECT_ROOT "/Users/hanhan/Desktop/Shihan_Chen"


******* save student surveys as dta
import delimited "$PROJECT_ROOT/data/raw_data/student_follow_ups.csv", clear

// change -99 and NA values
//for children and pregnant, amny people answered NA, so I change it to 0

replace children = "0" if children =="NA"
replace pregnant = "0" if pregnant =="NA"
foreach var in die married children pregnant dropout {
	replace `var' = "" if `var' == "-99" |`var' == "NA"
	destring `var', replace
}


save "$PROJECT_ROOT/data/working_data/student_follow_ups.dta", replace

******* save school baseline as dta
import delimited "$PROJECT_ROOT/data/raw_data/schools.csv", clear 
// set -99 to missing
foreach var in av_teacher_age av_student_score n_latrines {
	replace `var' = . if `var' == -99
}
save "$PROJECT_ROOT/data/working_data/schools.dta", replace

******* save school visits as dta
import delimited "$PROJECT_ROOT/data/raw_data/school_visits_log.csv", clear
save "$PROJECT_ROOT/data/working_data/school_visits_log.dta", replace

******* merge all datasets
import delimited "$PROJECT_ROOT/data/raw_data/student_baseline.csv", clear
replace yob = . if yob ==9999
duplicates drop student_id, force

merge 1:m student_id using "$PROJECT_ROOT/data/working_data/student_follow_ups.dta"
drop _merge

merge m:1 school_id using "$PROJECT_ROOT/data/working_data/schools.dta"
drop _merge

merge m:m school_id using "$PROJECT_ROOT/data/working_data/school_visits_log.dta"
drop _merge

save "$PROJECT_ROOT/data/working_data/student_baseline.dta", replace


******* analysis



//Summary Statistics of school-level baseline and treatment assignment data, by treatment
 sort treatment
 by treatment:summarize  n_teachers n_teachers_fem  n_students_fem n_students_male n_schools_2km av_teacher_age av_student_score n_latrines district location female_head_teacher

//Caculate the mean differences

 ttest n_teachers, by(treatment) unequal

 ttest n_teachers_fem, by(treatment) unequal
 
 ttest n_students_fem, by(treatment) unequal
 
 ttest av_teacher_age, by(treatment) unequal
 
 ttest av_student_score, by(treatment) unequal
 
 ttest n_latrines, by(treatment) unequal
 
 ttest district, by(treatment) unequal
 
 ttest location, by(treatment) unequal
 
 ttest female_head_teacher, by(treatment) unequal

 
 //Caculate student age at 2000
gen age_2000 = 2000-yob

//gen cohort dummy
gen cohort = 0
replace cohort =1 if age_2000 ==11



//Summary Statistics of student-level baseline data, by sex
 sort sex
 by sex: summarize cohort

//gen female dummy
 gen female=0
replace female=1 if sex==2

//gen interactions dummy
 gen FC = female*cohort
 gen FT = female*treatment
 gen CT = cohort*treatment
 gen FCT = female*cohort*treatment
 
 
save "$PROJECT_ROOT/data/working_data/student_baseline.dta", replace

//Caculate the mean differences
 ttest sex, by(CT)



