--Find Hoonuit roles as defined in Synergy

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


