Author: Celia Ripple 

/*Create point geometry for tweet points and transform to SRS 102004*/
select addgeometrycolumn('november' ,  'geom' , 102004, 'point',2)
update november
set geom = st_transform(st_setsrid(st_makepoint(lng,lat), 4326),  102004)

select addgeometrycolumn('dorian' ,  'geom' , 102004, 'point',2);
update dorian
set geom = st_transform(st_setsrid(st_makepoint(lng,lat), 4326),  102004)

/*Transform the counties layer to 102004*/
update counties 
set geometry = st_transform(geometry,102004)

/* Add geometry column in counties and populate column*/ 
select addgeometrycolumn('counties' ,  'geom' , 102004, 'point',2);
select 
populate_geometry_columns('public.counties'::regclass)

/* delete the unneeded counties from the counties layer*/ 
delete from counties 
where "STATEFP"
not in('54', '51', '50', '47', '45', '44', '42', '39', '37', '36', '34', '33', '29', '28', '25', '24', '23', '22', '21', '18', '17', '13', '12', '11', '10', '09', '05', '01')

/* I had a problem with field names being uppercase. This was an extra step to change the "GEOID" to a lowercase name.*/ 
alter table counties add column _geoid varchar(5)
update counties 
set _geoid="GEOID"

/* join the tweets with the counties using geoid*/
alter table november add column geoid varchar(5);
update november
set geoid = _geoid
from counties
where st_intersects(counties.geometry, november.geom)

alter table dorian add column geoid varchar(5);
update dorian
set geoid = _geoid
from counties
where st_intersects(counties.geometry, dorian.geom)

/* add columns for the counts of tweets november and tweets dorian to the counties layer*/ 
alter table counties
add column tweetscount integer

alter table counties
add column tweetscountdorian integer

/* count november tweets with identical geoid*/ 
select count(geoid) as tweetcount, geoid
from november
group by geoid
create view tweetspercounty

/* set column equal to 0 values cannot be added to these columns unless they are set to 0 first*/ 
update counties 
set tweetscountdorian = 0

update counties 
set tweetscount = 0

/* count Dorian tweets with identical geoid*/
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

/*Caluculate a tweet rate*/
alter table counties add column doriantweetrate float; 
update counties 
set doriantweetrate = ((1*1.0000)*( tweetscountdorian/"POP"))*10000

/* normalize the the dorian tweets by the november tweets*/
alter table counties add column ndti real 
update counties 
set ndti = (tweetscountdorian - tweetscount)/ (tweetscountdorian + tweetscount)
Where tweetscount > 0 or tweetscountdorian > 0 

