--AP/IB, credits
--with credits as(
--select school_name, grade, count(distinct student_key) stu_key from(
SELECT
	dtbl_schools.school_name,
	--dtbl_courses.course_name AS course,
	--DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_GRADE_CODE as Grade,
	case dtbl_students.STUDENT_CURRENT_GRADE_CODE grade,
	--count(distinct ftbl_student_schedules.STUDENT_KEY) AS [count],
	ftbl_student_schedules.STUDENT_KEY,
	sum(MARK_CREDIT_VALUE_EARNED) earned,
	sum(MARK_CREDIT_VALUE_ATTEMPTED) attempted

FROM
	K12INTEL_DW.FTBL_STUDENT_SCHEDULES WITH (NOLOCK) 
		INNER JOIN K12INTEL_DW.DTBL_COURSE_OFFERINGS WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.COURSE_OFFERINGS_KEY = DTBL_COURSE_OFFERINGS.COURSE_OFFERINGS_KEY
		INNER JOIN K12INTEL_DW.DTBL_SCHOOLS WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.SCHOOL_KEY = DTBL_SCHOOLS.SCHOOL_KEY
		INNER JOIN K12INTEL_DW.DTBL_SCHOOL_DATES WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.SCHOOL_DATES_KEY = DTBL_SCHOOL_DATES.SCHOOL_DATES_KEY
		INNER JOIN K12INTEL_DW.DTBL_STAFF WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.STAFF_KEY = DTBL_STAFF.STAFF_KEY
		INNER JOIN K12INTEL_DW.DTBL_STUDENTS WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.STUDENT_KEY = DTBL_STUDENTS.STUDENT_KEY 
		inner join dbo.ESD_UDStu WITH (NOLOCK) ON ESD_UDStu.sis_number = DTBL_STUDENTS.STUDENT_ID
		INNER JOIN K12INTEL_DW.DTBL_COURSES WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.COURSE_KEY = DTBL_COURSES.COURSE_KEY
		INNER JOIN K12INTEL_DW.FTBL_STUDENT_MARKS WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.STUDENT_SCHEDULES_KEY = FTBL_STUDENT_MARKS.STUDENT_SCHEDULES_KEY
        INNER JOIN K12INTEL_DW.DTBL_SCALES WITH (NOLOCK) ON DTBL_SCALES.SCALE_KEY = FTBL_STUDENT_MARKS.SCALE_KEY
		INNER JOIN K12INTEL_USERDATA.XTBL_DOMAIN_DECODES DOMAIN_GRADE_CODE WITH (NOLOCK) ON DOMAIN_GRADE_CODE.DOMAIN_NAME = 'GRADE_CODE' AND DOMAIN_GRADE_CODE.DOMAIN_CODE = DTBL_STUDENTS.STUDENT_CURRENT_GRADE_CODE
		INNER JOIN K12INTEL_DW.DTBL_STUDENT_ATTRIBS WITH (NOLOCK) ON DTBL_STUDENTS.STUDENT_ATTRIB_KEY = DTBL_STUDENT_ATTRIBS.STUDENT_ATTRIB_KEY
		INNER JOIN K12INTEL_DW.DTBL_STUDENT_ANNUAL_ATTRIBS WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.STUDENT_ANNUAL_ATTRIBS_KEY = DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_ATTRIBS_KEY
		

WHERE
	( 1=1
	--dtbl_school_dates.ROLLING_LOCAL_SCHOOL_YR_NUMBER = -1
		--AND dtbl_courses.COURSE_ACADEMIC_LEVEL NOT IN ('@ERR')
		--AND COURSE_TYPE not in ('NA','@ERR')
		AND COURSE_SUBJECT NOT IN('@ERR','--')
		and student_diploma_type = '4J Diploma'
		)
	 --and schedule_status = 'Completed'
	 --and getdate() between SCHEDULE_START_DATE and SCHEDULE_END_DATE
	 --AND (domain_grade_code.domain_alternate_decode IN ('P1', 'PK', 'K', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', 'TR'))
	 AND (dtbl_schools.school_key IN (1, 133, 2, 2509, 41, 4, 1032, 40, 68, 3659, 37, 5, 202, 42, 49, 7, 1043, 3680, 3681, 45, 3677, 3685, 10, 69, 12, 3663, 3657, 15, 16, 64, 50, 1041, 47, 52, 17, 19, 62, 21, 67, 33, 3655, 2600, 1149, 1349, 1599, 1669, 1031, 55, 116, 61, 22, 23, 3656, 35, 36, 1001, 2604, 25, 26, 129, 27, 3661, 3672, 3673, 59, 48, 31, 44, 3662, 3679, 3664, 2612))
	 AND (1=1)
	 --AND (1=1) and (course_name like ('%AP %') or  course_name like ('% IB %') or  course_name like ('%IB %'))
	 --and FLAG_AVID = 'Y'
	 and school_name not like ('Eugene%')
	 --AND DTBL_SCALES.SCALE_ABBREVIATION not IN ('D','F','NP','WF','I', 'NrPr','NtPr')
     --and dtbl_student_annual_attribs.STUDENT_ANNUAL_GRADE_CODE in ('12') 
     
     
GROUP BY
	dtbl_schools.school_name,
    --DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_GRADE_CODE,
    dtbl_students.STUDENT_CURRENT_GRADE_CODE, 
    ftbl_student_schedules.STUDENT_KEY
    

order by
    dtbl_schools.school_name,
    --DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_GRADE_CODE
    dtbl_students.STUDENT_CURRENT_GRADE_CODE
--    MARK_CREDIT_VALUE_EARNED,
--	MARK_CREDIT_VALUE_ATTEMPTED 
--    SCHEDULE_STATUS,
--	dtbl_courses.course_name
--having 
--sum(MARK_CREDIT_VALUE_EARNED) = sum(MARK_CREDIT_VALUE_ATTEMPTED) --passed all classes
--case when STUDENT_ANNUAL_GRADE_CODE = '09' then sum(MARK_CREDIT_VALUE_EARNED) end >= 6  --met grade credit requirements
--and case when STUDENT_ANNUAL_GRADE_CODE = '10' then sum(MARK_CREDIT_VALUE_EARNED) end >= 6
--and case when STUDENT_ANNUAL_GRADE_CODE = '11' then sum(MARK_CREDIT_VALUE_EARNED) end >= 6
--case when STUDENT_ANNUAL_GRADE_CODE = '12' then sum(MARK_CREDIT_VALUE_EARNED) end >= 24

--)p
--group by school_name, grade
--)
--SELECT *
----select *
--FROM
--   credits
--   PIVOT (max(stu_key) FOR grade IN ([09],[10],[11],[12])  
--   
--)P
--group by school_name, P.[09],P.[10],P.[11],P.[12]
--order by school_name--, grade
	go


--AVID eligible
SELECT
	distinct ftbl_student_schedules.STUDENT_KEY
FROM
	 K12INTEL_DW.FTBL_STUDENT_SCHEDULES WITH (NOLOCK)
                              INNER JOIN K12INTEL_DW.DTBL_COURSE_OFFERINGS WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.COURSE_OFFERINGS_KEY = DTBL_COURSE_OFFERINGS.COURSE_OFFERINGS_KEY
                              INNER JOIN K12INTEL_DW.DTBL_SCHOOLS WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.SCHOOL_KEY = DTBL_SCHOOLS.SCHOOL_KEY
                              INNER JOIN K12INTEL_DW.DTBL_SCHOOL_DATES WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.SCHOOL_DATES_KEY = DTBL_SCHOOL_DATES.SCHOOL_DATES_KEY
                              INNER JOIN K12INTEL_DW.DTBL_STUDENTS WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.STUDENT_KEY = DTBL_STUDENTS.STUDENT_KEY
                              INNER JOIN K12INTEL_DW.FTBL_STUDENT_MARKS WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.STUDENT_SCHEDULES_KEY = FTBL_STUDENT_MARKS.STUDENT_SCHEDULES_KEY
                              INNER JOIN K12INTEL_DW.DTBL_SCALES WITH (NOLOCK) ON DTBL_SCALES.SCALE_KEY = FTBL_STUDENT_MARKS.SCALE_KEY
                              INNER JOIN K12INTEL_DW.DTBL_COURSES WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.COURSE_KEY = DTBL_COURSES.COURSE_KEY
                              INNER JOIN K12INTEL_USERDATA.XTBL_DOMAIN_DECODES DOMAIN_GRADE_CODE WITH (NOLOCK) ON DOMAIN_GRADE_CODE.DOMAIN_NAME = 'GRADE_CODE' AND DOMAIN_GRADE_CODE.DOMAIN_CODE = DTBL_STUDENTS.STUDENT_CURRENT_GRADE_CODE
		
WHERE
	--(getdate() < schedule_end_date and getdate() > schedule_start_date		AND COURSE_SUBJECT NOT IN('@ERR','--')
	--	)
	 --AND (DTBL_STUDENTS.STUDENT_ACTIVITY_INDICATOR = 'ACTIVE')
	 DTBL_SCHOOL_DATES. local_school_year = '2019-2020'
	 and schedule_start_date > = '9/5/2019 12:00:00 AM'
	 and schedule_end_date < = '6/30/2020 12:00:00 AM'
	 and (course_name like ('%AVID%') or course_subject like ('%AVID%'))
	 AND dtbl_schools.district_code = '2082'  
         AND DTBL_SCALES.SCALE_ABBREVIATION not IN ('D','F','NP','WF','I', 'NrPr','NtPr')
	 and course_name <> ('AVID Lite')                  
	 
go



--AVID secondary
SELECT count(Distinct dtbl_students.student_id),
dtbl_schools.school_name AS "C788",
	case when domain_grade_code.domain_alternate_decode in ('12','13','14','TR') then '12' else domain_grade_code.domain_alternate_decode end
    
FROM
	K12INTEL_DW.DTBL_STUDENTS WITH (NOLOCK)
	    INNER JOIN K12INTEL_DW.FTBL_STUDENT_SCHEDULES WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.STUDENT_KEY = DTBL_STUDENTS.STUDENT_KEY
	    INNER JOIN K12INTEL_DW.DTBL_COURSES WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.COURSE_KEY = DTBL_COURSES.COURSE_KEY 
	    INNER JOIN K12INTEL_DW.DTBL_COURSE_OFFERINGS WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.COURSE_OFFERINGS_KEY = DTBL_COURSE_OFFERINGS.COURSE_OFFERINGS_KEY
	    INNER JOIN K12INTEL_DW.DTBL_SCHOOL_DATES sd WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.SCHOOL_DATES_KEY = sd.SCHOOL_DATES_KEY
	    inner join dbo.ESD_UDStu stu on stu.sis_number = dtbl_students.student_id
		INNER JOIN K12INTEL_DW.DTBL_SCHOOLS WITH (NOLOCK) ON DTBL_STUDENTS.SCHOOL_KEY = DTBL_SCHOOLS.SCHOOL_KEY
		INNER JOIN K12INTEL_DW.DTBL_STUDENT_ATTRIBS WITH (NOLOCK) ON DTBL_STUDENTS.STUDENT_ATTRIB_KEY =  DTBL_STUDENT_ATTRIBS .STUDENT_ATTRIB_KEY
		INNER JOIN K12INTEL_DW.DTBL_STUDENT_DETAILS WITH (NOLOCK) ON DTBL_STUDENT_DETAILS.STUDENT_KEY = DTBL_STUDENTS.STUDENT_KEY
		INNER JOIN K12INTEL_USERDATA.XTBL_DOMAIN_DECODES DOMAIN_GRADE_CODE WITH (NOLOCK) ON DOMAIN_GRADE_CODE.DOMAIN_NAME = 'GRADE_CODE' AND DOMAIN_GRADE_CODE.DOMAIN_CODE = DTBL_STUDENTS.STUDENT_CURRENT_GRADE_CODE

WHERE
	(dtbl_schools.school_grades_group <> 'Administrative'
	and dtbl_schools.school_key not in ('2600','3655'))
	-- and dtbl_students.STUDENT_FOODSERVICE_INDICATOR = 'yes'
    and dtbl_students.student_activity_indicator = 'Active'
    --and flag_ell = 'y' 
    and  flag_migrant_ed = 'y' 
	 AND (dtbl_schools.school_key IN (1, 133, 2, 2509, 41, 4, 1032, 40, 68, 3659, 37, 5, 202, 42, 49, 7, 1043, 3680, 3681, 45, 3677, 3685, 10, 69, 12, 3663, 3657, 15, 16, 64, 50, 1041, 47, 52, 17, 19, 62, 21, 67, 33, 3655, 2600, 1149, 1349, 1599, 1669, 1031, 55, 116, 61, 22, 23, 3656, 35, 36, 1001, 2604, 25, 26, 129, 27, 3661, 3672, 3673, 59, 48, 31, 44, 3662, 3679, 3664, 2612))
	 AND (domain_grade_code.domain_alternate_decode IN ('P1', 'PK', 'K', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', 'TR'))
	 
     AND (dtbl_schools.school_key IN (37,33,35,36,4,15,16,21,25,133,17,23)) 
     and sd.LOCAL_SCHOOL_YEAR = '2019-2020'
     and course_name like ('%AVID%')
 
 GROUP BY
	dtbl_schools.SCHOOL_GRADES_GROUP,
	dtbl_schools.school_name,
	case when domain_grade_code.domain_alternate_decode in ('12','13','14','TR') then '12' else domain_grade_code.domain_alternate_decode end
	
	
 ORDER BY
	dtbl_schools.SCHOOL_GRADES_GROUP,
	dtbl_schools.school_name,
	case when domain_grade_code.domain_alternate_decode in ('12','13','14','TR') then '12' else domain_grade_code.domain_alternate_decode end
go

--Attendance
SELECT
    dtbl_schools.school_name,
	sum(ftbl_attendance.attendance_value)/cast(count(ftbl_attendance.attendance_key) as decimal(18,4)) AS [att%]
FROM
	K12INTEL_DW.FTBL_ATTENDANCE WITH (NOLOCK)
	INNER JOIN K12INTEL_DW.DTBL_STUDENTS WITH (NOLOCK) ON FTBL_ATTENDANCE.STUDENT_KEY = DTBL_STUDENTS.STUDENT_KEY
	inner join dbo.ESD_UDStu on ESD_UDStu.sis_number = dtbl_students.student_id
	INNER JOIN K12INTEL_DW.DTBL_STUDENT_ATTRIBS WITH (NOLOCK) ON DTBL_STUDENTS.STUDENT_ATTRIB_KEY = DTBL_STUDENT_ATTRIBS.STUDENT_ATTRIB_KEY
	INNER JOIN K12INTEL_DW.DTBL_STUDENT_ANNUAL_ATTRIBS WITH (NOLOCK) ON (FTBL_ATTENDANCE.STUDENT_ANNUAL_ATTRIBS_KEY = DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_ATTRIBS_KEY) 
	INNER JOIN K12INTEL_DW.DTBL_SCHOOLS WITH (NOLOCK) ON FTBL_ATTENDANCE.SCHOOL_KEY = DTBL_SCHOOLS.SCHOOL_KEY
	INNER JOIN K12INTEL_DW.DTBL_SCHOOLS CURRENT_SCHOOL WITH (NOLOCK) ON DTBL_STUDENTS.SCHOOL_KEY = CURRENT_SCHOOL.SCHOOL_KEY
	INNER JOIN K12INTEL_DW.DTBL_SCHOOL_DATES WITH (NOLOCK) ON FTBL_ATTENDANCE.SCHOOL_DATES_KEY = DTBL_SCHOOL_DATES.SCHOOL_DATES_KEY
	INNER JOIN K12INTEL_DW.DTBL_CALENDAR_DATES WITH (NOLOCK) ON FTBL_ATTENDANCE.CALENDAR_DATE_KEY = DTBL_CALENDAR_DATES.CALENDAR_DATE_KEY
	INNER JOIN K12INTEL_USERDATA.XTBL_DOMAIN_DECODES DOMAIN_GRADE_CODE WITH (NOLOCK) ON DOMAIN_GRADE_CODE.DOMAIN_NAME = 'GRADE_CODE' AND DOMAIN_GRADE_CODE.DOMAIN_CODE = DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_GRADE_CODE
	
	
WHERE
	(
		DTBL_SCHOOL_DATES.LOCAL_SCHOOL_YEAR='2020-2021' 
		and 1=1
	)

	and DTBL_SCHOOLS.school_key in (37,1043,3685,33,35,36) --traditional high
    --and DTBL_SCHOOLS.school_key in (133,15,16,4,17,21,23,25) --traditional middle
	AND (
		dtbl_students.student_current_grade_code IN ('P1', 'PK', 'K', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', 'TR')
	)
	and flag_avid = 'y'
group by 
dtbl_schools.school_name
order by 
dtbl_schools.school_name
go

select distinct CTEScndryCrsNm from dbo.CTE_course_2020_21
go


--Historical course enrollment
select 
distinct 
DTBL_SCHOOLS.SCHOOL_NAME,
DTBL_STUDENTS.student_current_grade_code,
--count(distinct CTEScndryCrsNm)
--count(distinct dtbl_courses.course_name)
--CURRENT_SCHOOLS,
dtbl_courses.course_name,
count(distinct dtbl_students.student_key)

FROM
	K12INTEL_DW.FTBL_STUDENT_SCHEDULES WITH (NOLOCK) 
		INNER JOIN K12INTEL_DW.DTBL_COURSE_OFFERINGS WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.COURSE_OFFERINGS_KEY = DTBL_COURSE_OFFERINGS.COURSE_OFFERINGS_KEY
		INNER JOIN K12INTEL_DW.DTBL_SCHOOLS WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.SCHOOL_KEY = DTBL_SCHOOLS.SCHOOL_KEY
		INNER JOIN K12INTEL_DW.DTBL_SCHOOL_DATES WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.SCHOOL_DATES_KEY = DTBL_SCHOOL_DATES.SCHOOL_DATES_KEY
		INNER JOIN K12INTEL_DW.DTBL_STAFF WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.STAFF_KEY = DTBL_STAFF.STAFF_KEY
		INNER JOIN K12INTEL_DW.DTBL_STUDENTS WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.STUDENT_KEY = DTBL_STUDENTS.STUDENT_KEY 
		inner join dbo.ESD_UDStu WITH (NOLOCK) ON ESD_UDStu.sis_number = DTBL_STUDENTS.STUDENT_ID
		INNER JOIN K12INTEL_DW.DTBL_COURSES WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.COURSE_KEY = DTBL_COURSES.COURSE_KEY
		--inner join dbo.CTE_course_2020_21 WITH (NOLOCK) ON CTE_course_2020_21.CTEScndryCrsNm = DTBL_COURSES.course_name
		INNER JOIN K12INTEL_DW.FTBL_STUDENT_MARKS WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.STUDENT_SCHEDULES_KEY = FTBL_STUDENT_MARKS.STUDENT_SCHEDULES_KEY
        INNER JOIN K12INTEL_DW.DTBL_SCALES WITH (NOLOCK) ON DTBL_SCALES.SCALE_KEY = FTBL_STUDENT_MARKS.SCALE_KEY
		INNER JOIN K12INTEL_USERDATA.XTBL_DOMAIN_DECODES DOMAIN_GRADE_CODE WITH (NOLOCK) ON DOMAIN_GRADE_CODE.DOMAIN_NAME = 'GRADE_CODE' AND DOMAIN_GRADE_CODE.DOMAIN_CODE = DTBL_STUDENTS.STUDENT_CURRENT_GRADE_CODE
		INNER JOIN K12INTEL_DW.DTBL_STUDENT_ATTRIBS WITH (NOLOCK) ON DTBL_STUDENTS.STUDENT_ATTRIB_KEY = DTBL_STUDENT_ATTRIBS.STUDENT_ATTRIB_KEY
		INNER JOIN K12INTEL_DW.DTBL_STUDENT_ANNUAL_ATTRIBS WITH (NOLOCK) ON FTBL_STUDENT_SCHEDULES.STUDENT_ANNUAL_ATTRIBS_KEY = DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_ATTRIBS_KEY

WHERE
	dtbl_school_dates.ROLLING_LOCAL_SCHOOL_YR_NUMBER = 0
		--AND dtbl_courses.COURSE_ACADEMIC_LEVEL NOT IN ('@ERR')
		--AND COURSE_TYPE not in ('NA','@ERR')
		AND COURSE_SUBJECT NOT IN('@ERR','--')
		--and course_subject = 'Mathematics'
	 --and schedule_status = 'Active'
	 --AND (1=1) and (course_name like ('%AP %') or  course_name like ('% IB %') or  course_name like ('%IB %'))
	 --and course_name like ('%AP %')
	 --and (course_name like ('% IB %') or  course_name like ('%IB %'))
	 --and course_name like ('%AVID%')
	 --and course_name like ('%Honors%')
	 and course_name like ('%Algebra%')
	 and course_name not like ('%Intermediate Algebra%')
	 and course_name not like ('%Pre-Algebra%')
	 --and student_annual_school = 'Kennedy Middle School'
	 and FLAG_AVID = 'Y'
	 --and getdate() between SCHEDULE_START_DATE and SCHEDULE_END_DATE
	 and DTBL_SCHOOLS.SCHOOL_NAME in ('Arts and Technology Academy','Cal Young Middle School','Kelly Middle School','Kennedy Middle School','Madison Middle School','Monroe Middle School','Roosevelt Middle School','Spencer Butte Middle School')
	 and DTBL_STUDENTS.student_current_grade_code in ('06','07','08') 
	 and dtbl_schools.DISTRICT_CODE = '2082'
	 --and current_schools is not null
	-- AND domain_grade_code.domain_alternate_decode in ( '09', '10', '11', '12', '13', '14', 'TR')
--	 AND (dtbl_schools.school_key IN (1, 133, 2, 2509, 41, 4, 1032, 40, 68, 3659, 37, 5, 202, 42, 49, 7, 1043, 3680, 3681, 45, 3677, 3685, 10, 69, 12, 3663, 3657, 15, 16, 64, 50, 1041, 47, 52, 17, 19, 62, 21, 67, 33, 3655, 2600, 1149, 1349, 1599, 1669, 1031, 55, 116, 61, 22, 23, 3656, 35, 36, 1001, 2604, 25, 26, 129, 27, 3661, 3672, 3673, 59, 48, 31, 44, 3662, 3679, 3664, 2612))
	 --AND dtbl_schools.school_name not like ('Eugene%')
	 --AND (1=1) and (course_name like ('%AP %') or  course_name like ('% IB %') or  course_name like ('%IB %'))
	 --and FLAG_AVID = 'Y'
	 --and school_name not like ('Eugene%')
	 --AND DTBL_SCALES.SCALE_ABBREVIATION not IN ('D','F','NP','WF','I', 'NrPr','NtPr')
	 --and current_schools like ('%SEH%') or  current_schools like ('%NEH%')
group by 
DTBL_SCHOOLS.SCHOOL_NAME,
--CURRENT_SCHOOLS,
dtbl_courses.course_name,
DTBL_STUDENTS.student_current_grade_code
order by 
DTBL_SCHOOLS.SCHOOL_NAME,
DTBL_STUDENTS.student_current_grade_code
--dtbl_courses.course_name
go


SELECT
	STUDENT_ANNUAL_SCHOOL,
	Count(Distinct dtbl_students.student_key)  AS "C765"
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
	DTBL_SCHOOL_DATES_BEGIN_ENROLL.local_school_year = '2020-2021'	
	and flag_avid = 'y'
	--and (STUDENT_ANNUAL_SCHOOL.school_key in (37,1043,3685,33,35,36) --traditional high
    --or STUDENT_ANNUAL_SCHOOL.school_key in (133,15,16,4,17,21,23,25)) --traditional middlle
    and student_annual_school in ('Arts and Technology Academy','Cal Young Middle School','Kelly Middle School','Kennedy Middle School','Madison Middle School','Monroe Middle School','Roosevelt Middle School','Spencer Butte Middle School')
--	AND (
--		dtbl_students.student_current_grade_code IN ('P1', 'PK', 'K', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', 'TR')
--	)
	and DTBL_STUDENT_ANNUAL_ATTRIBS.student_annual_grade_code = '08'

group by 
STUDENT_ANNUAL_SCHOOL

order by 
STUDENT_ANNUAL_SCHOOL
go


--on-track credits
select 
dtbl_schools.school_name, 
--DTBL_STUDENT_ANNUAL_ATTRIBS.student_annual_grade_code,
count(distinct dtbl_students.student_key) as [count]

from 
k12intel_reporting.mtbl_ews_student_summary WITH (NOLOCK)
	          INNER JOIN K12INTEL_DW.DTBL_STUDENTS WITH (NOLOCK) ON mtbl_ews_student_summary.STUDENT_KEY = DTBL_STUDENTS.STUDENT_KEY
	          inner join dbo.ESD_UDStu WITH (NOLOCK) ON ESD_UDStu.sis_number = DTBL_STUDENTS.STUDENT_ID
	          INNER JOIN K12INTEL_DW.DTBL_STUDENT_ATTRIBS WITH (NOLOCK) ON DTBL_STUDENTS.STUDENT_ATTRIB_KEY = DTBL_STUDENT_ATTRIBS.STUDENT_ATTRIB_KEY
	          INNER JOIN K12INTEL_DW.DTBL_STUDENT_ANNUAL_ATTRIBS WITH (NOLOCK) ON (mtbl_ews_student_summary.STUDENT_ANNUAL_ATTRIBS_KEY = DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_ATTRIBS_KEY) 
	          INNER JOIN K12INTEL_DW.DTBL_SCHOOLS WITH (NOLOCK) ON DTBL_STUDENTS.SCHOOL_KEY = DTBL_SCHOOLS.SCHOOL_KEY   
	          INNER JOIN K12INTEL_DW.DTBL_SCHOOLS EWS_SCHOOL WITH (NOLOCK) ON mtbl_ews_student_summary.SCHOOL_KEY = EWS_SCHOOL.SCHOOL_KEY   
	          INNER JOIN K12INTEL_USERDATA.XTBL_DOMAIN_DECODES DOMAIN_GRADE_CODE WITH (NOLOCK) ON DOMAIN_GRADE_CODE.DOMAIN_NAME = 'GRADE_CODE' AND DOMAIN_GRADE_CODE.DOMAIN_CODE = DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_GRADE_CODE
	          INNER JOIN K12INTEL_USERDATA.XTBL_DOMAIN_DECODES DOMAIN_GRADE_CURRENT WITH (NOLOCK) ON DOMAIN_GRADE_CURRENT.DOMAIN_NAME = 'GRADE_CODE' AND DOMAIN_GRADE_CURRENT.DOMAIN_CODE = DTBL_STUDENTS.STUDENT_CURRENT_GRADE_CODE

where 
total_credits >= on_track_credits
and mtbl_ews_student_summary.school_year = '2021-2022'
and dtbl_schools.school_name in ('Churchill High School','Sheldon High School','North Eugene High School','South Eugene High School')
and flag_avid = 'y'
group by
dtbl_schools.school_name
--DTBL_STUDENT_ANNUAL_ATTRIBS.student_annual_grade_code
order by
dtbl_schools.school_name 
--DTBL_STUDENT_ANNUAL_ATTRIBS.student_annual_grade_code
go

--elementary AVID
--with piv as(
SELECT
	dtbl_schools.school_name school,
--	case when dtbl_students.student_race = 'Hispanic' then 'Hispanic or Latino'
--	when dtbl_students.student_race = 'Native American' then 'American Indian or Alaska Native'
--	when dtbl_students.student_race = 'Black/African American' then 'Black or African American'
--	when dtbl_students.student_race = 'Pacific Islander' then 'Native Hawaiian or Other Pacific Islander'
--	when dtbl_students.student_race = 'White' then 'White (not Hispanic)'
--	when dtbl_students.student_race = 'Multiple' then 'Two or more races'
--	else 'Asian' end race,
    --dtbl_students.STUDENT_CURRENT_GRADE_CODE grade,
	--case when dtbl_students.student_gender in ('Male','Female') then dtbl_students.student_gender else 'Non-binary' end gender,
	Count(Distinct dtbl_students.student_key) AS [count]
	
FROM
	K12INTEL_DW.FTBL_ENROLLMENTS WITH (NOLOCK)
	INNER JOIN K12INTEL_DW.DTBL_STUDENTS WITH (NOLOCK) ON FTBL_ENROLLMENTS.STUDENT_KEY = DTBL_STUDENTS.STUDENT_KEY
	inner join dbo.ESD_UDStu WITH (NOLOCK) ON ESD_UDStu.sis_number = DTBL_STUDENTS.STUDENT_ID
	inner join dbo.frm_11_8_21 WITH (NOLOCK) ON cast(frm_11_8_21.[sis number] as varchar(150)) = DTBL_STUDENTS.student_id
	INNER JOIN K12INTEL_DW.DTBL_STUDENT_ANNUAL_ATTRIBS WITH (NOLOCK) ON FTBL_ENROLLMENTS.STUDENT_ANNUAL_ATTRIBS_KEY = DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_ATTRIBS_KEY
	INNER JOIN K12INTEL_DW.DTBL_SCHOOLS WITH (NOLOCK) ON FTBL_ENROLLMENTS.SCHOOL_KEY = DTBL_SCHOOLS.SCHOOL_KEY
	INNER JOIN K12INTEL_DW.DTBL_SCHOOL_DATES DTBL_SCHOOL_DATES_BEGIN_ENROLL WITH (NOLOCK) ON FTBL_ENROLLMENTS.SCHOOL_DATES_KEY_BEGIN_ENROLL = DTBL_SCHOOL_DATES_BEGIN_ENROLL.SCHOOL_DATES_KEY
	INNER JOIN K12INTEL_DW.DTBL_SCHOOL_DATES DTBL_SCHOOL_DATES_END_ENROLL WITH (NOLOCK) ON FTBL_ENROLLMENTS.SCHOOL_DATES_KEY_END_ENROLL = DTBL_SCHOOL_DATES_END_ENROLL.SCHOOL_DATES_KEY
	INNER JOIN K12INTEL_DW.DTBL_CALENDAR_DATES WITH (NOLOCK) ON FTBL_ENROLLMENTS.CAL_DATE_KEY_BEGIN_ENROLL = DTBL_CALENDAR_DATES.CALENDAR_DATE_KEY
	INNER JOIN K12INTEL_USERDATA.XTBL_DOMAIN_DECODES DOMAIN_GRADE_CODE WITH (NOLOCK) ON DOMAIN_GRADE_CODE.DOMAIN_NAME = 'GRADE_CODE' AND DOMAIN_GRADE_CODE.DOMAIN_CODE = DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_GRADE_CODE
	
	
WHERE
	(
		getdate() between DTBL_SCHOOL_DATES_BEGIN_ENROLL.date_value 
		and DTBL_SCHOOL_DATES_END_ENROLL.date_value
	)
	AND (
		DTBL_STUDENTS.STUDENT_ACTIVITY_INDICATOR = 'ACTIVE'
	)
	AND (
		dtbl_students.student_current_grade_code IN ('P1', 'PK', 'K', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', 'TR')
	)
	AND (
		dtbl_schools.school_key IN (1, 133, 2, 2509, 41, 4, 1032, 40, 68, 3659, 37, 5, 202, 49, 7, 1043, 3679, 3680, 3681, 45, 3677, 3685, 10, 69, 12, 3686, 3663, 3657, 15, 16, 64, 50, 1041, 47, 52, 17, 19, 62, 21, 67, 33, 3655, 2600, 1149, 1349, 1599, 1669, 1031, 55, 116, 61, 22, 23, 3656, 35, 36, 1001, 2604, 25, 26, 129, 27, 3661, 3672, 3673, 59, 48, 31, 44, 3662, 42, 3664, 2612)
	)
	and dtbl_schools.school_key in (1,2,41,7,1032,3659,10,12,19,22,26,27,31,40,44,45,49,68,69)
	and dtbl_schools.school_key in (2,68,19,26,27,7)
GROUP BY
	dtbl_schools.school_name
	--case when dtbl_students.student_gender in ('Male','Female') then dtbl_students.student_gender else 'Non-binary' end,
--	case when dtbl_students.student_race = 'Hispanic' then 'Hispanic or Latino'
--	when dtbl_students.student_race = 'Native American' then 'American Indian or Alaska Native'
--	when dtbl_students.student_race = 'Black/African American' then 'Black or African American'
--	when dtbl_students.student_race = 'Pacific Islander' then 'Native Hawaiian or Other Pacific Islander'
--	when dtbl_students.student_race = 'White' then 'White (not Hispanic)'
--	when dtbl_students.student_race = 'Multiple' then 'Two or more races'
--	else 'Asian' end 
    --dtbl_students.student_current_grade_code
--)
--SELECT *
--FROM
--   piv
--   PIVOT (max([count]) FOR gender IN ([Male],[Female],[Non-binary])  
--)P
-- order by
-- school,
-- case when grade = 'KG' then '1' 
-- when grade = '01' then '2' 
-- when grade = '02' then '3' 
-- when grade = '03' then '4' 
-- when grade = '04' then '5' 
-- when grade = '05' then '6' end
 
-- case when race = 'Hispanic or Latino' then 1
-- when race = 'American Indian or Alaska Native' then 2
-- when race = 'Asian' then 3
-- when race = 'Black or African American' then 4
-- when race = 'Native Hawaiian or Other Pacific Islander' then 5
-- when race = 'White (not Hispanic)' then 6
-- when race = 'Two or more races' then 7 end
 
 go
  
  
 

