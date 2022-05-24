select distinct student_state_id from k12intel_dw.DTBL_STUDENT_DETAILS
go

select school_key, school_name, school_grades_group from 
K12INTEL_DW.DTBL_SCHOOLS where district_code = '2082' 
--and school_name not like ('z%')
--and school_name not like ('~%')
and school_name not like ('OUT OF DISTRICT%')
and  school_name not like ('Oregon valley%')
--and (school_key in (1,2,41,7,1032,3659,10,12,19,22,26,27,31,40,44,45,49,68,69) --traditional elementary
--or school_key in (37,1043,3685,33,35,36) --traditional high
--or school_key in (133,15,16,4,17,21,23,25)) --traditional middlle

and school_name like ('%MLK%')

order by school_grades_group,school_name
go


with CTE1 as
(
SELECT
    dtbl_students.student_race as enroll_race,
   --dtbl_students.student_gender as enroll_gender,
   count (DISTINCT dtbl_students.student_id) as enroll_cnt

FROM
   K12INTEL_DW.FTBL_ENROLLMENTS WITH (NOLOCK)
      INNER JOIN K12INTEL_DW.DTBL_STUDENTS WITH (NOLOCK) ON FTBL_ENROLLMENTS.STUDENT_KEY = DTBL_STUDENTS.STUDENT_KEY
      inner join dbo.ESD_UDStu WITH (NOLOCK) ON ESD_UDStu.sis_number = DTBL_STUDENTS.STUDENT_ID
      INNER JOIN K12INTEL_DW.DTBL_STUDENT_ANNUAL_ATTRIBS WITH (NOLOCK) ON FTBL_ENROLLMENTS.STUDENT_ANNUAL_ATTRIBS_KEY = DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_ATTRIBS_KEY
      INNER JOIN K12INTEL_DW.DTBL_SCHOOLS WITH (NOLOCK) ON FTBL_ENROLLMENTS.SCHOOL_KEY = DTBL_SCHOOLS.SCHOOL_KEY
      INNER JOIN K12INTEL_DW.DTBL_SCHOOL_DATES DTBL_SCHOOL_DATES_BEGIN_ENROLL WITH (NOLOCK) ON FTBL_ENROLLMENTS.SCHOOL_DATES_KEY_BEGIN_ENROLL = DTBL_SCHOOL_DATES_BEGIN_ENROLL.SCHOOL_DATES_KEY
      INNER JOIN K12INTEL_DW.DTBL_SCHOOL_DATES DTBL_SCHOOL_DATES_END_ENROLL WITH (NOLOCK) ON FTBL_ENROLLMENTS.SCHOOL_DATES_KEY_END_ENROLL = DTBL_SCHOOL_DATES_END_ENROLL.SCHOOL_DATES_KEY
      INNER JOIN K12INTEL_DW.DTBL_CALENDAR_DATES WITH (NOLOCK) ON FTBL_ENROLLMENTS.CAL_DATE_KEY_BEGIN_ENROLL = DTBL_CALENDAR_DATES.CALENDAR_DATE_KEY
      INNER JOIN K12INTEL_USERDATA.XTBL_DOMAIN_DECODES DOMAIN_GRADE_CODE WITH (NOLOCK) ON DOMAIN_GRADE_CODE.DOMAIN_NAME = 'GRADE_CODE' AND DOMAIN_GRADE_CODE.DOMAIN_CODE = DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_GRADE_CODE
         
WHERE  1=1
        and DTBL_SCHOOL_DATES_BEGIN_ENROLL.LOCAL_SCHOOL_YEAR='2019-2020' 
         and DTBL_SCHOOL_DATES_END_ENROLL.LOCAL_SCHOOL_YEAR='2019-2020' 
    AND 1=1
         AND dtbl_schools.school_district_code IN ('2082')
         AND dtbl_schools.school_key IN (1, 133, 2, 2509, 41, 4, 1032, 40, 68, 3659, 37, 5, 202, 49, 7, 1043, 3679, 3680, 3681, 45, 3677, 3685, 10, 69, 12, 3686, 3663, 3657, 15, 16, 64, 50, 1041, 47, 52, 17, 19, 62, 21, 67, 33, 55, 116, 61, 22, 23, 3656, 35, 36, 1001, 25, 26, 129, 27, 3661, 59, 48, 31, 44, 3662, 42, 3664)
        AND 1=1
        AND 1=1
        AND DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_RACE IN ('Asian', 'Black/African American', 'Hispanic', 'Multiple', 'Native American', 'Non-Hispanic', 'Pacific Islander', 'Unknown/Unspecified', 'White')
        AND 1=1
        and dtbl_students.student_gender <>'unknown'
 GROUP BY
   dtbl_students.student_race
   --,dtbl_students.student_gender
),
CTE2 as
(
SELECT
   --count(distinct referral_id) AS stu_group_cnt,
   count(distinct DTBL_STUDENTS.student_id) AS stu_group_cnt,
   dtbl_students.student_race AS group_race
FROM
   K12INTEL_DW.FTBL_ENROLLMENTS WITH (NOLOCK)
         INNER JOIN K12INTEL_DW.DTBL_STUDENTS WITH (NOLOCK) ON FTBL_ENROLLMENTS.STUDENT_KEY = DTBL_STUDENTS.STUDENT_KEY
                   inner join dbo.ESD_UDStu on ESD_UDStu.sis_number = DTBL_STUDENTS.student_id 
         INNER JOIN DBO.ESD_SWIS_INCIDENT  WITH (NOLOCK) ON ESD_SWIS_INCIDENT.SIS_NUMBER = DTBL_STUDENTS.STUDENT_ID
         INNER join dbo.ESD_SWIS_SCHOOLS WITH (NOLOCK) ON ESD_SWIS_SCHOOLS.SWIS_SCHOOL_ID = ESD_SWIS_INCIDENT.SWIS_SCHOOL_ID
         INNER JOIN K12INTEL_DW.DTBL_SCHOOLS WITH (NOLOCK) ON ESD_SWIS_SCHOOLS.SCHOOL = DTBL_SCHOOLS.SCHOOL_short_name
                   INNER JOIN K12INTEL_DW.DTBL_SCHOOLS STUDENTSCHOOL WITH (NOLOCK) ON DTBL_STUDENTS.SCHOOL_KEY = STUDENTSCHOOL.SCHOOL_KEY
                   INNER JOIN DBO.ESD_SWIS_BEHAVIOR B1 ON  ESD_SWIS_INCIDENT.BEHAVIOR_ID1 = B1.BEHAVIOR_ID
         LEFT JOIN DBO.ESD_SWIS_BEHAVIOR B2 ON ESD_SWIS_INCIDENT.BEHAVIOR_ID2 = B2.BEHAVIOR_ID 
         LEFT JOIN DBO.ESD_SWIS_BEHAVIOR B3 ON ESD_SWIS_INCIDENT.BEHAVIOR_ID3 = B3.BEHAVIOR_ID 
         LEFT JOIN DBO.ESD_SWIS_BEHAVIOR B4 ON ESD_SWIS_INCIDENT.BEHAVIOR_ID4 = B4.BEHAVIOR_ID 
         LEFT JOIN DBO.ESD_SWIS_BEHAVIOR B5 ON ESD_SWIS_INCIDENT.BEHAVIOR_ID5 = B5.BEHAVIOR_ID 
         INNER JOIN DBO.ESD_SWIS_DECISION D1 ON  ESD_SWIS_INCIDENT.DECISION1 = D1.DECISION_ID
         LEFT JOIN DBO.ESD_SWIS_DECISION D2 ON ESD_SWIS_INCIDENT.DECISION2 = D2.DECISION_ID
         LEFT JOIN DBO.ESD_SWIS_DECISION D3 ON ESD_SWIS_INCIDENT.DECISION3 = D3.DECISION_ID
         LEFT JOIN DBO.ESD_SWIS_DECISION D4 ON ESD_SWIS_INCIDENT.DECISION4 = D4.DECISION_ID
         LEFT JOIN DBO.ESD_SWIS_DECISION D5 ON ESD_SWIS_INCIDENT.DECISION5 = D5.DECISION_ID
         INNER JOIN DBO.ESD_SWIS_MOTIVATION MOT ON  MOT.MOTIVATION_ID = ESD_SWIS_INCIDENT.MOTIVATION_ID
         INNER JOIN DBO.ESD_SWIS_LOCATION LOC ON  LOC.LOCATION_ID = ESD_SWIS_INCIDENT.LOCATION_ID 
         INNER JOIN K12INTEL_DW.DTBL_STUDENT_ANNUAL_ATTRIBS WITH (NOLOCK) ON FTBL_ENROLLMENTS.STUDENT_ANNUAL_ATTRIBS_KEY = DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_ATTRIBS_KEY
         INNER JOIN K12INTEL_DW.DTBL_SCHOOL_DATES DTBL_SCHOOL_DATES_BEGIN_ENROLL WITH (NOLOCK) ON FTBL_ENROLLMENTS.SCHOOL_DATES_KEY_BEGIN_ENROLL = DTBL_SCHOOL_DATES_BEGIN_ENROLL.SCHOOL_DATES_KEY
         INNER JOIN K12INTEL_DW.DTBL_SCHOOL_DATES DTBL_SCHOOL_DATES_END_ENROLL WITH (NOLOCK) ON FTBL_ENROLLMENTS.SCHOOL_DATES_KEY_END_ENROLL = DTBL_SCHOOL_DATES_END_ENROLL.SCHOOL_DATES_KEY
         INNER JOIN K12INTEL_USERDATA.XTBL_DOMAIN_DECODES DOMAIN_GRADE_CODE WITH (NOLOCK) ON DOMAIN_GRADE_CODE.DOMAIN_NAME = 'GRADE_CODE' AND DOMAIN_GRADE_CODE.DOMAIN_CODE = DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_GRADE_CODE 
                   INNER JOIN K12INTEL_USERDATA.XTBL_DOMAIN_DECODES DOMAIN_GRADE_CURRENT WITH (NOLOCK) ON DOMAIN_GRADE_CURRENT.DOMAIN_NAME = 'GRADE_CODE' AND DOMAIN_GRADE_CURRENT.DOMAIN_CODE = DTBL_STUDENTS.STUDENT_CURRENT_GRADE_CODE 
                   
                  
WHERE
   (
      ENROLLMENT_TYPE = 'Actual'
      and incident_date between DTBL_SCHOOL_DATES_BEGIN_ENROLL.date_value and DTBL_SCHOOL_DATES_END_ENROLL.date_value
      and DTBL_SCHOOL_DATES_BEGIN_ENROLL.LOCAL_SCHOOL_YEAR='2019-2020'
   )
   AND (
      1=1
      AND dtbl_students.district_code IN ('2082')
      AND dtbl_schools.school_key IN (1, 133, 2, 2509, 41, 4, 1032, 40, 68, 3659, 37, 5, 202, 49, 7, 1043, 3679, 3680, 3681, 45, 3677, 3685, 10, 69, 12, 3686, 3663, 3657, 15, 16, 64, 50, 1041, 47, 52, 17, 19, 62, 21, 67, 33, 55, 116, 61, 22, 23, 3656, 35, 36, 1001, 25, 26, 129, 27, 3661, 59, 48, 31, 44, 3662, 42, 3664)
   )
GROUP BY
   dtbl_students.student_race
)
SELECT 
   enroll_race AS "C6457",
   stu_group_cnt AS "C6462",
   enroll_cnt AS "C6460",
   stu_group_cnt/cast(enroll_cnt as decimal(18,4)) AS "C6459",
   stu_group_cnt AS "C6463",
   enroll_cnt AS "C6461"
