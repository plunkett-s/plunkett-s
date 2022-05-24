select school_key, school_name, school_grades_group from 
K12INTEL_DW.DTBL_SCHOOLS where district_code = '2082' 
--and school_name not like ('z%')
--and school_name not like ('~%')
and school_name not like ('OUT OF DISTRICT%')
and  school_name not like ('Oregon valley%')
and (school_key in (1,2,41,7,1032,3659,10,12,19,22,26,27,31,40,44,45,49,68,69)) --traditional elementary
--or school_key in (37,1043,3685,33,35,36) --traditional high
--or school_key in (133,15,16,4,17,21,23,25)) --traditional middlle

order by school_grades_group,school_name
go

