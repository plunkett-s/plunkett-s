--Namely, could you please send me for Middle School (Monroe) and High School (South and Sheldon) French student enrollment numbers (eg students enrolled in French language classes that are NOT French Immersion classes) 
--by school, by level (French 1, 2, 3, and French 4), and by trimester?   
--I would need that information for both this year (2021-22) and for 2018-2019, 




SELECT
    dtbl_school_dates.LOCAL_SCHOOL_YEAR,
    dtbl_school_dates.LOCAL_semester,
	dtbl_schools.school_name,
	dtbl_courses.course_name AS "C943",
	count(distinct ftbl_student_schedules.STUDENT_KEY) AS "C958"
FROM
	K12INTEL_DW.FTBL_STUDENT_SCHEDULES WITH (NOLOCK) 
		INNER JOIN K12INTEL_DW.DTBL_COURSE_OFFERINGS WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.COURSE_OFFERINGS_KEY = DTBL_COURSE_OFFERINGS.COURSE_OFFERINGS_KEY
		INNER JOIN K12INTEL_DW.DTBL_SCHOOLS WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.SCHOOL_KEY = DTBL_SCHOOLS.SCHOOL_KEY
		INNER JOIN K12INTEL_DW.DTBL_SCHOOL_DATES WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.SCHOOL_DATES_KEY = DTBL_SCHOOL_DATES.SCHOOL_DATES_KEY
		INNER JOIN K12INTEL_DW.DTBL_STAFF WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.STAFF_KEY = DTBL_STAFF.STAFF_KEY
		INNER JOIN K12INTEL_DW.DTBL_STUDENTS WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.STUDENT_KEY = DTBL_STUDENTS.STUDENT_KEY 
		INNER JOIN K12INTEL_DW.DTBL_COURSES WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.COURSE_KEY = DTBL_COURSES.COURSE_KEY
		INNER JOIN K12INTEL_USERDATA.XTBL_DOMAIN_DECODES DOMAIN_GRADE_CODE WITH (NOLOCK) ON DOMAIN_GRADE_CODE.DOMAIN_NAME = 'GRADE_CODE' AND DOMAIN_GRADE_CODE.DOMAIN_CODE = DTBL_STUDENTS.STUDENT_CURRENT_GRADE_CODE
		
WHERE
	(dtbl_school_dates.ROLLING_LOCAL_SCHOOL_YR_NUMBER in (0, -3)
		--AND dtbl_courses.COURSE_ACADEMIC_LEVEL NOT IN ('@ERR')
		--AND COURSE_TYPE not in ('NA','@ERR')
		AND COURSE_SUBJECT NOT IN('@ERR','--')
		
		)
	--AND (DTBL_STUDENTS.STUDENT_ACTIVITY_INDICATOR = 'ACTIVE')
	 
	and DTBL_SCHOOLS.school_name in ('Monroe Middle School','South Eugene High School', 'Sheldon High School')
	and course_name like ('%French%') 
	and course_name not like ('%Imm%')
	and course_name not like ('%Explore%')
	 AND (domain_grade_code.domain_alternate_decode IN ('P1', 'PK', 'K', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', 'TR'))
	 --AND (dtbl_schools.school_key IN (1, 133, 2, 2509, 41, 4, 1032, 40, 68, 3659, 37, 5, 202, 42, 49, 7, 1043, 3680, 3681, 45, 3677, 3685, 10, 69, 12, 3663, 3657, 15, 16, 64, 50, 1041, 47, 52, 17, 19, 62, 21, 67, 33, 3655, 2600, 1149, 1349, 1599, 1669, 1031, 55, 116, 61, 22, 23, 3656, 35, 36, 1001, 2604, 25, 26, 129, 27, 3661, 3672, 3673, 59, 48, 31, 44, 3662, 3679, 3664, 2612))
	
 GROUP BY
     dtbl_school_dates.LOCAL_SCHOOL_YEAR,
    dtbl_school_dates.LOCAL_semester,
	dtbl_schools.school_name,
	dtbl_courses.course_name
 ORDER BY
    dtbl_school_dates.LOCAL_SCHOOL_YEAR,
    dtbl_school_dates.LOCAL_semester,
	dtbl_schools.school_name
	--,dtbl_courses.course_name