FROM
   CTE1 inner join CTE2 on CTE1.enroll_race = CTE2.group_race
   
ORDER BY
   stu_group_cnt/cast(enroll_cnt as decimal(18,4)) asc
   go


SELECT DISTINCT
	'<div class="media student-block">
<div class="d-flex align-self-center mr-2 mr-md-5">
    <img src="SecuredResources/images/students/by_student_key/{=Fields("Student Key")}.jpg" alt="" class="rounded-circle avatar--sm border-secondary" />
</div>
</div>' AS "C3364",
	dtbl_students.student_id AS "C782",
	dtbl_students.STUDENT_CURRENT_SCHOOL  AS "C5201",
	dtbl_students.student_name AS "C781",
	dtbl_students.student_current_grade_code AS "C789",
	dtbl_students.student_gender AS "C783",
	dtbl_students.student_race AS "C835",
	dtbl_students.student_key AS "C981",
	Count(Distinct dtbl_students.student_key) AS "C870",
	dtbl_students.student_status AS "C851",
	ftbl_enrollments.withdraw_reason AS "C894"
FROM
	K12INTEL_DW.FTBL_ENROLLMENTS WITH (NOLOCK)
	INNER JOIN K12INTEL_DW.DTBL_STUDENTS WITH (NOLOCK) ON FTBL_ENROLLMENTS.STUDENT_KEY = DTBL_STUDENTS.STUDENT_KEY
	inner join dbo.ESD_UDStu WITH (NOLOCK) ON ESD_UDStu.sis_number = DTBL_STUDENTS.STUDENT_ID
	INNER JOIN K12INTEL_DW.DTBL_STUDENT_ANNUAL_ATTRIBS WITH (NOLOCK) ON FTBL_ENROLLMENTS.STUDENT_ANNUAL_ATTRIBS_KEY = DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_ATTRIBS_KEY
	INNER JOIN K12INTEL_DW.DTBL_SCHOOLS WITH (NOLOCK) ON FTBL_ENROLLMENTS.SCHOOL_KEY = DTBL_SCHOOLS.SCHOOL_KEY
	INNER JOIN K12INTEL_DW.DTBL_SCHOOL_DATES DTBL_SCHOOL_DATES_BEGIN_ENROLL WITH (NOLOCK) ON FTBL_ENROLLMENTS.SCHOOL_DATES_KEY_BEGIN_ENROLL = DTBL_SCHOOL_DATES_BEGIN_ENROLL.SCHOOL_DATES_KEY
	INNER JOIN K12INTEL_DW.DTBL_SCHOOL_DATES DTBL_SCHOOL_DATES_END_ENROLL WITH (NOLOCK) ON FTBL_ENROLLMENTS.SCHOOL_DATES_KEY_END_ENROLL = DTBL_SCHOOL_DATES_END_ENROLL.SCHOOL_DATES_KEY
	INNER JOIN K12INTEL_DW.DTBL_CALENDAR_DATES WITH (NOLOCK) ON FTBL_ENROLLMENTS.CAL_DATE_KEY_BEGIN_ENROLL = DTBL_CALENDAR_DATES.CALENDAR_DATE_KEY
	INNER JOIN K12INTEL_USERDATA.XTBL_DOMAIN_DECODES DOMAIN_GRADE_CODE WITH (NOLOCK) ON DOMAIN_GRADE_CODE.DOMAIN_NAME = 'GRADE_CODE' AND DOMAIN_GRADE_CODE.DOMAIN_CODE = DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_GRADE_CODE
	
	
