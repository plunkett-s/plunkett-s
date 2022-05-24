--cast (yr.school_year as varchar(20)) + '-' + cast (yr.school_year + 1 as varchar(20)) school_year,


--[SIS-INSTANCE-1.ad.4j.lane.edu].ST_Production_ESD.

-- Display entire elementary student report card whether filled out or not beginning with the Student record.
select 
distinct --top 100 
--sch.schoolname school_name, 
schyr.schoolyear local_school_year, 
--stu.sis_number sis_number, 
--replace(grd.grade,'Grade ','') grade,
stu.sis_number,
STU.STATE_STUDENT_NUMBER, 
--per.gender student,
rc.reportcard report_card, 
rcitem.item item, 
rcscr.mark mark, 
prd.period semester, 
rcitem.seq seq, 
prd.seq seq2, 
rcscr.dateadded date_added
--sdw.*
--count(*)--,schyr.schoolyear
--count(distinct stu.sis_number)
--into dbo.report_card_scores
from  [SIS-INSTANCE-1.ad.4j.lane.edu].ST_Production_ESD.rev.epc_stu stu
--inner join dbo.ESD_LastEnrollment ele on stu.student_gu = ele.student_gu
inner join [SIS-INSTANCE-1.ad.4j.lane.edu].ST_Production_ESD.rev.REV_PERSON per on stu.STUDENT_GU = per.PERSON_GU
inner join [SIS-INSTANCE-1.ad.4j.lane.edu].ST_Production_ESD.rev.epc_stu_sch_yr ssy on stu.student_gu = ssy.student_gu
inner join [SIS-INSTANCE-1.ad.4j.lane.edu].ST_Production_ESD.rev.rev_year yr on ssy.year_gu = yr.year_gu
inner join [SIS-INSTANCE-1.ad.4j.lane.edu].ST_Production_ESD.rev.REV_ORGANIZATION_YEAR orgy on ssy.ORGANIZATION_YEAR_GU = orgy.ORGANIZATION_YEAR_GU
inner join [SIS-INSTANCE-1.ad.4j.lane.edu].ST_Production_ESD.rev.REV_ORGANIZATION org on orgy.ORGANIZATION_GU = org.ORGANIZATION_GU
       and org.HIDE_ORGANIZATION = 'N'
inner join [SIS-INSTANCE-1.ad.4j.lane.edu].ST_Production_ESD.rev.egb_people ppl on stu.student_gu = ppl.genesisid
inner join [SIS-INSTANCE-1.ad.4j.lane.edu].ST_Production_ESD.rev.egb_schoolyear schyr on yr.year_gu = schyr.genesisguid
inner join [SIS-INSTANCE-1.ad.4j.lane.edu].ST_Production_ESD.rev.egb_school sch on org.organization_gu = sch.genesisguid
inner join [SIS-INSTANCE-1.ad.4j.lane.edu].ST_Production_ESD.rev.egb_grade grd on ppl.gradeid = grd.id
left join [SIS-INSTANCE-1.ad.4j.lane.edu].ST_Production_ESD.rev.egb_reportcardstudent rcstu on ppl.id = rcstu.studentid
                                         and rcstu.schoolyearid = schyr.id
left join [SIS-INSTANCE-1.ad.4j.lane.edu].ST_Production_ESD.rev.egb_reportcard rc on isnull(rcstu.reportcardid,
                                          (select rc2.id
                                           from   [SIS-INSTANCE-1.ad.4j.lane.edu].ST_Production_ESD.rev.egb_reportcardschoolyear rcsy
                                           inner join [SIS-INSTANCE-1.ad.4j.lane.edu].ST_Production_ESD.rev.egb_reportcard rc2 on rcsy.reportcardid = rc2.id
                                           inner join [SIS-INSTANCE-1.ad.4j.lane.edu].ST_Production_ESD.rev.egb_reportcardgradelevels rc2gl on rc2.id = rc2gl.reportcardid
                                           where  rc2.isdefaultrc = '1' 
                                              and ppl.gradeid = rc2gl.gradeid
                                              and schyr.id = rcsy.schoolyearid
                                              and sch.id = rcsy.schoolid)) = rc.id
left join [SIS-INSTANCE-1.ad.4j.lane.edu].ST_Production_ESD.rev.egb_reportcarditems rcitem on rc.id = rcitem.reportcardid
left join [SIS-INSTANCE-1.ad.4j.lane.edu].ST_Production_ESD.rev.egb_reportcardscores rcscr on ppl.id = rcscr.studentid
                                        and schyr.id = rcscr.schoolyearid
                                        and rcitem.id = rcscr.reportcarditemid
