SELECT distinct
    dtbl_school_dates.local_school_year AS school_year,
    dtbl_school_dates.local_semester AS trisemester,
	dtbl_schools.school_name AS current_school,
	dtbl_student_annual_attribs.student_annual_school AS annual_school,
	dtbl_students.student_id AS sis_number,
	dtbl_students.student_name AS student_name,
	dtbl_students.student_current_grade_code AS current_grade,
	dtbl_student_annual_attribs.student_annual_grade_code as annual_grade,
	dtbl_courses.course_subject AS subject,
	dtbl_courses.course_name AS course,
	Scale_code AS mark,
	dtbl_students.student_race,
	dtbl_students.student_gender,
	flag_sped,
	flag_ell,
	flag_tag
	
	
FROM
	K12INTEL_DW.FTBL_STUDENT_MARKS WITH (NOLOCK)
	INNER JOIN K12INTEL_DW.DTBL_STUDENTS WITH (NOLOCK) ON FTBL_STUDENT_MARKS.STUDENT_KEY = DTBL_STUDENTS.STUDENT_KEY
	INNER JOIN dbo.ESD_UDStu WITH (NOLOCK) ON ESD_UDStu.sis_number = DTBL_STUDENTS.STUDENT_ID
	INNER JOIN K12INTEL_DW.DTBL_STUDENT_ATTRIBS WITH (NOLOCK) ON DTBL_STUDENTS.STUDENT_ATTRIB_KEY = DTBL_STUDENT_ATTRIBS.STUDENT_ATTRIB_KEY
	INNER JOIN K12INTEL_DW.DTBL_STUDENT_ANNUAL_ATTRIBS WITH (NOLOCK) ON FTBL_STUDENT_MARKS.STUDENT_ANNUAL_ATTRIBS_KEY = DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_ATTRIBS_KEY
	INNER JOIN K12INTEL_DW.DTBL_SCHOOLS WITH (NOLOCK) ON FTBL_STUDENT_MARKS.SCHOOL_KEY = DTBL_SCHOOLS.SCHOOL_KEY
	INNER JOIN K12INTEL_DW.DTBL_SCHOOL_DATES WITH (NOLOCK) ON FTBL_STUDENT_MARKS.SCHOOL_DATES_KEY = DTBL_SCHOOL_DATES.SCHOOL_DATES_KEY
	INNER JOIN K12INTEL_DW.DTBL_CALENDAR_DATES WITH (NOLOCK) ON FTBL_STUDENT_MARKS.CALENDAR_DATE_KEY = DTBL_CALENDAR_DATES .CALENDAR_DATE_KEY
	INNER JOIN K12INTEL_DW.DTBL_COURSES WITH (NOLOCK) ON FTBL_STUDENT_MARKS.COURSE_KEY = DTBL_COURSES.COURSE_KEY
	INNER JOIN K12INTEL_DW.DTBL_COURSE_OFFERINGS WITH (NOLOCK) ON FTBL_STUDENT_MARKS.COURSE_OFFERINGS_KEY = DTBL_COURSE_OFFERINGS.COURSE_OFFERINGS_KEY
	INNER JOIN K12INTEL_DW.DTBL_SCALES WITH (NOLOCK) ON FTBL_STUDENT_MARKS.SCALE_KEY = DTBL_SCALES.SCALE_KEY
	INNER JOIN K12INTEL_USERDATA.XTBL_DOMAIN_DECODES DOMAIN_GRADE_CODE WITH (NOLOCK) ON DOMAIN_GRADE_CODE.DOMAIN_NAME = 'GRADE_CODE' AND DOMAIN_GRADE_CODE.DOMAIN_CODE = DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_GRADE_CODE
	
WHERE
	1=1 
	AND dtbl_students.student_current_grade_code IN ('P1', 'PK', 'K', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', 'TR')
	and dtbl_student_annual_attribs.student_annual_grade_code = '09'

	AND DTBL_SCHOOL_DATES.LOCAL_SCHOOL_YEAR in ('2017-2018','2018-2019','2019-2020','2020-2021','2021-2022')
	and dtbl_school_dates.local_semester in ('1','2','3')
    and FTBL_STUDENT_MARKS. MARK_TYPE = 'Final'
	
	and dtbl_student_annual_attribs.student_annual_school in ('South Eugene High School', 'North Eugene High School','Sheldon High School','Churchill High School')
	
	and course_subject = 'Mathematics'
	and course_name not like '%Geometry%' and course_name not like '%Algebra II%'
	and course_name not like '%Basic Algebra%' and course_name not like '%Consumer Math%'
	and course_name not like '%Pre%' and course_name not like '%FuelEd MA Placeholder%'
	and course_name not like '%Math Links %' and course_name not like '%FE%'
	and course_name not like '%Alg II STEM%' and course_name not like '%Calculus%'
	and course_name not like '%Statistics%' and course_name not like '%Math 8%'
	and course_name not like '%General Math%' and course_name not like '%PBL%'
	and course_name not like '%Statistics%' and course_name not like '%Math 8%'
	and course_name not like '%Aviation%' and course_name not like '%Incoming credits%'
	and course_name not like '%Math Concepts%'
	
	
	
ORDER BY
	dtbl_schools.school_name,
	dtbl_school_dates.local_school_year,
	dtbl_school_dates.local_semester,
	dtbl_student_annual_attribs.student_annual_school,
	dtbl_students.student_name,
	dtbl_students.student_id,
	dtbl_students.student_current_grade_code,
	dtbl_student_annual_attribs.student_annual_grade_code,
	dtbl_courses.course_name,
	dtbl_students.student_race,
	dtbl_students.student_gender,
	flag_sped,
	flag_ell,
	flag_tag
go


