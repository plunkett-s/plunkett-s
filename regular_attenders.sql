SELECT  * FROM dbo.regular_attenders_2016_17_to_2018_19_detail DET
inner join K12INTEL_DW.DTBL_STUDENT_DETAILS WITH (NOLOCK) ON DTBL_STUDENT_DETAILS.STUDENT_STATE_ID = det.ssid
inner join K12INTEL_DW.DTBL_STUDENTs WITH (NOLOCK) ON DTBL_STUDENTS.student_key = DTBL_STUDENT_DETAILS.student_key

where 1=1 
AND DTBL_STUDENTs.SYS_ETL_SOURCE = 'BLD_D_STUDENTS_EDP'
AND included_in_dist_aggregate = 'Y'
AND REPORTING_YEAR = '2018-2019'
GO


select * from 
dbo.Grad_cohort_detail_17_19
go

SELECT 
distinct
--dtbl_students.student_key,
--REPORTING_YR,
--sum(case when grad_type like '%diploma%' then 1.0 else 0 end) grad,
--count(distinct ssid) cnt
det.*
FROM dbo.Grad_cohort_detail_17_19 det
inner join K12INTEL_DW.DTBL_STUDENT_DETAILS WITH (NOLOCK) ON DTBL_STUDENT_DETAILS.STUDENT_STATE_ID = det.ssid
inner join K12INTEL_DW.DTBL_STUDENTs WITH (NOLOCK) ON DTBL_STUDENTS.student_key = DTBL_STUDENT_DETAILS.student_key

where 1=1 
AND DTBL_STUDENTs.SYS_ETL_SOURCE = 'BLD_D_STUDENTS_EDP'
and accountable_school_name = 'North Eugene High School'
and rate_yr = '4YR'
and adj_cohort_inclusion = 'Y'
and DTBL_STUDENTs.SYS_ETL_SOURCE = (SELECT MAX(t2.SYS_ETL_SOURCE)
                 FROM K12INTEL_DW.DTBL_STUDENTs t2
                 WHERE t2.student_key = DTBL_STUDENTs.student_key)
and 
--GROUP BY 
--REPORTING_YR
--dtbl_students.student_key

ORDER BY 
REPORTING_YR,
last_name, first_name

GO


select * from dbo.State_reg_att_17_19
go

SELECT 
	reporting_yr AS "C7360",
	Institution AS "C7371",
	percent_regular_attenders * .01 AS "C7361",
	number_regular_attenders AS "C7363"
FROM
	dbo.State_reg_att_17_19
WHERE
	( 1=1
		--student_group in ('All Students')
		and Institution in  ('Eugene SD 4J','State Level')
	)
ORDER BY
	reporting_yr,
	Institution
go

--drop table dbo.State_reg_att_17_19
--go
--ALTER TABLE dbo.State_reg_att_17_19
--drop column institution_type;
--go
--sp_rename 'State_reg_att_17_19.focus_year', 'reporting_yr', 'COLUMN';

select * from dbo.NotChronicallyAbsntSum 
go

select reporting_yr, 
student_group,
percent_regular_attenders
from dbo.NotChronicallyAbsntSum
where 1=1 
and student_group in ('Total','Baseline Target','Reach Target') 
and grade_level = 'Tot'
and institution = 'Eugene SD 4J'
go

--INSERT INTO dbo.NotChronicallyAbsntSum (reporting_yr,Institution_id, Institution,grade_level, student_group, students_included, number_regular_attenders,percent_regular_attenders )
--VALUES 
--('2021-2022', 2082 , 'Eugene SD 4J', 'Tot', 'Baseline Target', NULL,NULL,79),
--('2021-2022', 2082 , 'Eugene SD 4J', 'Tot', 'Reach Target', NULL,NULL,79),
--('2022-2023', 2082 , 'Eugene SD 4J', 'Tot', 'Baseline Target', NULL,NULL,80),
--('2022-2023', 2082 , 'Eugene SD 4J', 'Tot', 'Reach Target', NULL,NULL,82.5),
--('2023-2024', 2082 , 'Eugene SD 4J', 'Tot', 'Baseline Target', NULL,NULL,81),
--('2023-2024', 2082 , 'Eugene SD 4J', 'Tot', 'Reach Target', NULL,NULL,86),
--('2024-2025', 2082 , 'Eugene SD 4J', 'Tot', 'Baseline Target', NULL,NULL,82),
--('2024-2025', 2082 , 'Eugene SD 4J', 'Tot', 'Reach Target', NULL,NULL,89.5),
--('2025-2026', 2082 , 'Eugene SD 4J', 'Tot', 'Baseline Target', NULL,NULL,83),
--('2025-2026', 2082 , 'Eugene SD 4J', 'Tot', 'Reach Target', NULL,NULL,93)
--;
--go
go


