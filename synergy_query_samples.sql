-- Display student data
select org.organization_name, stu.SIS_NUMBER, per.LAST_NAME, per.first_name,
       tblgrd.value_description grade,
       convert(varchar(10), per.birth_date, 101) birth_date, per.gender,
       case per.RESOLVED_ETHNICITY_RACE
           when '__HIS' then 'Hispanic'
           when '__TWO' then 'Multi'
           else tbleth.VALUE_DESCRIPTION
       end ethnic_race,
       per.email, stu.init_ninth_grade_year, stu.state_student_number ssid,
--       tblcus.VALUE_DESCRIPTION custody
       tbldip.value_description diploma_type,
       COMPLETION_STATUS,
       ssy.status
from   rev.EPC_STU stu
inner join rev.epc_stu_sch_yr ssy on stu.student_gu = ssy.student_gu
inner join rev.sif_22_common_currentyeargu ccyg on ssy.year_gu = ccyg.year_gu
inner join rev.REV_PERSON per on stu.STUDENT_GU = per.PERSON_GU
inner join rev.REV_ORGANIZATION_YEAR orgy on ssy.ORGANIZATION_YEAR_GU = orgy.ORGANIZATION_YEAR_GU
inner join rev.REV_ORGANIZATION org on orgy.ORGANIZATION_GU = org.ORGANIZATION_GU
       and org.HIDE_ORGANIZATION = 'N'
inner join rev.REV_ORGANIZATION org2 on org.PARENT_GU = org2.ORGANIZATION_GU
left join rev.UD_STU udstu on stu.STUDENT_GU = udstu.student_gu
left join rev.SIF_22_Common_GetLookupValues('K12','GRADE') tblgrd
    ON tblgrd.VALUE_CODE = ssy.grade
left join rev.SIF_22_Common_GetLookupValues('Revelation','ETHNICITY') tbleth
    ON tbleth.VALUE_CODE = per.resolved_ethnicity_race
left join rev.SIF_22_Common_GetLookupValues('K12.Demographics','CUSTODY') tblcus
    ON tblcus.VALUE_CODE = stu.custody_code
left join rev.SIF_22_Common_GetLookupValues('K12','DIPLOMA_TYPE') tbldip
    ON tbldip.VALUE_CODE = stu.diploma_type
where  1=1
   --and ssy.status is null
--   and org.ORGANIZATION_ABBR_NAME IN ('SEH','NEH','SHL','CHR','EEO')
   and org2.ORGANIZATION_NAME not like '5%' -- 1%=elem; 2%=midd; 3%=high; 4%=special; 5%=charter
--   and tblgrd.VALUE_DESCRIPTION in ('11') --,'10','11','12')
--   and stu.INIT_NINTH_GRADE_YEAR is null
--   and stu.SIS_NUMBER = '217248'
--   and per.EMAIL like 'rmiller%'
--   and tbldip.value_description = '4J Diploma'
order by org.organization_name, tblgrd.value_description, per.LAST_NAME, per.FIRST_NAME
go

-- Find/list students and their ethnicity/race information with each race split out.
select org.organization_name, per.last_name, per.first_name, stu.sis_number,
       tblgrd.value_description grade,
       per.hispanic_indicator,
       case per.RESOLVED_ETHNICITY_RACE
           when '__HIS' then 'Hispanic'
           when '__TWO' then 'Multi'
           else tbleth.VALUE_DESCRIPTION
       end resolved_ethnic_race,
	   wht.white_race, asn.asian_race, blk.black_race, ntv.native_race,
	   pac.pac_isl_race, latin.latin_amer_race
from   rev.epc_stu stu
inner join rev.REV_PERSON per on stu.student_GU = per.person_gu
inner join rev.epc_stu_sch_yr ssy on stu.student_gu = ssy.student_gu
inner join rev.sif_22_common_currentyeargu ccyg on ssy.year_gu = ccyg.year_gu
inner join rev.REV_ORGANIZATION_YEAR orgy on ssy.ORGANIZATION_YEAR_GU = orgy.ORGANIZATION_YEAR_GU
inner join rev.REV_ORGANIZATION org on orgy.ORGANIZATION_GU = org.ORGANIZATION_GU
       and org.HIDE_ORGANIZATION = 'N'
