-- Display daily attendance
select 
org2.ORGANIZATION_NAME school_level,
org.organization_name, 
case when tblgrd.value_description in ('13','14') then '12' 
when tblgrd.value_description = 'KG' then '0'
else tblgrd.value_description end grade,
count(distinct stu.SIS_NUMBER), 
--stu.SIS_NUMBER,
--per.LAST_NAME, 
--per.first_name, 
convert(varchar(10),da.abs_date,101) abs_date
--da.abs_fte1, 
--ar.abbreviation, 
--ar.description,
--da.abs_fte2, 
--ar2.abbreviation, 
--da.unex_abs_amnt, 
--da.absent_percent_calc, 
--da.total_absent_percent_calc
--da.note,
--per2.last_name add_by_last_name, 
--per2.first_name add_by_first_name, 
--da.add_date_time_stamp,
--per3.last_name chg_by_last_name, 
--per3.first_name chg_by_first_name, 
--da.change_date_time_stamp


from   rev.EPC_STU_ATT_DAILY da
inner join rev.EPC_STU_ENROLL enr on da.ENROLLMENT_GU = enr.enrollment_gu
inner join rev.epc_stu_sch_yr ssy on enr.STUDENT_SCHOOL_YEAR_GU = ssy.STUDENT_SCHOOL_YEAR_GU
inner join rev.EPC_STU stu on ssy.STUDENT_GU = stu.STUDENT_GU
inner join rev.REV_PERSON per on stu.STUDENT_GU = per.PERSON_GU
inner join rev.REV_ORGANIZATION_YEAR orgy on ssy.ORGANIZATION_YEAR_GU = orgy.ORGANIZATION_YEAR_GU
inner join rev.rev_year yr on orgy.year_gu = yr.year_gu
inner join rev.REV_ORGANIZATION org on orgy.ORGANIZATION_GU = org.ORGANIZATION_GU
	   and org.HIDE_ORGANIZATION = 'N'
--	        [SIS-INSTANCE-1.ad.4j.lane.edu].ST_Production_ESD.rev.REV_ORGANIZATION_YEAR
--inner join [dw-db-01.4j.lane.edu].k12INTEL.dbo.School_groups sch_grp on sch_grp.school_name =  org.organization_name 

inner join rev.REV_ORGANIZATION org2 on org.PARENT_GU = org2.ORGANIZATION_GU
left join rev.EPC_CODE_ABS_REAS_SCH_YR arsy on da.CODE_ABS_REAS1_GU = arsy.code_abs_reas_sch_year_gu
left join rev.EPC_CODE_ABS_REAS ar on arsy.CODE_ABS_REAS_GU = ar.code_abs_reas_gu
left join rev.EPC_CODE_ABS_REAS_SCH_YR arsy2 on da.CODE_ABS_REAS2_GU = arsy2.code_abs_reas_sch_year_gu
left join rev.EPC_CODE_ABS_REAS ar2 on arsy2.CODE_ABS_REAS_GU = ar2.code_abs_reas_gu
left join rev.SIF_22_Common_GetLookupValues('K12','GRADE') tblgrd ON tblgrd.VALUE_CODE = ssy.grade
inner join rev.rev_person per2 on da.add_id_stamp = per2.person_gu
left join rev.rev_person per3 on da.change_id_stamp = per3.person_gu
where  1=1
--   and yr.school_year = '2016'
--   and stu.sis_number = '261562'
  --and org2.ORGANIZATION_NAME like '2%' -- 1%=elem; 2%=midd; 3%=high; 4%=special; 5%=charter
  and org2.ORGANIZATION_NAME in ('1. Elementary Schools','2. Middle Schools','3. High Schools')
--   and org.ORGANIZATION_NAME like 'Adams%'
--   and ar.type in ('EXC', 'UNE')
   --and da.abs_date = '10/1/21'
   and da.abs_date between '9/19/21' and '1/11/22'
   --and da.abs_date = '9/10/21'
   and cast(da.total_absent_percent_calc as decimal(12,9)) >= .75
   
--   and (da.note like '%mh%' or da.note like '%mental%') and ar.abbreviation is not null

group by 
org2.ORGANIZATION_NAME,
org.organization_name, 
case when tblgrd.value_description in ('13','14') then '12' 
when tblgrd.value_description = 'KG' then '0'
else tblgrd.value_description end,
convert(varchar(10),da.abs_date,101) 


order by 
org2.ORGANIZATION_NAME,
org.organization_name, 
case when tblgrd.value_description in ('13','14') then '12' 
when tblgrd.value_description = 'KG' then '0'
else tblgrd.value_description end,
--per.last_name, 
--per.first_name, 
--stu.sis_number, 
convert(varchar(10),da.abs_date,101) asc
go
