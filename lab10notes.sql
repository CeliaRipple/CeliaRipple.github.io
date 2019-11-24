select addgeometrycolumn('november' ,  'geom' , 102004, 'point',2)
update november
set geom = st_transform(st_setsrid(st_makepoint(lng,lat), 4326),  102004)

select addgeometrycolumn('dorian' ,  'geom' , 102004, 'point',2);
update dorian
set geom = st_transform(st_setsrid(st_makepoint(lng,lat), 4326),  102004)

update counties 
set geometry = st_transform(geometry,102004)

select addgeometrycolumn('counties' ,  'geom' , 102004, 'point',2);

select 
populate_geometry_columns('public.counties'::regclass)

delete from counties 
where "STATEFP"
not in('54', '51', '50', '47', '45', '44', '42', '39', '37', '36', '34', '33', '29', '28', '25', '24', '23', '22', '21', '18', '17', '13', '12', '11', '10', '09', '05', '01')

alter table november add column geoid varchar(5)

alter table counties add column _geoid varchar(5)

update counties 
set _geoid="GEOID"

update november
set geoid = _geoid
from counties
where st_intersects(counties.geometry, november.geom)

alter table dorian add column geoid varchar(5)

update dorian
set geoid = _geoid
from counties
where st_intersects(counties.geometry, dorian.geom)

alter table counties
add column tweetscount integer

alter table counties
add column tweetscountdorian integer

select count(geoid) as tweetcount, geoid
from november
group by geoid
create view tweetspercounty

update counties 
set tweetscountdorian = 0

update counties 
set tweetscount = 0

create table doriancounts as 
select geoid, count(dorian.geoid) as count 
from dorian 
group by dorian.geoid

update counties 
set tweetscount = tweetcount 
from tweetspercounty
where counties._geoid = tweetspercounty.geoid

update counties 
set tweetscountdorian = count
from doriancounts
where counties._geoid = doriancounts.geoid

alter table counties add column doriantweetrate float 

::did not use in the end::
alter table counties 
add column population integer; 
update counties 
set population = "POP"

update counties 
set doriantweetrate = ((1*1.0000)*( tweetscountdorian/"POP"))*10000

alter table counties add column ndti real 

update counties 
set ndti = (tweetscountdorian - tweetscount)/ (tweetscountdorian + tweetscount)
Where tweetscount > 0 or tweetscountdorian > 0 