left join rev.SIF_22_Common_GetLookupValues('K12','GRADE') tblgrd
    ON tblgrd.VALUE_CODE = ssy.grade
left join rev.SIF_22_Common_GetLookupValues('Revelation','ETHNICITY') tbleth
    ON tbleth.VALUE_CODE = per.resolved_ethnicity_race
left join 
    (select peth.person_gu, tblrac.value_description white_race
	 from   rev.REV_PERSON_SECONDRY_ETH_LST peth
     left join rev.SIF_22_Common_GetLookupValues('Revelation','ETHNICITY') tblrac
          ON tblrac.VALUE_CODE = peth.ethnic_code
	 where tblrac.value_description = 'White') wht
	      on stu.student_gu = wht.person_gu
left join 
    (select peth.person_gu, tblrac.value_description asian_race
	 from   rev.REV_PERSON_SECONDRY_ETH_LST peth
     left join rev.SIF_22_Common_GetLookupValues('Revelation','ETHNICITY') tblrac
          ON tblrac.VALUE_CODE = peth.ethnic_code
	 where tblrac.value_description = 'Asian') asn
	      on stu.student_gu = asn.person_gu
left join 
    (select peth.person_gu, tblrac.value_description black_race
	 from   rev.REV_PERSON_SECONDRY_ETH_LST peth
     left join rev.SIF_22_Common_GetLookupValues('Revelation','ETHNICITY') tblrac
          ON tblrac.VALUE_CODE = peth.ethnic_code
	 where tblrac.value_description = 'Black') blk
	      on stu.student_gu = blk.person_gu
left join 
    (select peth.person_gu, tblrac.value_description native_race
	 from   rev.REV_PERSON_SECONDRY_ETH_LST peth
     left join rev.SIF_22_Common_GetLookupValues('Revelation','ETHNICITY') tblrac
          ON tblrac.VALUE_CODE = peth.ethnic_code
	 where tblrac.value_description like '%Indian%') ntv
	      on stu.student_gu = ntv.person_gu
left join 
    (select peth.person_gu, tblrac.value_description pac_isl_race
	 from   rev.REV_PERSON_SECONDRY_ETH_LST peth
     left join rev.SIF_22_Common_GetLookupValues('Revelation','ETHNICITY') tblrac
          ON tblrac.VALUE_CODE = peth.ethnic_code
	 where tblrac.value_description like '%Pacific%') pac
	      on stu.student_gu = pac.person_gu
left join 
    (select peth.person_gu, tblrac.value_description latin_amer_race
	 from   rev.REV_PERSON_SECONDRY_ETH_LST peth
     left join rev.SIF_22_Common_GetLookupValues('Revelation','ETHNICITY') tblrac
          ON tblrac.VALUE_CODE = peth.ethnic_code
	 where tblrac.value_description like 'non-us%') latin
	      on stu.student_gu = latin.person_gu
where  1=1
   and ssy.STATUS is null
   and tblgrd.value_description = '12'
order by org.organization_name, per.last_name, per.first_name
go

-- Find/list students and their ethnicity/race information and student address
--   with parent information.  I run this annually for Larry Williams at Edgewood.
select org.organization_name, per.last_name, per.first_name, stu.sis_number,
       tblgrd.value_description grade, per.gender,
       homlang.VALUE_DESCRIPTION first_language,
       per.hispanic_indicator, tblrac.value_description race,
       case per.RESOLVED_ETHNICITY_RACE
           when '__HIS' then 'Hispanic'
           when '__TWO' then 'Multi'
           else tbleth.VALUE_DESCRIPTION
       end resolved_ethnic_race,
       per2.LAST_NAME par_last_name, per2.first_name par_first_name,
       tblrel.VALUE_DESCRIPTION relationship,
       parlang.VALUE_DESCRIPTION par_primary_lang,
       per2.email par_email,
       substring(perph.phone,1,3)+'-'+substring(perph.phone,4,3)+'-'+substring(perph.phone,7,4) home_phone,
       substring(perph2.phone,1,3)+'-'+substring(perph2.phone,4,3)+'-'+substring(perph2.phone,7,4) work_phone,
       substring(perph3.phone,1,3)+'-'+substring(perph3.phone,4,3)+'-'+substring(perph3.phone,7,4) cell_phone,
       case CHARINDEX('#',adr.address)
           when 0 then adr.ADDRESS
           else left(adr.address,charindex('#',adr.ADDRESS)-2)
       end Addr,
       adr.CITY, adr.state, adr.zip_5 zip, replace(adr.STREET_EXTRA,'#','') Apt,
       case when adr.ADDRESS <> adr2.ADDRESS
                then adr2.address
       end mail_addr,
       case when adr.ADDRESS <> adr2.ADDRESS
                then adr2.CITY+', '+adr2.STATE+' '+adr2.ZIP_5
       end mail_city_state_zip,
       spar.educational_rights, spar.HAS_CUSTODY,
       spar.MAILINGS_ALLOWED, spar.CONTACT_ALLOWED, spar.release_to, spar.lives_with
