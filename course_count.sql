--we're mostly looking at demographics (gender, race, SPED, ELD) and D's/F's for 9th -11th science courses. 
SELECT --distinct
    sum(CASE WHEN dtbl_scales.scale_abbreviation in ('D','F','I','WF','NP','NrPr','NtPr') THEN 1.0 ELSE 0.0 END) [# D/F],
     --/ 
     count(distinct dtbl_students.student_key) [# enrolled],
    dtbl_school_dates.local_school_year AS [year],
    dtbl_school_dates.local_semester [semester],
--	dtbl_schools.school_name school,
	--dtbl_students.student_gender gender,
	flag_sped,
	--dtbl_students.student_race,
	DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_GRADE_CODE [student_grade],
--	flag_sped,
--	flag_ell,
	case when course_name like 'AP Environ%' then 'AP Environ'
	when course_name like 'AP Physics%' then 'AP Physics'
	when course_name like 'IB Physics%' then 'IB Physics'
	when course_name like 'AP Biology%' then 'AP Biology'
	when course_name like 'IB Biology%' then 'IB Biology'
	when course_name like 'IB Environ Systems%' then 'IB Environ Systems'
	when course_name like 'AP Chemistry%' then 'AP Chemistry' 
	when course_name like 'IB Chemistry%' then 'IB Chemistry' 
	when course_name like 'Science 6%' then 'Science 6'
	when course_name like 'Science 7%' then 'Science 7'
	when course_name like 'Science 8%' then 'Science 8'
	when course_name like 'FE CR Physical Science%' then 'FE CR Physical Science'
	when course_name like 'FE Earth Science%' then 'FE Earth Science'
	when course_name like 'FE Biology%' then 'FE Biology'
	when course_name like 'FE Chemistry%' then 'FE Chemistry'
	when course_name like 'FE Physics%' then 'FE Physics'
	when course_name like 'FE Biology%' then 'FE Biology'
	when course_name like 'Anat & Physiology CN%' then 'Anat & Physiology CN'
	when course_name like 'Botany - Horticulture%' then 'Botany - Horticulture'
	when course_name like 'Chemistry%' then 'Chemistry'
	when course_name like 'Physics%' then 'Physics'
	when course_name like 'Basic Science Foundations%' then 'Basic Science Foundations'
	when course_name like 'RC Field Studies%' then 'RC Field Studies'
    when course_name like 'RC Field Studies-%-CTE%' then 'RC Field Studies-CTE'
    when course_name like 'Basic Science Foundations%' then 'Basic Science Foundations'
	when course_name like 'Biology Foundations%' then 'Biology Foundations'
	when course_name like 'Basic Biology%' then 'Basic Biology'
	when course_name like 'Chemistry CN%' then 'Chemistry CN'
	when course_name like 'Chemistry Found - A%' then 'Chemistry Found'
	when course_name like 'Biology Foundations%' then 'Biology Foundations'
	when course_name like 'Physics%' then 'Physics'
	when course_name like 'Physics Foundations%' then 'Physics Foundations'
	when course_name like 'Eng/Des Lab: UAS-%-CTE%' then 'Eng/Des Lab: UAS-CTE'
	when course_name like 'Adv UAS Ops-%-CTE%' then 'Adv UAS Ops-CTE'
	when course_name like 'Physics%' then 'Physics'
	when course_name like 'Life Sciences%' then 'Life Sciences'
	when course_name like 'Principles of Engr - % CTE%' then 'Principles of Engr-CTE'
	when course_name like 'FE CR Biology%' then 'FE CR Biology'
	when course_name like 'Science Projects%' then 'Science Projects'
	else course_name end [course]
--	case when scale_code like '%A%' then 'A' when scale_code like '%B%' then 'B' when scale_code like '%C%' then 'C'
--	when scale_code like '%D%' then 'D' when scale_code like '%F%' then 'F' else scale_code end,
	--course_name AS course,
	--count(distinct ftbl_student_schedules.STUDENT_KEY) AS [count]
	--ftbl_student_schedules.STUDENT_KEY
FROM
	K12INTEL_DW.FTBL_STUDENT_MARKS WITH (NOLOCK)
	INNER JOIN K12INTEL_DW.DTBL_STUDENTS WITH (NOLOCK) ON FTBL_STUDENT_MARKS.STUDENT_KEY = DTBL_STUDENTS.STUDENT_KEY
	inner join dbo.ESD_UDStu on ESD_UDStu.sis_number = dtbl_students.student_id
	inner join dbo.ESD_StudentDataWall on DTBL_STUDENTS.student_key = ESD_StudentDataWall.student_key
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
	( 1=1
		and dtbl_school_dates.ROLLING_LOCAL_SCHOOL_YR_NUMBER >= -4
		--AND dtbl_courses.COURSE_ACADEMIC_LEVEL NOT IN ('@ERR')
		--AND COURSE_TYPE not in ('NA','@ERR')
		AND COURSE_SUBJECT NOT IN('@ERR','--')
		--and schedule_status <> 'Dropped'
		and dtbl_school_dates.local_semester <> 0
		and dtbl_courses.course_subject = 'Science'
	    --AND (1=1) and (course_name like ('%AP %') or  course_name like ('% IB %') or  course_name like ('%IB %'))
	    and FTBL_STUDENT_MARKS.MARK_TYPE = 'final'
	    --and scale_abbreviation in ('A','B','C','D','F','HiPr','I','NP','NrPr','NtPr','P','Prof')
	)
	AND (
		DTBL_STUDENT_ANNUAL_ATTRIBS.student_annual_grade_code IN ('07','08','09', '10', '11')
	)
--	AND (
--		dtbl_students.student_current_grade_code IN ('P1', 'PK', 'K', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', 'TR')
--	)
	
--	AND (
--		dtbl_schools.school_key IN (1, 133, 2, 2509, 41, 4, 1032, 40, 68, 3659, 37, 5, 202, 49, 7, 1043, 3679, 3680, 3681, 45, 3677, 3685, 10, 69, 12, 3686, 3663, 3657, 15, 16, 64, 50, 1041, 47, 52, 17, 19, 62, 21, 67, 33, 3655, 2600, 1149, 1349, 1599, 1669, 1031, 55, 116, 61, 22, 23, 3656, 35, 36, 1001, 2604, 25, 26, 129, 27, 3661, 3672, 3673, 59, 48, 31, 44, 3662, 42, 3664, 2612)
--	)
    and dtbl_schools.school_key 
    in (37,33,35,36,133,15,16,4,17,21,23,25)
    
GROUP BY
--	dtbl_schools.school_name,
--	COURSE_CODE,
    dtbl_school_dates.local_school_year,
    dtbl_school_dates.local_semester,
    --dtbl_students.student_race,
    --dtbl_students.student_gender,
    flag_sped,
    DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_GRADE_CODE,
--	dtbl_students.student_gender,
--	--course_name
	case when course_name like 'AP Environ%' then 'AP Environ'
	when course_name like 'AP Physics%' then 'AP Physics'
	when course_name like 'IB Physics%' then 'IB Physics'
	when course_name like 'AP Biology%' then 'AP Biology'
	when course_name like 'IB Biology%' then 'IB Biology'
	when course_name like 'IB Environ Systems%' then 'IB Environ Systems'
	when course_name like 'AP Chemistry%' then 'AP Chemistry' 
	when course_name like 'IB Chemistry%' then 'IB Chemistry' 
	when course_name like 'Science 6%' then 'Science 6'
	when course_name like 'Science 7%' then 'Science 7'
	when course_name like 'Science 8%' then 'Science 8'
	when course_name like 'FE CR Physical Science%' then 'FE CR Physical Science'
	when course_name like 'FE Earth Science%' then 'FE Earth Science'
	when course_name like 'FE Biology%' then 'FE Biology'
	when course_name like 'FE Chemistry%' then 'FE Chemistry'
	when course_name like 'FE Physics%' then 'FE Physics'
	when course_name like 'FE Biology%' then 'FE Biology'
	when course_name like 'Anat & Physiology CN%' then 'Anat & Physiology CN'
	when course_name like 'Botany - Horticulture%' then 'Botany - Horticulture'
	when course_name like 'Chemistry%' then 'Chemistry'
	when course_name like 'Physics%' then 'Physics'
	when course_name like 'Basic Science Foundations%' then 'Basic Science Foundations'
	when course_name like 'RC Field Studies%' then 'RC Field Studies'
    when course_name like 'RC Field Studies-%-CTE%' then 'RC Field Studies-CTE'
    when course_name like 'Basic Science Foundations%' then 'Basic Science Foundations'
	when course_name like 'Biology Foundations%' then 'Biology Foundations'
	when course_name like 'Basic Biology%' then 'Basic Biology'
	when course_name like 'Chemistry CN%' then 'Chemistry CN'
	when course_name like 'Chemistry Found - A%' then 'Chemistry Found'
	when course_name like 'Biology Foundations%' then 'Biology Foundations'
	when course_name like 'Physics%' then 'Physics'
	when course_name like 'Physics Foundations%' then 'Physics Foundations'
	when course_name like 'Eng/Des Lab: UAS-%-CTE%' then 'Eng/Des Lab: UAS-CTE'
	when course_name like 'Adv UAS Ops-%-CTE%' then 'Adv UAS Ops-CTE'
	when course_name like 'Physics%' then 'Physics'
	when course_name like 'Life Sciences%' then 'Life Sciences'
	when course_name like 'Principles of Engr - % CTE%' then 'Principles of Engr-CTE'
	when course_name like 'FE CR Biology%' then 'FE CR Biology'
	when course_name like 'Science Projects%' then 'Science Projects'
	else course_name end
ORDER BY
--	dtbl_school_dates.local_school_year,
--	dtbl_schools.school_name,
	--dtbl_students.student_race,
	--dtbl_students.student_gender,
	--DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_GRADE_CODE,
    case when course_name like 'AP Environ%' then 'AP Environ'
	when course_name like 'AP Physics%' then 'AP Physics'
	when course_name like 'IB Physics%' then 'IB Physics'
	when course_name like 'AP Biology%' then 'AP Biology'
	when course_name like 'IB Biology%' then 'IB Biology'
	when course_name like 'IB Environ Systems%' then 'IB Environ Systems'
	when course_name like 'AP Chemistry%' then 'AP Chemistry' 
	when course_name like 'IB Chemistry%' then 'IB Chemistry' 
	when course_name like 'Science 6%' then 'Science 6'
	when course_name like 'Science 7%' then 'Science 7'
	when course_name like 'Science 8%' then 'Science 8'
	when course_name like 'FE CR Physical Science%' then 'FE CR Physical Science'
	when course_name like 'FE Earth Science%' then 'FE Earth Science'
	when course_name like 'FE Biology%' then 'FE Biology'
	when course_name like 'FE Chemistry%' then 'FE Chemistry'
	when course_name like 'FE Physics%' then 'FE Physics'
	when course_name like 'FE Biology%' then 'FE Biology'
	when course_name like 'Anat & Physiology CN%' then 'Anat & Physiology CN'
	when course_name like 'Botany - Horticulture%' then 'Botany - Horticulture'
	when course_name like 'Chemistry%' then 'Chemistry'
	when course_name like 'Physics%' then 'Physics'
	when course_name like 'Basic Science Foundations%' then 'Basic Science Foundations'
	when course_name like 'RC Field Studies%' then 'RC Field Studies'
    when course_name like 'RC Field Studies-%-CTE%' then 'RC Field Studies-CTE'
    when course_name like 'Basic Science Foundations%' then 'Basic Science Foundations'
	when course_name like 'Biology Foundations%' then 'Biology Foundations'
	when course_name like 'Basic Biology%' then 'Basic Biology'
	when course_name like 'Chemistry CN%' then 'Chemistry CN'
	when course_name like 'Chemistry Found - A%' then 'Chemistry Found'
	when course_name like 'Biology Foundations%' then 'Biology Foundations'
	when course_name like 'Physics%' then 'Physics'
	when course_name like 'Physics Foundations%' then 'Physics Foundations'
	when course_name like 'Eng/Des Lab: UAS-%-CTE%' then 'Eng/Des Lab: UAS-CTE'
	when course_name like 'Adv UAS Ops-%-CTE%' then 'Adv UAS Ops-CTE'
	when course_name like 'Physics%' then 'Physics'
	when course_name like 'Life Sciences%' then 'Life Sciences'
	when course_name like 'Principles of Engr - % CTE%' then 'Principles of Engr-CTE'
	when course_name like 'FE CR Biology%' then 'FE CR Biology'
	when course_name like 'Science Projects%' then 'Science Projects'
	else course_name end,
	--dtbl_students.student_race
	--dtbl_students.student_gender
	flag_sped
	
	go