DECLARE
@STAGE_SOURCE VARCHAR(20) = 'ESD_EDP', --Set this to the source code, this can be found in K12INTEL_USERDATA.XTBL_SOURCE_CONTROL
@LOGIN_NAME VARCHAR(50) =  'rebar_h'
--Usergroups
select distinct 
b.DOMAIN_DECODE, 
b.DOMAIN_ALTERNATE_DECODE,
usr.LOGIN_NAME,
rp.LAST_NAME,
rp.FIRST_NAME
from K12INTEL_STAGING_EDP.REV_USER_USERGROUP a with(nolock)
inner join k12intel_userdata.xtbl_domain_decodes b with(nolock) on b.domain_name = 'SYNERGY_SECURITY_GROUPS' and b.domain_code = CAST(a.USERGROUP_GU as varchar(40)) and b.DOMAIN_SCOPE = a.STAGE_SOURCE --and b.DOMAIN_ALTERNATE_DECODE = 'SCHOOL'
inner join k12intel_STaging_edp.REV_USER usr on a.USER_GU = usr.USER_GU and a.STAGE_SOURCE = usr.STAGE_SOURCE
inner join k12intel_STaging_edp.REV_PERSON rp
on usr.USER_GU = rp.PERSON_GU and usr.STAGE_SOURCE = rp.STAGE_SOURCE --and rp.STAGE_SIS_SCHOOL_YEAR = k12intel_metadata.GET_SIS_SCHOOL_YEAR_EDP(rp.STAGE_SOURCE)
where 1=1 
--and usr.LOGIN_NAME = @LOGIN_NAME
--in ('apgar_k','barbour_m','ben.wilcox','betsy.brandenfels','boettcher_r','brisentine_p','bronaugh_l',
--'bumstead_a','chinn','emanuel_m','gabriel.martin','gaston_e','glenn_p','isham_h','kephart_c','keyworth_b',
--'korach_k','l.jager','loureiro_o','maloney','marsh','mcmanus_k','mendelssohn_e','mendelssohn_j',
--'mhayes','mickola_g','nolan_p','piowaty_t','plunkett_s','potts_j','reinhardt_k','taylor_d',
--'tracy_j','washburn_m','whipple','womack_j','woods_sa','yocum_m')

and usr.STAGE_SOURCE = @STAGE_SOURCE
--and (domain_decode like ('Role%') or domain_decode like ('Hoonuit%'))
--and domain_decode not like ('%Focus%')
--and domain_decode not like ('%General%')
--and domain_decode not like ('%Case%')
--and domain_decode not like ('%Dual%')
--and domain_decode not like ('%Support%')
and b.DOMAIN_DECODE like ('Hoonuit%') 
order by 
b.DOMAIN_DECODE,
b.DOMAIN_ALTERNATE_DECODE,
usr.LOGIN_NAME,
rp.LAST_NAME,
rp.FIRST_NAME
go


SELECT

	distinct SUBSTRING(user_email,0,CHARINDEX('@',user_email))
	
FROM

	K12INTEL_PORTAL.aud_events WITH (NOLOCK)
	inner join K12INTEL_PORTAL.aud_event_types WITH (NOLOCK) on aud_events.event_type_id = aud_event_types.event_type_id
	left join K12INTEL_PORTAL.ptl_users WITH (NOLOCK) on aud_events.event_user_id = ptl_users.object_id
	LEFT OUTER JOIN K12INTEL_PORTAL.PTL_OBJECT_HIERARCHY CHILD WITH (NOLOCK) on PTL_USERS.OBJECT_ID = CHILD.OBJECT_ID
	LEFT OUTER JOIN K12INTEL_PORTAL.PTL_OBJECT_HIERARCHY PARENT WITH (NOLOCK) on CHILD.PARENT_LINK_ID = PARENT.LINK_ID
	LEFT OUTER JOIN K12INTEL_PORTAL.PTL_OBJECTS GROUPS WITH (NOLOCK) on PARENT.OBJECT_ID = GROUPS.OBJECT_ID

WHERE
	(
		event_type_name = 'LoginSuccessful'
		and event_timestamp between getdate()-30 and getdate()
	)
go

SELECT distinct 
	b.DOMAIN_ALTERNATE_DECODE,
	b.DOMAIN_DECODE, 
    user_email,
	sum(Weekdays.Events) AS "C1845",
	sum(MonthDays.Events) AS "C1846",
	sum(QtrDays.Events) AS "C1847",
	sum(HfYrDays.Events) AS "C1848"