from   rev.REV_PERSON_SECONDRY_ETH_LST peth
inner join rev.REV_PERSON per on peth.PERSON_GU = per.person_gu
inner join rev.EPC_STU stu on per.PERSON_GU = stu.student_gu
inner join rev.epc_stu_sch_yr ssy on stu.student_gu = ssy.student_gu
inner join rev.sif_22_common_currentyeargu ccyg on ssy.year_gu = ccyg.year_gu
inner join rev.REV_ORGANIZATION_YEAR orgy on ssy.ORGANIZATION_YEAR_GU = orgy.ORGANIZATION_YEAR_GU
inner join rev.REV_ORGANIZATION org on orgy.ORGANIZATION_GU = org.ORGANIZATION_GU
       and org.HIDE_ORGANIZATION = 'N'
left join rev.EPC_STU_PARENT spar on stu.student_GU = spar.student_GU
left join rev.EPC_PARENT par on spar.PARENT_GU = par.parent_gu
left join rev.REV_PERSON per2 on par.PARENT_GU = per2.PERSON_GU
inner join rev.REV_ADDRESS adr on per.HOME_ADDRESS_GU = adr.ADDRESS_GU
left join rev.REV_ADDRESS adr2 on per.MAIL_ADDRESS_GU = adr2.address_gu
left join rev.SIF_22_Common_GetLookupValues('K12','GRADE') tblgrd
    ON tblgrd.VALUE_CODE = ssy.grade
left join rev.SIF_22_Common_GetLookupValues('Revelation','ETHNICITY') tblrac
    ON tblrac.VALUE_CODE = peth.ethnic_code
left join rev.SIF_22_Common_GetLookupValues('Revelation','ETHNICITY') tbleth
    ON tbleth.VALUE_CODE = per.resolved_ethnicity_race
left outer join rev.SIF_22_Common_GetLookupValues('K12','RELATION_TYPE') tblrel
    on tblrel.VALUE_CODE = spar.relation_type
left outer join rev.SIF_22_Common_GetLookupValues('K12','LANGUAGE') homlang
    on homlang.VALUE_CODE = stu.home_language
left outer join rev.SIF_22_Common_GetLookupValues('K12','LANGUAGE') parlang
    on parlang.VALUE_CODE = per2.primary_language
left join rev.REV_PERSON_PHONE perph on par.PARENT_GU = perph.PERSON_GU and
           perph.PHONE_TYPE = 'H'
left join rev.REV_PERSON_PHONE perph2 on par.PARENT_GU = perph2.PERSON_GU and
           perph2.PHONE_TYPE = 'W'
left join rev.REV_PERSON_PHONE perph3 on par.PARENT_GU = perph3.PERSON_GU and
           perph3.PHONE_TYPE = 'C'
where  1=1
   and ssy.STATUS is null
   and org.ORGANIZATION_ABBR_NAME = 'EDC'
--   and stu.SIS_NUMBER = '116067'
--   and (tblrac.VALUE_DESCRIPTION is null or tblrac.value_description like '%Indian%')
--   and tblrac.value_description = 'Black'
--   and per2.email is not null
--   and per.HISPANIC_INDICATOR = 'Y'
--   and spar.CONTACT_ALLOWED = 'N'
order by org.organization_name, per.last_name, per.first_name
go


