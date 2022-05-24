--student grades
SELECT distinct

	dtbl_students.student_id AS sis,
	dtbl_students.student_name AS [name],
	dtbl_school_dates.local_school_year AS [year],
	dtbl_school_dates.local_semester AS [sem],
	dtbl_students.STUDENT_CURRENT_SCHOOL AS [curr_sch],
	dtbl_student_annual_attribs.student_annual_school AS [ann_sch],
	dtbl_students.student_current_grade_code AS curr_grade,
	student_annual_grade_code AS ann_grade,
	dtbl_courses.course_subject AS cour_sub,
	dtbl_courses.course_name AS cour_name,
	Scale_code AS scale_code,
	FTBL_STUDENT_MARKS. MARK_TYPE AS mark_type,
	SCALE_PASS_FAIL_INDICATOR AS pass_fail,
	case when Scale_code in ('D', 'F', 'NP', 'WF', 'I', 'NrPr','NtPr') then 'Y' else 'N' end AS D_F_Ind,
	dtbl_students.student_race AS race,
	dtbl_students.student_gender AS gender,
	dtbl_students.student_esl_indicator AS esl_ind,
	dtbl_students.student_special_ed_indicator AS sped_ind,
	dbo.ESD_StudentDataWall.curryr_att ,
	dbo.ESD_StudentDataWall.prevyr_att
FROM
	K12INTEL_DW.FTBL_STUDENT_MARKS WITH (NOLOCK)
	INNER JOIN K12INTEL_DW.DTBL_STUDENTS WITH (NOLOCK) ON FTBL_STUDENT_MARKS.STUDENT_KEY = DTBL_STUDENTS.STUDENT_KEY
	INNER JOIN dbo.ESD_UDStu WITH (NOLOCK) ON ESD_UDStu.sis_number = DTBL_STUDENTS.STUDENT_ID
	inner join dbo.ESD_StudentDataWall WITH (NOLOCK) ON ESD_StudentDataWall.student_key = DTBL_STUDENTS.STUDENT_KEY
	INNER JOIN K12INTEL_DW.DTBL_STUDENT_ATTRIBS WITH (NOLOCK) ON DTBL_STUDENTS.STUDENT_ATTRIB_KEY = DTBL_STUDENT_ATTRIBS.STUDENT_ATTRIB_KEY
	INNER JOIN K12INTEL_DW.DTBL_STUDENT_ANNUAL_ATTRIBS WITH (NOLOCK) ON FTBL_STUDENT_MARKS.STUDENT_ANNUAL_ATTRIBS_KEY = DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_ATTRIBS_KEY
	INNER JOIN K12INTEL_DW.DTBL_SCHOOLS WITH (NOLOCK) ON FTBL_STUDENT_MARKS.SCHOOL_KEY = DTBL_SCHOOLS.SCHOOL_KEY
	inner join dbo.School_groups WITH (NOLOCK) ON School_groups.school_key = DTBL_SCHOOLS.SCHOOL_KEY
	INNER JOIN K12INTEL_DW.DTBL_SCHOOL_DATES WITH (NOLOCK) ON FTBL_STUDENT_MARKS.SCHOOL_DATES_KEY = DTBL_SCHOOL_DATES.SCHOOL_DATES_KEY
	INNER JOIN K12INTEL_DW.DTBL_CALENDAR_DATES WITH (NOLOCK) ON FTBL_STUDENT_MARKS.CALENDAR_DATE_KEY = DTBL_CALENDAR_DATES .CALENDAR_DATE_KEY
	INNER JOIN K12INTEL_DW.DTBL_COURSES WITH (NOLOCK) ON FTBL_STUDENT_MARKS.COURSE_KEY = DTBL_COURSES.COURSE_KEY
	INNER JOIN K12INTEL_DW.DTBL_COURSE_OFFERINGS WITH (NOLOCK) ON FTBL_STUDENT_MARKS.COURSE_OFFERINGS_KEY = DTBL_COURSE_OFFERINGS.COURSE_OFFERINGS_KEY
	INNER JOIN K12INTEL_DW.DTBL_SCALES WITH (NOLOCK) ON FTBL_STUDENT_MARKS.SCALE_KEY = DTBL_SCALES.SCALE_KEY
	INNER JOIN K12INTEL_USERDATA.XTBL_DOMAIN_DECODES DOMAIN_GRADE_CODE WITH (NOLOCK) ON DOMAIN_GRADE_CODE.DOMAIN_NAME = 'GRADE_CODE' AND DOMAIN_GRADE_CODE.DOMAIN_CODE = DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_GRADE_CODE
	
	
	--dtbl_scales.scale_abbreviation in ('A','B','C','D','F')
WHERE
	(
		DTBL_STUDENTS.STUDENT_KEY IN (SELECT STUDENT_KEY FROM K12INTEL_DW.FTBL_STUDENT_SCHEDULES
		      WHERE (1=1))
		--and mark_type = 'final'
		and mark_type = 'final'
		and dtbl_students.student_current_grade_code in ('09','10','11','12','13','14','TR')
	)
    and course_subject = 'Mathematics'
    
	AND (
		dtbl_students.student_current_grade_code IN ('09')
	)
	AND (
		DTBL_SCHOOL_DATES.LOCAL_SCHOOL_YEAR in ('2018-2019','2019-2020','2020-2021')
	)
	
	AND (
		dtbl_schools.school_key IN (1, 133, 2, 2509, 41, 4, 1032, 40, 68, 3659, 37, 5, 202, 49, 7, 1043, 3679, 3680, 3681, 45, 3677, 3685, 10, 69, 12, 3686, 3663, 3657, 15, 16, 64, 50, 1041, 47, 52, 17, 19, 62, 21, 67, 33, 3655, 2600, 1149, 1349, 1599, 1669, 1031, 55, 116, 61, 22, 23, 3656, 35, 36, 1001, 2604, 25, 26, 129, 27, 3661, 3672, 3673, 59, 48, 31, 44, 3662, 42, 3664, 3687, 2612)
	)

ORDER BY
	dtbl_students.student_id,
	dtbl_students.student_name,
	dtbl_school_dates.local_school_year asc,
	dtbl_school_dates.local_semester,
	dtbl_students.STUDENT_CURRENT_SCHOOL,
	dtbl_student_annual_attribs.student_annual_school,
	dtbl_students.student_current_grade_code,
	student_annual_grade_code,
	dtbl_courses.course_subject,
	dtbl_courses.course_name,
	FTBL_STUDENT_MARKS. MARK_TYPE,
	SCALE_PASS_FAIL_INDICATOR,
	case when Scale_code in ('D', 'F', 'NP', 'WF', 'I', 'NrPr','NtPr') then 'Y' else 'N' end,
	dtbl_students.student_race,
	dtbl_students.student_gender,
	dtbl_students.student_esl_indicator,
	dtbl_students.student_special_ed_indicator,
	dbo.ESD_StudentDataWall.curryr_att
go	


