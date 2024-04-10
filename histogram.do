
global PROJECT_ROOT "/Users/hanhan/Desktop/Shihan_Chen"

use "$PROJECT_ROOT/data/working_data/schools.dta", clear

//histogram 1: Number of female students
gen log_students_fem = log(n_students_fem)
gen log_students_male = log(n_students_male)
tw ///
	(hist log_students_fem if treatment == 0, color(red%50) start(4) width(0.2) ) ///
	(hist log_students_fem if treatment == 1,  color(midblue%50) start(4) width(0.2)), ///
	graphregion(color(white))  legend(position(6) rows(1)  ring(1) region(fcolor(none) lpattern(solid) lcolor(white)) order(1 "Control Schools" 2 "Treated Schools" )) xtitle("log(number of female students)")
	graph export "$PROJECT_ROOT/output/log_students_female.svg", replace

//histogram 2: Number of male students

tw ///
	(hist log_students_male if treatment == 0, color(red%50) start(4) width(0.2) ) ///
	(hist log_students_male if treatment == 1,  color(midblue%50) start(4) width(0.2)), ///
	graphregion(color(white))  legend(position(6) rows(1)  ring(1) region(fcolor(none) lpattern(solid) lcolor(white)) order(1 "Control Schools" 2 "Treated Schools" )) xtitle("log(number of male students)")
	
graph export "$PROJECT_ROOT/output/log_students_male.svg", replace