-- Display daily attendance
select org.organization_name, stu.SIS_NUMBER, per.LAST_NAME, per.first_name, tblgrd.value_description grade,
       convert(varchar(10),da.abs_date,101) abs_date, da.abs_fte1, ar.abbreviation, ar.description,
       da.abs_fte2, ar2.abbreviation, da.unex_abs_amnt, da.absent_percent_calc, da.total_absent_percent_calc
      ,da.note
	  ,per2.last_name add_by_last_name, per2.first_name add_by_first_name, da.add_date_time_stamp
      ,per3.last_name chg_by_last_name, per3.first_name chg_by_first_name, da.change_date_time_stamp
from   rev.EPC_STU_ATT_DAILY da
inner join rev.EPC_STU_ENROLL enr on da.ENROLLMENT_GU = enr.enrollment_gu
inner join rev.epc_stu_sch_yr ssy on enr.STUDENT_SCHOOL_YEAR_GU = ssy.STUDENT_SCHOOL_YEAR_GU
inner join rev.EPC_STU stu on ssy.STUDENT_GU = stu.STUDENT_GU
inner join rev.REV_PERSON per on stu.STUDENT_GU = per.PERSON_GU
inner join rev.REV_ORGANIZATION_YEAR orgy on ssy.ORGANIZATION_YEAR_GU = orgy.ORGANIZATION_YEAR_GU
inner join rev.rev_year yr on orgy.year_gu = yr.year_gu
inner join rev.REV_ORGANIZATION org on orgy.ORGANIZATION_GU = org.ORGANIZATION_GU
	   and org.HIDE_ORGANIZATION = 'N'
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
--   and org2.ORGANIZATION_NAME like '2%' -- 1%=elem; 2%=midd; 3%=high; 4%=special; 5%=charter
--   and org.ORGANIZATION_NAME like 'Adams%'
--   and ar.type in ('EXC', 'UNE')
   and da.abs_date > '9/1/19'
--   and (da.note like '%mh%' or da.note like '%mental%') and ar.abbreviation is not null
order by org.organization_name, per.last_name, per.first_name, stu.sis_number, da.abs_date
go


-- Display period attendance
select org.organization_name, stu.SIS_NUMBER, per.LAST_NAME, per.first_name,
       convert(varchar(10),da.abs_date,101) abs_date,
       pa.bell_period, ar.abbreviation, ar.description, ar.type
      ,pa.note
	  ,per2.last_name add_by_last_name, per2.first_name add_by_first_name, pa.add_date_time_stamp
      ,per3.last_name chg_by_last_name, per3.first_name chg_by_first_name, pa.change_date_time_stamp
from   rev.EPC_STU_ATT_PERIOD pa
inner join rev.EPC_STU_ATT_DAILY da on pa.DAILY_ATTEND_GU = da.DAILY_ATTEND_GU
inner join rev.EPC_STU_ENROLL enr on da.ENROLLMENT_GU = enr.enrollment_gu
inner join rev.epc_stu_sch_yr ssy on enr.STUDENT_SCHOOL_YEAR_GU = ssy.STUDENT_SCHOOL_YEAR_GU
inner join rev.rev_year yr on ssy.year_gu = yr.year_gu
inner join rev.EPC_STU stu on ssy.STUDENT_GU = stu.STUDENT_GU
inner join rev.REV_PERSON per on stu.STUDENT_GU = per.PERSON_GU
inner join rev.REV_ORGANIZATION_YEAR orgy on ssy.ORGANIZATION_YEAR_GU = orgy.ORGANIZATION_YEAR_GU
inner join rev.REV_ORGANIZATION org on orgy.ORGANIZATION_GU = org.ORGANIZATION_GU
       and org.HIDE_ORGANIZATION = 'N'