left join [SIS-INSTANCE-1.ad.4j.lane.edu].ST_Production_ESD.rev.egb_periods prd on rcscr.periodid = prd.id
left join [SIS-INSTANCE-1.ad.4j.lane.edu].ST_Production_ESD.rev.egb_schoolschedule ss on prd.id = ss.periodid


where  1=1
   --and sch.schoolname like 'Will%'
   --and stu.sis_number = 320127
   and schyr.schoolyear = '2020-2021'
   
   and rcscr.dateadded is not null
   --and replace(grd.grade,'Grade ','') = '05'
   --and (prd.period is null or prd.period like '2nd%')
--   and rcitem.scoretypeid = 644 -- -1=Days Absent, -2=Days Tardy, -14= Days Present, 644=Comment,
--                                  -- 1757=EUG Perf Key 15-16, 1784=ELD 15-16
--   and (rcitem.item like '%ELA comment%' or
--        rcitem.item like '%Math comment%')
--   and rcscr.mark like '%comment%'
   --and rcscr.mark is not null
--   and rc.reportcard is null  -- They don't have a report card
--order by rcitem.scoretypeid

--group by 
--sch.schoolname, 
--schyr.schoolyear, 
----stu.sis_number sis_number, 
--replace(grd.grade,'Grade ','')

--order by --sch.schoolname
 --sis_number,
-- semester
go


select * from dbo.report_card_scores
inner join K12INTEL_DW.DTBL_STUDENTS WITH (NOLOCK) on report_card_scores.sis_number = DTBL_STUDENTS.student_id
where date_added is not null
and dtbl_students.district_code = '2082'
go
select 
school_name, 
grade 
--,item 
--,seq 
,mark 
,count(distinct report_card_scores.student_id) [count]
--,ell
from dbo.report_card_scores 
--          inner join K12INTEL_DW.DTBL_STUDENTS WITH (NOLOCK) on report_card_scores.student_id = DTBL_STUDENTS.student_id
--          inner join dbo.ESD_UDStu WITH (NOLOCK) on ESD_UDStu.sis_number = dtbl_students.student_id
--          inner join dbo.esd_studentdatawall WITH (NOLOCK) on esd_studentdatawall.student_id = dtbl_students.student_id
--          INNER JOIN K12INTEL_DW.DTBL_SCHOOLS WITH (NOLOCK) ON DTBL_STUDENTS.SCHOOL_KEY = DTBL_SCHOOLS.SCHOOL_KEY
--          INNER JOIN K12INTEL_DW.DTBL_STUDENT_ATTRIBS WITH (NOLOCK) ON DTBL_STUDENTS.STUDENT_ATTRIB_KEY =  DTBL_STUDENT_ATTRIBS .STUDENT_ATTRIB_KEY
--          INNER JOIN K12INTEL_DW.DTBL_STUDENT_DETAILS WITH (NOLOCK) ON DTBL_STUDENT_DETAILS.STUDENT_KEY = DTBL_STUDENTS.STUDENT_KEY
--          INNER JOIN K12INTEL_USERDATA.XTBL_DOMAIN_DECODES DOMAIN_GRADE_CODE WITH (NOLOCK) ON DOMAIN_GRADE_CODE.DOMAIN_NAME = 'GRADE_CODE' 
--          AND DOMAIN_GRADE_CODE.DOMAIN_CODE = DTBL_STUDENTS.STUDENT_CURRENT_GRADE_CODE
where 1=1
and seq < 1570
and item like 'Math%'
and mark <> '*'
--and ell = 'yes'
and seq2 = '1'
and grade = '01'
group by 
school_name, 
grade 
--item, 
--,seq 
,mark
--,ell
order by  
school_name,
grade, 
--item,
mark
go