FROM
	     K12INTEL_PORTAL.PTL_USERS WITH (NOLOCK)
	     inner join k12intel.k12intel_STaging_edp.REV_USER usr on usr.LOGIN_NAME = SUBSTRING(PTL_USERS.user_email,0,CHARINDEX('@',PTL_USERS.user_email))	
	    inner join k12intel.k12intel_STaging_edp.REV_USER_USERGROUP a on a.USER_GU = usr.USER_GU and a.STAGE_SOURCE = usr.STAGE_SOURCE
        inner join k12intel.k12intel_userdata.xtbl_domain_decodes b with(nolock) on b.domain_name = 'SYNERGY_SECURITY_GROUPS' and b.domain_code = CAST(a.USERGROUP_GU as varchar(40)) and b.DOMAIN_SCOPE = a.STAGE_SOURCE --and b.DOMAIN_ALTERNATE_DECODE = 'SCHOOL'
	     inner join k12intel.k12intel_STaging_edp.REV_PERSON rp on usr.USER_GU = rp.PERSON_GU and usr.STAGE_SOURCE = rp.STAGE_SOURCE 
	          LEFT OUTER JOIN K12INTEL_PORTAL.PTL_OBJECT_HIERARCHY CHILD WITH (NOLOCK) on PTL_USERS.OBJECT_ID = CHILD.OBJECT_ID
	          LEFT OUTER JOIN K12INTEL_PORTAL.PTL_OBJECT_HIERARCHY PARENT WITH (NOLOCK) on CHILD.PARENT_LINK_ID = PARENT.LINK_ID
	          LEFT OUTER JOIN K12INTEL_PORTAL.PTL_OBJECTS GROUPS WITH (NOLOCK) on PARENT.OBJECT_ID = GROUPS.OBJECT_ID
	LEFT OUTER JOIN (select EVENT_USER_ID, count(Distinct EVENT_ID) as Events from K12INTEL_PORTAL.AUD_EVENTS WITH (NOLOCK)
	            WHERE EVENT_TYPE_ID = 2 and cast(EVENT_TIMESTAMP as datetime) between getdate()-7 and getdate()
	            GROUP BY EVENT_USER_ID) WeekDays on PTL_USERS.OBJECT_ID = WeekDays.EVENT_USER_ID
	            
	          LEFT OUTER JOIN (select DISTINCT EVENT_USER_ID, count(Distinct EVENT_ID) as Events from K12INTEL_PORTAL.AUD_EVENTS WITH (NOLOCK)
	            WHERE EVENT_TYPE_ID = 2 and cast(EVENT_TIMESTAMP as datetime) between getdate()-30 and getdate()-7
	            GROUP BY EVENT_USER_ID) MonthDays on PTL_USERS.OBJECT_ID = MonthDays.EVENT_USER_ID
	            
	          LEFT OUTER JOIN (select DISTINCT EVENT_USER_ID, count(Distinct EVENT_ID) as Events from K12INTEL_PORTAL.AUD_EVENTS WITH (NOLOCK)
	            WHERE EVENT_TYPE_ID = 2 and cast(EVENT_TIMESTAMP as datetime) between getdate()-90 and getdate()-30
	            GROUP BY EVENT_USER_ID) QtrDays on PTL_USERS.OBJECT_ID = QtrDays.EVENT_USER_ID
	
	          LEFT OUTER JOIN (select DISTINCT EVENT_USER_ID, count(Distinct EVENT_ID) as Events from K12INTEL_PORTAL.AUD_EVENTS WITH (NOLOCK)
	            WHERE EVENT_TYPE_ID = 2 and cast(EVENT_TIMESTAMP as datetime) between getdate()-180 and getdate()-90
	            GROUP BY EVENT_USER_ID) HfYrDays on PTL_USERS.OBJECT_ID = HfYrDays.EVENT_USER_ID
WHERE

	(
		ptl_users.OBJECT_ID in (
			select oh_child.object_id 
			from K12INTEL_PORTAL.ptl_object_hierarchy oh
			inner join K12INTEL_PORTAL.ptl_object_hierarchy oh_child on oh.link_id = oh_child.parent_link_id
			where 1=1 
		)
		--and Weekdays.Events is not null
    and MonthDays.Events is not null
    AND USER_EMAIL NOT LIKE ('%springfield%')
    and (domain_decode like ('%Role%') or domain_decode like ('%Hoonuit%'))
    and domain_decode not like ('%Focus%')
    and domain_decode not like ('%General%')
    and domain_decode not like ('%Case%')
    and domain_decode not like ('%Dual%')
    and domain_decode not like ('%Support%')
    
	)
GROUP BY
	user_email,
	b.DOMAIN_DECODE, 
    b.DOMAIN_ALTERNATE_DECODE,
    user_email
ORDER BY
	b.DOMAIN_ALTERNATE_DECODE,
	
	b.DOMAIN_DECODe,
	user_email
	
    
	go