inner join rev.EPC_CODE_ABS_REAS_SCH_YR arsy on pa.CODE_ABS_REAS_GU = arsy.code_abs_reas_sch_year_gu
inner join rev.EPC_CODE_ABS_REAS ar on arsy.CODE_ABS_REAS_GU = ar.code_abs_reas_gu
inner join rev.rev_person per2 on pa.add_id_stamp = per2.person_gu
left join rev.rev_person per3 on pa.change_id_stamp = per3.person_gu
left join rev.epc_sch_att_cal sac on orgy.organization_year_gu = sac.school_year_gu
                                  and da.abs_date = sac.cal_date
where  1=1
--   and stu.SIS_NUMBER in (226020)
--   and yr.school_year = '2015'
--   and org.ORGANIZATION_ABBR_NAME = 'SHL'
--   and sac.holiday is null
--   and org.ORGANIZATION_NAME like 'North%'
--   and da.ABS_DATE = DATEADD(day, DATEDIFF(day, 0, GETDATE()), -1)
   and da.abs_date > '9/1/19'
--   and ar.type not in ('TDY','TAR','ACT')
   and ar.TYPE in ('EXC','UNE')
--   and ar.type in ('UNE')
--   and pa.BELL_PERIOD in ('3')
--   and (per2.last_name = 'kearney' or per3.last_name = 'kearney')
--   and per3.last_name = 'guldager'
  and pa.note is not null
order by org.organization_name, per.LAST_NAME, per.FIRST_NAME, da.abs_date, pa.bell_period
--order by org.organization_name, da.abs_date, pa.bell_period, per.LAST_NAME, per.FIRST_NAME
go


