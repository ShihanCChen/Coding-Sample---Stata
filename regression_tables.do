global PROJECT_ROOT "/Users/hanhan/Desktop/Shihan_Chen"

use "$PROJECT_ROOT/data/working_data/student_baseline.dta", clear
drop if died == 1

//install package
ssc inst reghdfe
ssc inst ftools
ssc inst asdoc
ssc inst erepost

 
// find treated students

gen treated = age_2000 == 11 & treatment == 1


***** dropout analysis
************************ 3 years after treatment *******************************
qui sum dropout if year == 3
local avg = `r(mean)'

// no fixed effects
reg dropout 1.treated if year == 3, vce(robust)
estadd scalar avg = `avg'
eststo model1

// survey month effects
reghdfe dropout treated##female if year == 3, vce(robust) a(month)
estadd scalar avg = `avg'
eststo model2

// survey month and treatment cohort effect
reghdfe dropout treated##female if year == 3, vce(robust) a(month cohort)
estadd scalar avg = `avg'
eststo model3

// survey month, treatment cohort and strata effects
reghdfe dropout treated##female if year == 3, vce(robust) a(month cohort stratum)
estadd scalar avg = `avg'
eststo model4

	
estfe model*, labels(month "Survey month effects" ///
	cohort "Cohort effects" stratum "Strata effects") 

esttab model* using "$PROJECT_ROOT/output/dropout_first.rtf", ///
	keep(1.treated 1.female 1.treated#1.female ) ///
	indicate(`r(indicate_fe)', labels("Yes" "")) ///
	stats(avg N , ///
	labels("Mean dep variable" "Observations")) ///
	starl(* 0.10 ** 0.05 *** 0.01) cells("b(star fmt(a2))" "se(par fmt(a2))") ///
	nonumbers replace nogap collabels(none) 

************************ 5 years after treatment *******************************
eststo clear
qui sum dropout if year == 5
local avg = `r(mean)'

// no fixed effects
reg dropout 1.treated if year == 5, vce(robust)
estadd scalar avg = `avg'
eststo model1

// survey month effects
reghdfe dropout treated##female if year == 5, vce(robust) a(month)
estadd scalar avg = `avg'
eststo model2

// survey month and treatment cohort effect
reghdfe dropout treated##female if year == 5, vce(robust) a(month cohort)
estadd scalar avg = `avg'
eststo model3

// survey month, treatment cohort and strata effects
reghdfe dropout treated##female if year == 5, vce(robust) a(month cohort stratum)
estadd scalar avg = `avg'
eststo model4

estfe model*, labels(month "Survey month effects" ///
	cohort "Cohort effects" stratum "Strata effects") 

esttab model* using "$PROJECT_ROOT/output/dropout_second.rtf", ///
	keep(1.treated 1.female 1.treated#1.female ) ///
	indicate(`r(indicate_fe)', labels("Yes" "")) ///
	stats(avg N , ///
	labels("Mean dep variable" "Observations")) ///
	starl(* 0.10 ** 0.05 *** 0.01) cells("b(star fmt(a2))" "se(par fmt(a2))") ///
	nonumbers replace nogap collabels(none) 

	
********************** Secondary outcome variables *****************************

eststo clear
reghdfe pregnant treated##female if year == 3, vce(robust) a(month cohort stratum)
qui sum pregnant if year == 3
local avg = `r(mean)'
estadd scalar avg = `avg'
eststo model1

reghdfe children treated##female if year == 3, vce(robust) a(month cohort stratum)
qui sum children if year == 3
local avg = `r(mean)'
estadd scalar avg = `avg'
eststo model2


reghdfe pregnant treated##female if year == 5, vce(robust) a(month cohort stratum)
qui sum pregnant if year == 5
local avg = `r(mean)'
estadd scalar avg = `avg'
eststo model3


reghdfe children treated##female if year == 5, vce(robust) a(month cohort stratum)
qui sum children if year == 5
local avg = `r(mean)'
estadd scalar avg = `avg'
eststo model4



estfe model*, labels(month "Survey month effects" ///
	cohort "Cohort effects" stratum "Strata effects") 

esttab model* using "$PROJECT_ROOT/output/secondary_var.rtf", ///
	keep(1.treated 1.female 1.treated#1.female ) ///
	indicate(`r(indicate_fe)', labels("Yes" "")) ///
	stats(avg N , ///
	labels("Mean dep variable" "Observations")) ///
	starl(* 0.10 ** 0.05 *** 0.01) cells("b(star fmt(a2))" "se(par fmt(a2))") ///
	nonumbers replace nogap collabels(none) 