select 
distinct 
dtbl_students.student_name student_name,
report_card_scores.sis_number sis_number,
dtbl_students.student_current_grade_code current_grade,
DTBL_SCHOOLS.school_name last_yr_school,
--count(distinct report_card_scores.sis_number) [count]
--report_card_scores.school_name historical_school,
--dtbl_students.student_name student_name,
--report_card_scores.sis_number sis_number, 
----dtbl_students.student_current_grade_code current_grade,
semester,
item, 
mark
--semester
--seq2
--DTBL_STUDENTS.student_current_school current_school
--dtbl_students.student_name,
--report_card_scores.*
from dbo.report_card_scores
    INNER JOIN K12INTEL_DW.DTBL_STUDENT_DETAILS ON DTBL_STUDENT_DETAILS.STUDENT_STATE_ID = report_card_scores.STATE_STUDENT_NUMBER 
	INNER JOIN K12INTEL_DW.DTBL_STUDENTS ON DTBL_STUDENTS.STUDENT_KEY = DTBL_STUDENT_DETAILS.STUDENT_KEY
	INNER JOIN DBO.ESD_UDSTU ON ESD_UDSTU.SIS_NUMBER = DTBL_STUDENTS.STUDENT_ID
	INNER JOIN K12INTEL_DW.FTBL_ENROLLMENTS WITH (NOLOCK) ON FTBL_ENROLLMENTS.STUDENT_KEY = DTBL_STUDENTS.STUDENT_KEY
	INNER JOIN K12INTEL_DW.DTBL_SCHOOLS WITH (NOLOCK) ON FTBL_ENROLLMENTS.SCHOOL_KEY = DTBL_SCHOOLS.SCHOOL_KEY
	INNER JOIN K12INTEL_DW.DTBL_SCHOOLS STUDENTSCHOOL WITH (NOLOCK) ON DTBL_STUDENTS.SCHOOL_KEY = STUDENTSCHOOL.SCHOOL_KEY
	INNER JOIN K12INTEL_DW.DTBL_SCHOOL_DATES DTBL_SCHOOL_DATES_BEGIN_ENROLL WITH (NOLOCK) ON FTBL_ENROLLMENTS.SCHOOL_DATES_KEY_BEGIN_ENROLL = DTBL_SCHOOL_DATES_BEGIN_ENROLL.SCHOOL_DATES_KEY
	INNER JOIN K12INTEL_DW.DTBL_SCHOOL_DATES DTBL_SCHOOL_DATES_END_ENROLL WITH (NOLOCK) ON FTBL_ENROLLMENTS.SCHOOL_DATES_KEY_END_ENROLL = DTBL_SCHOOL_DATES_END_ENROLL.SCHOOL_DATES_KEY
	INNER JOIN K12INTEL_DW.DTBL_STUDENT_ANNUAL_ATTRIBS WITH (NOLOCK) ON FTBL_ENROLLMENTS.STUDENT_ANNUAL_ATTRIBS_KEY = DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_ATTRIBS_KEY
	INNER JOIN K12INTEL_DW.DTBL_SCHOOLS ANNUALSCHOOL WITH (NOLOCK) ON DTBL_STUDENT_ANNUAL_ATTRIBS.SCHOOL_KEY = ANNUALSCHOOL.SCHOOL_KEY
	INNER JOIN K12INTEL_USERDATA.XTBL_DOMAIN_DECODES DOMAIN_GRADE_CODE WITH (NOLOCK) ON DOMAIN_GRADE_CODE.DOMAIN_NAME = 'GRADE_CODE' AND DOMAIN_GRADE_CODE.DOMAIN_CODE = DTBL_STUDENT_ANNUAL_ATTRIBS.STUDENT_ANNUAL_GRADE_CODE
	INNER JOIN K12INTEL_USERDATA.XTBL_DOMAIN_DECODES DOMAIN_GRADE_CURRENT WITH (NOLOCK) ON DOMAIN_GRADE_CURRENT.DOMAIN_NAME = 'GRADE_CODE' AND DOMAIN_GRADE_CURRENT.DOMAIN_CODE = DTBL_STUDENTS.STUDENT_CURRENT_GRADE_CODE
	          

where 1=1
and DTBL_STUDENTS.student_current_school like ('%Cal Young Middle School%')
and DTBL_SCHOOL_DATES_BEGIN_ENROLL.local_school_year = '2020-2021'
--and dtbl_students.student_current_grade_code = '02'
--and school_name = 'Willagillespie Elementary School'
--and report_card_scores.sis_number = '322709'
--and grade = '06'
--and date_added is not null
--and dtbl_students.student_current_grade_code = '06'
--and ell = 'yes'
--and item like 'Math%'
--and seq2 =1
--and sis_number = '320127'
--order by 
--student_name
--group by 
--DTBL_STUDENTS.student_current_school,
--dtbl_students.student_current_grade_code
and item <> 'Days Absent'
and item <> 'Days Present'
and item <> 'Days Tardy'


order by
dtbl_students.student_name,
dtbl_students.student_current_grade_code,
DTBL_SCHOOLS.school_name,
semester,
item, 
mark


--sis_number
go



select count(distinct sis_number) from dbo.report_card_scores_20_21
go

select * from dbo.report_card_scores
go