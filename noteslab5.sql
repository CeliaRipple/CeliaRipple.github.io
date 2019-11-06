select *
from planet_osm_polygon
where "natural" = 'wetland'
or wetland is not null

:: add a new column to a table
alter table drains add column subward integer

update drains
set subward = fid
from subwards
where st_intersects(drains.geom, subwards.geom)

select* from drains
where drains.subward is null 

select count(subward) as subwardcount, subward
from drains
group by subward

create view subwardcount1 as 
select count(subward) as subwardcount, subward 
from drains
group by subward

alter table subwards add column draincount integer 

update subwards 
set draincount = subwardcount 
from subwardcount1 
where subwardcount1.subward = subwards.fid

select fid, draincount, st_area(geography(geom)) as area1 
from subwards 

alter table subwards add column aream2 float8

update subwards 
set aream2 = subward_area.area1
from subward_area 
where subwards.fid = subward_area.fid

alter table subwards add column draindensitykm2 float8

select fid, aream2, draincount, draincount/(aream2/1000000) as draindensity 
from subwards 

update subwards 
set draindensitykm2 = drain_density.draindensity 
from drain_density
where subwards.fid = drain_density.fid

alter table subwards add column wetland1 boolean


select fid, draindensitykm2, geom
from subwards_drains
where draindensitykm2 is null



