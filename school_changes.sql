
SELECT
	distinct 
	dtbl_students.student_id,
--	DTBL_SCHOOL_DATES_BEGIN_ENROLL.local_school_year,
--	DTBL_SCHOOL_DATES_BEGIN_ENROLL.Date_value begin_date,
--	DTBL_SCHOOL_DATES_END_ENROLL.date_value end_date,
--	ftbl_enrollments.admission_reason,
--	ftbl_enrollments.withdraw_reason,
--	 DTBL_SCHOOLS.school_name,
--	 dtbl_students.student_current_grade_code,
	 count(distinct dtbl_schools.school_name)
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

WHERE 1=1
--and dtbl_students.student_activity_indicator = 'active'
--and ftbl_enrollments.withdraw_reason = '1C-Same District - No Particular School'
and dtbl_students.DISTRICT_CODE = '2082'
and DTBL_SCHOOL_DATES_BEGIN_ENROLL.local_school_year in ('2017-2018', '2018-2019', '2021-2022')
and ADMISSION_REASON like '%Re-entry%'
--and ADMISSION_REASON = 'New enroll in US, curr year'
--and dtbl_students.student_id = '162510'
--group BY
	--ftbl_enrollments.admission_reason
--	ftbl_enrollments.withdraw_reason 

--and withdraw_reason <> ('1B-Diff School Within Same District')
group by 
    dtbl_students.student_id
--	DTBL_SCHOOL_DATES_BEGIN_ENROLL.local_school_year,
--	DTBL_SCHOOL_DATES_BEGIN_ENROLL.Date_value,
--	DTBL_SCHOOL_DATES_END_ENROLL.date_value,
--	ftbl_enrollments.admission_reason,
--	ftbl_enrollments.withdraw_reason,
--	 DTBL_SCHOOLS.school_name,
--	 dtbl_students.student_current_grade_code


ORDER BY
    count(distinct dtbl_schools.school_name) desc,
	dtbl_students.student_id
--	DTBL_SCHOOL_DATES_BEGIN_ENROLL.local_school_year,
--	DTBL_SCHOOL_DATES_BEGIN_ENROLL.Date_value,
--	DTBL_SCHOOL_DATES_END_ENROLL.date_value,
--    ftbl_enrollments.admission_reason
go	

--('1B-Diff School Within Same District','1B-To 4J Online EOA')
--sample students
--304304
