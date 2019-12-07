Authors of this code are Cameron Wiener and Celia Ripple 

:: extract the wetland data from planet_osm_polygon
select *
from planet_osm_polygon
where "natural" = 'wetland'
or wetland is not null

:: add a new column to a table and give drains a subward identification
alter table drains add column subward integer;
update drains
set subward = fid
from subwards
where st_intersects(drains.geom, subwards.geom)

:: eliminate drains without a spatial data
select* from drains
where drains.subward is null 

:: sum the drains by their subward id
select count(subward) as subwardcount, subward
from drains
group by subward

:: make a temporary table of this infomation
create view subwardcount1 as 
select count(subward) as subwardcount, subward 
from drains
group by subward

:: add a column for the drains on the subwards layer, and add the drains onto subwards 
alter table subwards add column draincount integer; 
update subwards 
set draincount = subwardcount 
from subwardcount1 
where subwardcount1.subward = subwards.fid

::find the area of the subwards 
select fid, draincount, st_area(geography(geom)) as area1 
from subwards 

:: add a column to subwards for the area. Add the area onto subwards
alter table subwards add column aream2 float8;
update subwards 
set aream2 = subward_area.area1
from subward_area 
where subwards.fid = subward_area.fid

:: add a column to subwards for the drain density and calculate a density. 
alter table subwards add column draindensitykm2 float8;
select fid, aream2, draincount, draincount/(aream2/1000000) as draindensity 
from subwards 

::add the drain density information to subwards 
update subwards 
set draindensitykm2 = drain_density.draindensity 
from drain_density
where subwards.fid = drain_density.fid

:: make all subwards without drain density null. 
select fid, draindensitykm2, geom
from subwards_drains
where draindensitykm2 is null