-- Display period attendance.  Exclude attendance for non-school days and for dates/bell periods where you can't tie
--   it back to a specific section that met on that date/bell period.  If a student is scheduled into 2 sections that
--   meet on the same date/bell period the attendance will show up twice - once for each section.  However, if one of
--   those 2 sections is a "deleted" section the attendance will only count against the non-deleted section.
with startdt as  -- Get the earliest start date for each term code a school has (this primarily applies to the YR term code.
   (select orgy.organization_year_gu, sygpt.term_code, min(ss.startdate) term_start_date
    from   rev.egb_schoolschedule ss
    inner join rev.egb_school sch on ss.schoolid = sch.id
    inner join rev.egb_schoolyear schyr on ss.yearid = schyr.id
    inner join rev.rev_organization org on sch.genesisguid = org.organization_gu
    inner join rev.rev_organization_year orgy on org.organization_gu = orgy.organization_gu
    inner join rev.rev_year yr on orgy.year_gu = yr.year_gu
--           and yr.school_year = '2015'
    inner join rev.egb_periods prd on ss.periodid = prd.id
    inner join rev.epc_sch_yr_grd_prd sygp on prd.gradeperiodid = sygp.school_year_grd_prd_gu
    inner join rev.epc_sch_yr_grd_prd_trm sygpt on sygp.school_year_grd_prd_gu = sygpt.school_year_grd_prd_gu
    where  1=1
       and sygp.type = 'G'
    group by orgy.organization_year_gu, sygpt.term_code),
enddt as  -- get the latest end date for each term code a school has (this primarily applies to the yr term code.
   (select sytd.organization_year_gu, sytc.term_code, max(sytd.event_date) term_end_date
    from   rev.epc_sch_yr_trm_def sytd
    inner join rev.epc_sch_yr_trm_codes sytc on sytd.school_year_trm_def_gu = sytc.school_year_trm_def_gu
    group by sytd.organization_year_gu, sytc.term_code),
classes as  -- Include active and deleted classes
   (select clas.section_gu, clas.student_school_year_gu, clas.enter_date, clas.leave_date, null delete_date, null delete_ind 
    from   rev.epc_stu_class clas
    inner join rev.epc_sch_yr_sect sect on clas.section_gu = sect.section_gu
    inner join rev.rev_organization_year orgy on sect.organization_year_gu = orgy.organization_year_gu
           and orgy.year_gu = (select year_gu from rev.sif_22_common_currentyeargu)
    union
    select clasd.section_gu, clasd.student_school_year_gu, null enter_date, clasd.leave_date, clasd.delete_date, 'D' delete_ind
    from   rev.epc_stu_class_del clasd
    inner join rev.epc_sch_yr_sect sect on clasd.section_gu = sect.section_gu
    inner join rev.rev_organization_year orgy on sect.organization_year_gu = orgy.organization_year_gu
           and orgy.year_gu = (select year_gu from rev.sif_22_common_currentyeargu)),
stuschd as
   (select distinct org.organization_name, yr.school_year,
          per.last_name, per.first_name, stu.sis_number, tblgrd.value_description grade,
          sect.section_id, crs.course_title, sect.term_code,
          coalesce(smet.period_begin, sect.period_begin) period_begin,
          coalesce(smet.period_end, sect.period_end) period_end,
          met.meet_day_code, met.meet_day_desc, sect.credit,
          per2.last_name teacher_last_name, per2.first_name teacher_first_name,
          rm.room_name,
          coalesce(convert(varchar(10),classes.enter_date,101), convert(varchar(10),startdt.term_start_date,101)) enter_date,
          coalesce(convert(varchar(10),classes.leave_date,101), convert(varchar(10),classes.delete_date,101), convert(varchar(10),enddt.term_end_date,101)) leave_date,
          classes.delete_ind, sect.exclude_attendance include_attendance
   from   classes
   inner join rev.epc_sch_yr_sect sect on classes.section_gu = sect.section_gu
   left join rev.epc_sch_yr_sect_met_dy smet on sect.section_gu = smet.section_gu
   left join rev.epc_sch_yr_met_dy met on smet.sch_yr_met_dy_gu = met.sch_yr_met_dy_gu
   inner join startdt on sect.organization_year_gu = startdt.organization_year_gu
                     and sect.term_code = startdt.term_code
   inner join enddt on sect.organization_year_gu = enddt.organization_year_gu
                   and sect.term_code = enddt.term_code
   inner join rev.epc_stu_sch_yr ssy on classes.student_school_year_gu = ssy.student_school_year_gu
   inner join rev.rev_person per on ssy.student_gu = per.person_gu
   inner join rev.epc_stu stu on ssy.student_gu = stu.student_gu
   inner join rev.rev_organization_year orgy on sect.organization_year_gu = orgy.organization_year_gu
   inner join rev.rev_year yr on orgy.year_gu = yr.year_gu
   inner join rev.rev_organization org on orgy.organization_gu = org.organization_gu
          and org.hide_organization = 'N'
   inner join rev.epc_sch_yr_crs syc on sect.school_year_course_gu = syc.school_year_course_gu
   inner join rev.epc_crs crs on syc.course_gu = crs.course_gu
   left join rev.epc_staff_sch_yr stsy on sect.staff_school_year_gu = stsy.staff_school_year_gu
   left join rev.rev_person per2 on stsy.staff_gu = per2.person_gu
   left join rev.epc_sch_room rm on sect.room_gu = rm.room_gu
   left join rev.SIF_22_Common_GetLookupValues('K12','GRADE') tblgrd
              on (tblgrd.value_code = ssy.grade)
   where  1=1
--      and ssy.status is null
--      and org.organization_abbr_name = 'EEO'
--      and yr.school_year = 2015
      and coalesce(classes.enter_date, startdt.term_start_date) <=
          coalesce(classes.leave_date, classes.delete_date, enddt.term_end_date))
select org.organization_name, stu.sis_number, per.last_name, per.first_name,
       convert(varchar(10),da.abs_date,101) abs_date,
       pa.bell_period, ar.abbreviation, ar.description, ar.type, stuschd2.delete_ind,
       case when stuschd.section_id is not null then stuschd.section_id else stuschd2.section_id end section_id,
       case when stuschd.section_id is not null then stuschd.course_title else stuschd2.course_title end course_title,
       case when stuschd.section_id is not null then stuschd.teacher_last_name else stuschd2.teacher_last_name end teacher_last_name,
       case when stuschd.section_id is not null then stuschd.teacher_first_name else stuschd2.teacher_first_name end teacher_first_name,
       case when stuschd.section_id is not null then stuschd.room_name else stuschd2.room_name end room_name,
       datediff(minute, bellp.start_time, bellp.end_time) period_minutes
--	  ,per2.last_name add_by_last_name, per2.first_name add_by_first_name
--      ,per3.last_name chg_by_last_name, per3.first_name chg_by_first_name
from   rev.epc_stu_att_period pa
inner join rev.epc_stu_att_daily da on pa.daily_attend_gu = da.daily_attend_gu
inner join rev.epc_stu_enroll enr on da.enrollment_gu = enr.enrollment_gu
inner join rev.epc_stu_sch_yr ssy on enr.student_school_year_gu = ssy.student_school_year_gu
                                 and ssy.year_gu = (select year_gu from rev.sif_22_common_currentyeargu)
inner join rev.rev_year yr on ssy.year_gu = yr.year_gu
inner join rev.epc_stu stu on ssy.student_gu = stu.student_gu
inner join rev.rev_person per on stu.student_gu = per.person_gu
inner join rev.rev_organization_year orgy on ssy.organization_year_gu = orgy.organization_year_gu
inner join rev.rev_organization org on orgy.organization_gu = org.organization_gu
       and org.hide_organization = 'N'
inner join rev.epc_code_abs_reas_sch_yr arsy on pa.code_abs_reas_gu = arsy.code_abs_reas_sch_year_gu
inner join rev.epc_code_abs_reas ar on arsy.code_abs_reas_gu = ar.code_abs_reas_gu
inner join rev.rev_person per2 on pa.add_id_stamp = per2.person_gu
left join rev.rev_person per3 on pa.change_id_stamp = per3.person_gu
inner join rev.epc_sch_yr_opt syo on orgy.organization_year_gu = syo.organization_year_gu
left join rev.epc_sch_att_cal sac on orgy.organization_year_gu = sac.school_year_gu
                                 and da.abs_date = sac.cal_date
left join rev.epc_sch_yr_rot_cycle rot on orgy.organization_year_gu = rot.organization_year_gu
      and sac.rotation = rot.rotation_cycle_code
left join rev.epc_sch_yr_met_dy meet on orgy.organization_year_gu = meet.organization_year_gu
      and rot.meet_day_code = meet.meet_day_code
left join rev.epc_sch_yr_bell_sched bell on orgy.organization_year_gu = bell.organization_year_gu
      and coalesce(sac.bell_schedule,syo.bell_schedule_default) = bell.bell_schedule_code
left join rev.epc_sch_yr_bell_sched_per bellp on bell.bell_schedule_gu = bellp.bell_schedule_gu
      and pa.bell_period = bellp.bell_period
left join stuschd on stu.sis_number = stuschd.sis_number
                  and pa.bell_period between stuschd.period_begin and stuschd.period_end
                  and da.abs_date >= stuschd.enter_date
                  and da.abs_date <= stuschd.leave_date
                  and (rot.meet_day_code is null or stuschd.meet_day_code is null or rot.meet_day_code = stuschd.meet_day_code)
                  and stuschd.delete_ind is null
                  and stuschd.include_attendance = 'Y'
left join stuschd stuschd2 on stu.sis_number = stuschd2.sis_number
                   and pa.bell_period between stuschd2.period_begin and stuschd2.period_end
                   and da.abs_date >= stuschd2.enter_date
                   and da.abs_date <= stuschd2.leave_date
                   and (rot.meet_day_code is null or stuschd2.meet_day_code is null or rot.meet_day_code = stuschd2.meet_day_code)
                   and stuschd2.delete_ind = 'D'
                   and stuschd2.include_attendance = 'Y'
where  1=1
--   and stu.sis_number in (154308,155091,175537,156434)
--   and yr.school_year = '2015'
--   and org.organization_abbr_name = 'SHL'
   and sac.holiday is null
   -- Include the absence record only if we're able to tie it back to some section...
--   and (stuschd.section_id is not null or stuschd2.section_id is not null) -- If these 2 sections are both null then it couldn't find a matching section to tie the absence to.
   -- Include the absence record only if we're unable to tie it back to some section...
--   and (stuschd.section_id is null and stuschd2.section_id is null) -- These are truly orphaned absence records.
   -- Include the absence record only if we're unable to tie it back to some section or a deleted course enrollment
   and (stuschd.section_id is null) -- Orphaned absence records or tied to deleted class enrollment
--   and org.organization_name like 'North%'
--   and da.abs_date = dateadd(day, datediff(day, 0, getdate()), -1)
--   and ar.type in ('UNE','TAR')
   and ar.type in ('UNE','EXC')
--   and pa.bell_period = '1'
--   and per2.last_name = 'christie'
order by org.organization_name, per.last_name, per.first_name, da.abs_date, pa.bell_period
go


-- Extract student course history for Oscar
select stu.sis_number, per.last_name, per.first_name, ele.grade_desc grade, --ele.leave_date, ele.leave_desc,
       org.organization_name last_attended,
	   his.course_id, his.course_title, his.teacher_name, crs.subject_area_1 diploma_catgory,
       case his.COURSE_HISTORY_TYPE
           when '1' then 'Middle'
           when '2' then 'High'
           when '3' then 'Other'
           else his.COURSE_HISTORY_TYPE
       end CHS_Type,
       tblgrd.value_description grade,
       his.school_year, his.calendar_month, his.calendar_year, his.term_code term,
       his.mark, his.credit_attempted, his.credit_completed,
--       convert(varchar(10),his.class_end_date,101) class_end_date,
       org3.organization_name earned_at
--      ,per2.last_name add_by_last_name, per2.first_name add_by_first_name, his.add_date_time_stamp
--      ,his.*
--      ,ele.*
from   rev.epc_stu_crs_his his
inner join rev.epc_stu stu on his.student_gu = stu.student_gu
inner join rev.rev_person per on his.student_gu = per.person_gu
inner join eug.eug_last_enrollment ele on his.student_gu = ele.student_gu
inner join rev.epc_crs crs on his.course_gu = crs.course_gu
inner join rev.REV_ORGANIZATION_YEAR orgy on ele.ORGANIZATION_YEAR_GU = orgy.ORGANIZATION_YEAR_GU
inner join rev.REV_ORGANIZATION org on orgy.organization_gu = org.organization_gu
       and org.HIDE_ORGANIZATION = 'N'
inner join rev.REV_ORGANIZATION org2 on org.PARENT_GU = org2.ORGANIZATION_GU
left join rev.rev_person per2 on his.add_id_stamp = per2.person_gu
left join rev.REV_ORGANIZATION org3 on his.school_in_district_gu = org3.organization_gu
left join rev.SIF_22_Common_GetLookupValues('K12','GRADE') tblgrd on (tblgrd.VALUE_CODE = his.grade)
where  1=1
--   and ele.school_year = '2014'
--   and org2.ORGANIZATION_NAME like '3%' -- 1%=elem; 2%=midd; 3%=high; 4%=special; 5%=charter
   and org3.organization_abbr_name in ('NEH','SEH','SHL','CHR')
--   and org.organization_abbr_name = 'SEH'
--   and ele.status is null
--   and ele.grade_desc in ('12')
--   and stu.sis_number = '230188'
   and his.COURSE_HISTORY_TYPE in ('2')  -- 1=Middle, 2=High, 3=Other
--   and his.course_title like '%apex%'
   and his.school_year in ('2013','2014')
--   and his.CREDIT_COMPLETED = 5
--   and his.grade in ('175','185')
--   and his.credit_attempted <> his.credit_completed
--   and his.credit_completed > 0
--   and his.credit_attempted > 0
--   and his.credit_attempted = .05
--   and his.add_date_time_stamp < '09/01/2013'
--   and per.last_name = 'User'
--   and his.credit_completed = 0
--   and his.credit_attempted > 0
--   and his.mark not in ('F','NP','N','U','I','WF','WD','K','NB','NG','IN',
--                        'NOTPROF','NPR','-','NC','.','IE','NBJ','NRLYPROF')
--   and his.credit_completed > 0
--   and his.mark in ('F','NP','N','U','I','WF','WD','K','NB','NG','IN',
--                    'NOTPROF','NPR','-','NC','.','IE','NBJ','NRLYPROF')
order by stu.sis_number, his.CALENDAR_YEAR, his.calendar_month, his.course_title
go


select * from    [SIS-INSTANCE-1.ad.4j.lane.edu].ST_Production_ESD.[dbo].[att_10day_cons_abs] 
go



