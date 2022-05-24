SELECT
    --Distinct dtbl_students.student_key,
    DTBL_SCHOOL_DATES_BEGIN_ENROLL.local_school_year,
	Count(Distinct dtbl_students.student_key)  AS [count],
	case when ELL.ELL_flag = 'Y' then 'Y' else 'N' end ELL_Flag
	--case when FRL_FLAG = 'Y' then 'Y' else 'N' end frl_flag
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
	left join dbo.[FRM_2022_5_YR] frm WITH (NOLOCK) ON case when FRL_flag = 'Y' then frm.sis_number end = DTBL_STUDENTS.STUDENT_ID and DTBL_SCHOOL_DATES_BEGIN_ENROLL.local_school_year = frm.local_school_year 
	left join dbo.[ELL_2022_5YR] ELL WITH (NOLOCK) ON case when ELL.need in ('ELD Class Period','ELD Pull-out','ELD Sheltered Instruction','ELD 2-way Immersion')  then ell.sis_number end = DTBL_STUDENTS.STUDENT_ID and DTBL_SCHOOL_DATES_BEGIN_ENROLL.local_school_year = ell.local_school_year 
	
WHERE
	( 1=1
		--getdate() between DTBL_SCHOOL_DATES_BEGIN_ENROLL.date_value 
		--and DTBL_SCHOOL_DATES_END_ENROLL.date_value
		and DTBL_SCHOOL_DATES_BEGIN_ENROLL.rolling_local_school_yr_number between -4 and 0  

	)
--	AND (
--		DTBL_STUDENTS.STUDENT_ACTIVITY_INDICATOR = 'ACTIVE'
--	)
	
	AND (
		dtbl_students.student_current_grade_code IN ('P1', 'PK', 'K', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', 'TR')
	)
	AND (
		dtbl_schools.school_key IN (1, 133, 2, 2509, 41, 4, 1032, 40, 68, 3659, 37, 5, 202, 49, 7, 1043, 3679, 3680, 3681, 45, 3677, 3685, 10, 69, 12, 3686, 3663, 3657, 15, 16, 64, 50, 1041, 47, 52, 17, 19, 62, 21, 67, 33, 3655, 2600, 1149, 1349, 1599, 1669, 1031, 55, 116, 61, 22, 23, 3656, 35, 36, 1001, 2604, 25, 26, 129, 27, 3661, 3672, 3673, 59, 48, 31, 44, 3662, 42, 3664, 3687, 2612)
	)
group by 
DTBL_SCHOOL_DATES_BEGIN_ENROLL.local_school_year,
--case when FRL_FLAG = 'Y' then 'Y' else 'N' end
case when ELL.ELL_flag = 'Y' then 'Y' else 'N' end
order by 
--dtbl_students.student_key,
DTBL_SCHOOL_DATES_BEGIN_ENROLL.local_school_year desc,
--case when FRL_FLAG = 'Y' then 'Y' else 'N' end
case when ELL.ELL_flag = 'Y' then 'Y' else 'N' end
go


select local_school_year, count(distinct sis_number) from dbo.FRM_2022_5_YR
where frl_flag = 'y'
group by local_school_year
go

select local_school_year, need, count(distinct sis_number) from dbo.ELL_2022_5YR

group by 
local_school_year, need
order by 
local_school_year, need



go


