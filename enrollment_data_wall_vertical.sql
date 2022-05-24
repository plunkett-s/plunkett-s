SELECT
	dtbl_school_dates_begin_enroll.local_school_year AS [year],
	dtbl_schools.school_name AS enrolled_school,
	DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_GRADE_CODE as [annual_grade],
	dtbl_students.student_name [name],
	dtbl_students.student_id [sis_number],
	dtbl_students.student_gender gender,
	dtbl_students.student_race race,
	dtbl_students.STUDENT_SPECIAL_ED_INDICATOR sped_flag,
	dtbl_students.STUDENT_ESL_INDICATOR esl_flag,
	ATT_PERCENT,
	DTBL_STUDENTS.STUDENT_CURRENT_SCHOOL current_school,
	DTBL_STUDENTS.STUDENT_CURRENT_GRADE_CODE [current_grade],
	dtbl_school_dates_begin_enroll.date_value AS begin_enroll,
	dtbl_school_dates_end_enroll.date_value AS end_enroll,
	ftbl_enrollments.admission_reason AS enroll_reason,
	ftbl_enrollments.withdraw_reason AS withdraw_reason
	
FROM
	K12INTEL_DW.FTBL_ENROLLMENTS WITH (NOLOCK)
	INNER JOIN K12INTEL_DW.DTBL_STUDENTS WITH (NOLOCK) ON FTBL_ENROLLMENTS.STUDENT_KEY = DTBL_STUDENTS.STUDENT_KEY
	inner join dbo.ESD_UDStu WITH (NOLOCK) ON ESD_UDStu.sis_number = DTBL_STUDENTS.STUDENT_ID
	INNER JOIN K12INTEL_DW.DTBL_STUDENT_ANNUAL_ATTRIBS WITH (NOLOCK) ON FTBL_ENROLLMENTS.STUDENT_ANNUAL_ATTRIBS_KEY = DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_ATTRIBS_KEY
	INNER JOIN K12INTEL_DW.DTBL_SCHOOLS WITH (NOLOCK) ON FTBL_ENROLLMENTS.SCHOOL_KEY = DTBL_SCHOOLS.SCHOOL_KEY
	INNER JOIN dbo.School_groups WITH (NOLOCK) ON School_groups.SCHOOL_KEY = DTBL_SCHOOLS.SCHOOL_KEY
	INNER JOIN K12INTEL_DW.DTBL_SCHOOL_DATES DTBL_SCHOOL_DATES_BEGIN_ENROLL WITH (NOLOCK) ON FTBL_ENROLLMENTS.SCHOOL_DATES_KEY_BEGIN_ENROLL = DTBL_SCHOOL_DATES_BEGIN_ENROLL.SCHOOL_DATES_KEY
	INNER JOIN K12INTEL_DW.DTBL_SCHOOL_DATES DTBL_SCHOOL_DATES_END_ENROLL WITH (NOLOCK) ON FTBL_ENROLLMENTS.SCHOOL_DATES_KEY_END_ENROLL = DTBL_SCHOOL_DATES_END_ENROLL.SCHOOL_DATES_KEY
	INNER JOIN K12INTEL_DW.DTBL_CALENDAR_DATES WITH (NOLOCK) ON FTBL_ENROLLMENTS.CAL_DATE_KEY_BEGIN_ENROLL = DTBL_CALENDAR_DATES.CALENDAR_DATE_KEY
	INNER JOIN K12INTEL_USERDATA.XTBL_DOMAIN_DECODES DOMAIN_GRADE_CODE WITH (NOLOCK) ON DOMAIN_GRADE_CODE.DOMAIN_NAME = 'GRADE_CODE' AND DOMAIN_GRADE_CODE.DOMAIN_CODE = DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_GRADE_CODE
	
WHERE
	( 1=1
		and dtbl_students.student_key = 299945
	)
	
	
ORDER BY
	dtbl_school_dates_begin_enroll.date_value desc,
	dtbl_school_dates_end_enroll.date_value,
	dtbl_schools.school_name,
	dtbl_school_dates_begin_enroll.local_school_year,
	ftbl_enrollments.admission_reason,
	ftbl_enrollments.withdraw_reason
go