SELECT
	 AS "C8587",
	count(distinct ftbl_discipline.discipline_key) AS "C810",
	dtbl_school_dates.local_school_year AS "C821"
FROM
	K12INTEL_DW.FTBL_DISCIPLINE WITH (NOLOCK) 
	INNER JOIN K12INTEL_DW.DTBL_STUDENTS WITH (NOLOCK) ON FTBL_DISCIPLINE.STUDENT_KEY = DTBL_STUDENTS.STUDENT_KEY
	inner join dbo.ESD_UDStu on ESD_UDStu.sis_number = dtbl_students.student_id
	INNER JOIN K12INTEL_DW.FTBL_DISCIPLINE_ACTIONS WITH (NOLOCK) ON FTBL_DISCIPLINE_ACTIONS.DISCIPLINE_KEY = FTBL_DISCIPLINE.DISCIPLINE_KEY
	INNER JOIN K12INTEL_DW.FTBL_DISCIPLINE_OFFENSES WITH (NOLOCK) ON FTBL_DISCIPLINE_OFFENSES.DISCIPLINE_KEY = FTBL_DISCIPLINE.DISCIPLINE_KEY
	INNER JOIN K12INTEL_DW.DTBL_STUDENT_ATTRIBS WITH (NOLOCK) ON DTBL_STUDENTS.STUDENT_ATTRIB_KEY = DTBL_STUDENT_ATTRIBS.STUDENT_ATTRIB_KEY 
	INNER JOIN K12INTEL_DW.DTBL_STUDENT_ANNUAL_ATTRIBS WITH (NOLOCK) ON FTBL_DISCIPLINE.STUDENT_ANNUAL_ATTRIBS_KEY = DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_ATTRIBS_KEY 
	INNER JOIN K12INTEL_DW.DTBL_SCHOOLS WITH (NOLOCK) ON FTBL_DISCIPLINE.SCHOOL_KEY = DTBL_SCHOOLS.SCHOOL_KEY 
	INNER JOIN K12INTEL_DW.DTBL_SCHOOL_DATES WITH (NOLOCK) ON FTBL_DISCIPLINE.SCHOOL_DATES_KEY = DTBL_SCHOOL_DATES.SCHOOL_DATES_KEY 
	INNER JOIN K12INTEL_DW.DTBL_CALENDAR_DATES WITH (NOLOCK) ON FTBL_DISCIPLINE.CALENDAR_DATE_KEY = DTBL_CALENDAR_DATES.CALENDAR_DATE_KEY 
	LEFT JOIN K12INTEL_DW.DTBL_CALENDAR_DATES DTBL_CALENDAR_DATES_EXPECT_RET WITH (NOLOCK)  ON FTBL_DISCIPLINE.DISCIPLINE_EXPECT_RETURN_DATE = DTBL_CALENDAR_DATES_EXPECT_RET.DATE_VALUE  AND DTBL_CALENDAR_DATES_EXPECT_RET.SYS_DUMMY_IND = 'N'   
	INNER JOIN K12INTEL_DW.DTBL_TIME WITH (NOLOCK) ON K12INTEL_DW.FTBL_DISCIPLINE.TIME_KEY = K12INTEL_DW.DTBL_TIME.TIME_KEY 
	INNER JOIN K12INTEL_USERDATA.XTBL_DOMAIN_DECODES DOMAIN_GRADE_CODE WITH (NOLOCK) ON DOMAIN_GRADE_CODE.DOMAIN_NAME = 'GRADE_CODE' AND DOMAIN_GRADE_CODE.DOMAIN_CODE = DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_GRADE_CODE 
	
	
WHERE
	(
		--dtbl_school_dates.ROLLING_LOCAL_SCHOOL_YR_NUMBER = 0
		ftbl_discipline_offenses.discipline_offense_type not like ('Minor%')
	)
	AND (
		DTBL_SCHOOL_DATES.LOCAL_SCHOOL_YEAR='2021-2022'
	)
	AND (
		1=1 
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
		AND 1=1 
		AND 1=1
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
GROUP BY
	dtbl_school_dates.local_school_year

	go