WHERE
	(
		--dtbl_students.student_activity_indicator = 'Active'
		DTBL_SCHOOL_DATES_END_ENROLL.LOCAL_SCHOOL_YEAR = '2021-2022'
		--		AND WITHDRAW_REASON NOT IN ('4A-Graduated with HS Diploma','Continuing Admission','Graduated, Received HS Diploma')
	)
	AND (
		1=1
		OR exists(
		     SELECT 
				NULL
		     FROM 
				K12INTEL_DW.SEC_USER_SCHOOL_LINK SUSL WITH (NOLOCK)
		     WHERE 
				SUSL.USERNAME = '2082/plunkett_s'
				AND DTBL_SCHOOLS.SCHOOL_KEY = SUSL.SCHOOL_KEY
			 )
	)
	AND (
		1=1 
		AND 1=1 
		AND 1=1
	)
	AND (
		1=1
	)
	AND (
		1=1
	)
	AND (
		1=1
	)
	AND (
		dtbl_students.student_current_grade_code IN ('P1', 'PK', 'K', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', 'TR')
	)
	AND (
		dtbl_schools.school_key IN (1, 133, 2, 2509, 41, 4, 1032, 40, 68, 3659, 37, 5, 202, 49, 7, 1043, 3679, 3680, 3681, 45, 3677, 3685, 10, 69, 12, 3686, 3663, 3657, 15, 16, 64, 50, 1041, 47, 52, 17, 19, 62, 21, 67, 33, 3655, 2600, 1149, 1349, 1599, 1669, 1031, 55, 116, 61, 22, 23, 3656, 35, 36, 1001, 2604, 25, 26, 129, 27, 3661, 3672, 3673, 59, 48, 31, 44, 3662, 42, 3664, 2612)
	)
	AND (
		ftbl_enrollments.withdraw_reason like ('3E%'))
GROUP BY
	dtbl_students.student_id,
	dtbl_students.STUDENT_CURRENT_SCHOOL ,
	dtbl_students.student_name,
	dtbl_students.student_current_grade_code,
	dtbl_students.student_gender,
	dtbl_students.student_race,
	dtbl_students.student_key,
	dtbl_students.student_status,
	ftbl_enrollments.withdraw_reason
ORDER BY
	Count(Distinct dtbl_students.student_key) desc,
	dtbl_students.student_id,
	dtbl_students.STUDENT_CURRENT_SCHOOL,
	dtbl_students.student_name,
	dtbl_students.student_current_grade_code,
	dtbl_students.student_gender,
	dtbl_students.student_race,
	dtbl_students.student_status,
	ftbl_enrollments.withdraw_reason
go

select distinct SYS_ETL_SOURCE from K12INTEL_DW.DTBL_STUDENTS
go


SELECT 
	Count(Distinct dtbl_students.student_key)  AS "C765",
	case when EPC_CRS.SUBJECT_AREA_1 = 'HE' then 'Health' 
		when EPC_CRS.SUBJECT_AREA_1 = 'SC' then 'Science'    
		 when EPC_CRS.SUBJECT_AREA_1 = 'AF' then 'Applied/Fine Arts/Foreign Language' 
		 when EPC_CRS.SUBJECT_AREA_1 = 'SS' then 'Social Studies' 
		 when EPC_CRS.SUBJECT_AREA_1 = 'LA' then 'Language Arts' 
		 when EPC_CRS.SUBJECT_AREA_1 = 'MA' then 'Math' 
		 when EPC_CRS.SUBJECT_AREA_1 = 'OS' then 'Other Subjects' 
		 when EPC_CRS.SUBJECT_AREA_1 = 'PE' then 'Physical Education' end AS "C8667",
	case when cast(LEFT(course_grade, case when  CHARINDEX('.', course_grade ) = 0 then LEN(course_grade) 
			    else CHARINDEX('.', course_grade) -1 end)as int) >= 89.5 then 'A' 
			when cast(LEFT(course_grade, case when  CHARINDEX('.',course_grade ) = 0 then LEN(course_grade) 
			    else CHARINDEX('.', course_grade) -1 end)as int) between 79.5 and 89.4999 then 'B'
			when cast(LEFT( course_grade, case when  CHARINDEX('.',  course_grade ) = 0 then LEN( course_grade) 
			    else CHARINDEX('.',  course_grade) -1 end)as int) between 69.5 and 79.4999 then 'C' 
			when cast(LEFT( course_grade, case when  CHARINDEX('.',  [course grade]) = 0 then LEN( course_grade) 
			    else CHARINDEX('.',  course_grade) -1 end)as int) between 59.5 and 69.4999 then 'D'
			when cast(LEFT( course_grade, case when  CHARINDEX('.',  course_grade ) = 0 then LEN(course_grade) 
			    else CHARINDEX('.',  course_grade) -1 end)as int) < 59.5 then 'NP' end AS "C8698"
FROM
	dbo.canvas_stats_11_10_21
		INNER JOIN K12INTEL_DW.DTBL_STUDENT_DETAILS WITH (NOLOCK) ON DTBL_STUDENT_DETAILS.STUDENT_EMAIL  = canvas_stats_11_10_21.email
		INNER JOIN K12INTEL_DW.DTBL_STUDENTS WITH (NOLOCK) ON DTBL_STUDENT_DETAILS.STUDENT_KEY = DTBL_STUDENTS.STUDENT_KEY
		inner join dbo.ESD_UDStu WITH (NOLOCK)on ESD_UDStu.sis_number = dtbl_students.student_id
		INNER JOIN K12INTEL_DW.DTBL_SCHOOLS WITH (NOLOCK) ON DTBL_STUDENTS.SCHOOL_KEY = DTBL_SCHOOLS.SCHOOL_KEY
		INNER JOIN K12INTEL_DW.DTBL_STUDENT_ATTRIBS WITH (NOLOCK) ON DTBL_STUDENTS.STUDENT_ATTRIB_KEY =  DTBL_STUDENT_ATTRIBS .STUDENT_ATTRIB_KEY
		INNER JOIN K12INTEL_USERDATA.XTBL_DOMAIN_DECODES DOMAIN_GRADE_CODE WITH (NOLOCK) ON DOMAIN_GRADE_CODE.DOMAIN_NAME = 'GRADE_CODE' AND DOMAIN_GRADE_CODE.DOMAIN_CODE = DTBL_STUDENTS.STUDENT_CURRENT_GRADE_CODE
		inner join K12INTEL_STAGING_EDP.EPC_SCH_YR_SECT WITH (NOLOCK) ON cast(EPC_SCH_YR_SECT.section_gu as varchar(150)) = canvas_stats_11_10_21.section_sis_id
		inner join K12INTEL_STAGING_EDP.EPC_STAFF_SCH_YR WITH (NOLOCK) ON EPC_STAFF_SCH_YR.STAFF_SCHOOL_YEAR_GU = EPC_SCH_YR_SECT.STAFF_SCHOOL_YEAR_GU
		inner join K12INTEL_STAGING_EDP.EPC_STAFF WITH (NOLOCK) ON EPC_STAFF.STAFF_GU = EPC_STAFF_SCH_YR.STAFF_GU
		inner join dbo.ESD_LDAP WITH (NOLOCK) ON EPC_STAFF.badge_num = ESD_LDAP.TEACHER_ID
		inner join K12INTEL_STAGING_EDP.EPC_SCH_YR_CRS WITH (NOLOCK) ON EPC_SCH_YR_CRS.SCHOOL_YEAR_COURSE_GU  = EPC_SCH_YR_SECT.SCHOOL_YEAR_COURSE_GU
		inner join K12INTEL_STAGING_EDP.EPC_CRS WITH (NOLOCK) ON EPC_CRS.course_gu = EPC_SCH_YR_CRS.course_gu
	
	
WHERE
	(
		dtbl_students.student_current_grade_code in ('06','07','08','09','10','11','12')
		--and epc_sch_yr_sect.term_code = '1'
		AND course_grade <> ''
	)
	AND (
		dtbl_students.student_activity_indicator IN ('Active')
	)
	AND (
		1=1
	)
	AND (
		1=1
	)
	AND (
		dtbl_schools.school_key IN (1, 133, 2, 2509, 41, 4, 1032, 40, 68, 3659, 37, 5, 202, 49, 7, 1043, 3679, 3680, 3681, 45, 3677, 3685, 10, 69, 12, 3686, 3663, 3657, 15, 16, 64, 50, 1041, 47, 52, 17, 19, 62, 21, 67, 33, 3655, 2600, 1149, 1349, 1599, 1669, 1031, 55, 116, 61, 22, 23, 3656, 35, 36, 1001, 2604, 25, 26, 129, 27, 3661, 3672, 3673, 59, 48, 31, 44, 3662, 42, 3664, 2612)
	)
	AND (
		dtbl_students.student_current_grade_code IN ('P1', 'PK', 'K', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', 'TR')
	)
	AND (
		1=1 
		AND 1=1 
		AND 1=1
	)
	AND (
		1=1
	)
GROUP BY
	case when EPC_CRS.SUBJECT_AREA_1 = 'HE' then 'Health' 
		when EPC_CRS.SUBJECT_AREA_1 = 'SC' then 'Science'    
		 when EPC_CRS.SUBJECT_AREA_1 = 'AF' then 'Applied/Fine Arts/Foreign Language' 
		 when EPC_CRS.SUBJECT_AREA_1 = 'SS' then 'Social Studies' 
		 when EPC_CRS.SUBJECT_AREA_1 = 'LA' then 'Language Arts' 
		 when EPC_CRS.SUBJECT_AREA_1 = 'MA' then 'Math' 
		 when EPC_CRS.SUBJECT_AREA_1 = 'OS' then 'Other Subjects' 
		 when EPC_CRS.SUBJECT_AREA_1 = 'PE' then 'Physical Education' end,
	case when cast(LEFT(course_grade, case when  CHARINDEX('.', course_grade ) = 0 then LEN(course_grade) 
			    else CHARINDEX('.', course_grade) -1 end)as int) >= 89.5 then 'A' 
			when cast(LEFT(course_grade, case when  CHARINDEX('.',course_grade ) = 0 then LEN(course_grade) 
			    else CHARINDEX('.', course_grade) -1 end)as int) between 79.5 and 89.4999 then 'B'
			when cast(LEFT( course_grade, case when  CHARINDEX('.',  course_grade ) = 0 then LEN( course_grade) 
			    else CHARINDEX('.',  course_grade) -1 end)as int) between 69.5 and 79.4999 then 'C' 
			when cast(LEFT( course_grade, case when  CHARINDEX('.',  [course grade]) = 0 then LEN( course_grade) 
			    else CHARINDEX('.',  course_grade) -1 end)as int) between 59.5 and 69.4999 then 'D'
			when cast(LEFT( course_grade, case when  CHARINDEX('.',  course_grade ) = 0 then LEN(course_grade) 
			    else CHARINDEX('.',  course_grade) -1 end)as int) < 59.5 then 'NP' end
ORDER BY
	case when EPC_CRS.SUBJECT_AREA_1 = 'HE' then 'Health' 
		when EPC_CRS.SUBJECT_AREA_1 = 'SC' then 'Science'    
		 when EPC_CRS.SUBJECT_AREA_1 = 'AF' then 'Applied/Fine Arts/Foreign Language' 
		 when EPC_CRS.SUBJECT_AREA_1 = 'SS' then 'Social Studies' 
		 when EPC_CRS.SUBJECT_AREA_1 = 'LA' then 'Language Arts' 
		 when EPC_CRS.SUBJECT_AREA_1 = 'MA' then 'Math' 
		 when EPC_CRS.SUBJECT_AREA_1 = 'OS' then 'Other Subjects' 
		 when EPC_CRS.SUBJECT_AREA_1 = 'PE' then 'Physical Education' end,
	case when cast(LEFT(course_grade, case when  CHARINDEX('.', course_grade ) = 0 then LEN(course_grade) 
			    else CHARINDEX('.', course_grade) -1 end)as int) >= 89.5 then 'A' 
			when cast(LEFT(course_grade, case when  CHARINDEX('.',course_grade ) = 0 then LEN(course_grade) 
			    else CHARINDEX('.', course_grade) -1 end)as int) between 79.5 and 89.4999 then 'B'
			when cast(LEFT( course_grade, case when  CHARINDEX('.',  course_grade ) = 0 then LEN( course_grade) 
			    else CHARINDEX('.',  course_grade) -1 end)as int) between 69.5 and 79.4999 then 'C' 
			when cast(LEFT( course_grade, case when  CHARINDEX('.',  [course grade]) = 0 then LEN( course_grade) 
			    else CHARINDEX('.',  course_grade) -1 end)as int) between 59.5 and 69.4999 then 'D'
			when cast(LEFT( course_grade, case when  CHARINDEX('.',  course_grade ) = 0 then LEN(course_grade) 
			    else CHARINDEX('.',  course_grade) -1 end)as int) < 59.5 then 'NP' end
			    go
			    
EXEC sp_rename 'dbo.canvas_stats_11_10_21.[course grade]', 'course_grade', 'COLUMN';
go