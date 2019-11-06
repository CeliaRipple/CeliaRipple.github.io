In this lab we accessed data about Dar es Salam from the Resilience Academy from Ramani Huria to do a vulnerability
anaylsis for Dar es Salam. 

We used PostGres SQL to process our data for analysis and QGIS to visualize the outputs.

My partner and I chose to look at the density of storm drains by subward to examine how something like storm drain 
infrastructure can affect vulnerability to floods.  
our analysis used data on the storm drains as points from the Resilence Academy.
subward divsions also obtained from Reilience Academy. 
We also used data from Open Street Map to look at the wetlands extent. 
Our final drain density map with the wetlands extent can be found here:
[Drain Density Map](qgis2web_2019_10_24-16_05_38_137842/index.html)

An explanation of our process:
to find the density of drains it was necessary to asign a subward to each drain point based on the 
location. To do this we must add a column to the drains layer using this sql function:

alter table drains add column subward integer

Then we did a spatial intersect that would assign a subward to the drain using this sql function 

update drains
set subward = fid
from subwards
where st_intersects(drains.geom, subwards.geom)

Then we selected every input where the subward was assigned as NULL:

select* from drains
where drains.subward is null 

because these were points where 
the drain had not been assigned a real place in space and so could not be used for analysis. This is a potential 
source of error since some drains had to be deleted. 

next we wanted to count all the drains that had the same subward identification and group them together under their subward id 
so that they can be joined to the subwards layer in the next step. 

select count(subward) as subwardcount, subward
from drains
group by subward

we "created a view" from this information so that it this information could be added to the subwards layer. we named
the view "subwardcount1"

next we added a column to the subwards layer and called it "draincount"

alter table subwards add column draincount integer 

then we joined the information from the "subwardcount1" layer to the "draincount" field through an update table function

update subwards 
set draincount = subwardcount 
from subwardcount1 
where subwardcount1.subward = subwards.fid

Now that we have the drains and the subwards on one layer and they are joined spatially, we can move on to calculating 
the area of the subwards which we will use to calucate the density of the drains by subward.
Sql for calucualting area geodesically:

select fid, draincount, st_area(geography(geom)) as area1 
from subwards

We created a view from this information and called it "subward_area"
then We added an area column to the subwards layer and named it aream2 because the area was calucualted in m^2

alter table subwards add column aream2 float8

then we used the update table function to add this information onto the subwards layer:

update subwards 
set aream2 = subward_area.area1
from subward_area 
where subwards.fid = subward_area.fid

then we added a column for the drain density and named it "draindensitykm2"

alter table subwards add column draindensitykm2 float8

Then we calculated drain density by dividing the draincount by the area of the subwards and by 1000000 so that
the calculation would be in km^2 so that it is easier to understand.

select fid, aream2, draincount, draincount/(aream2/1000000) as draindensity 
from subwards 

we created a view from this information and called it "drain_density" and added this information 
to the subwards layer using an update table function 

update subwards 
set draindensitykm2 = drain_density.draindensity 
from drain_density
where subwards.fid = drain_density.fid

Finally we wanted to select only the subwards on the map that had drain data so that our map would be smaller and easier 
to visulize. we did this by selecting all the subwards where the draindensitykm2 was not null.

select fid, draindensitykm2, geom
from subwards_drains
where draindensitykm2 is null

We completed the section that calculated drain density of each subward in km^2 

The next step is to pull the wetland information from the OSM data so that we can create a layer that shows what subwards
lie in the wetlands. 
To do this, we know that every cell is assigned to a category of land type under the "natural" column in the planet_osm_polygon
layer and wetland areas are labeled as "wetland". we also discovered that there is a wetland column that will designate some cells
as wetland and all others will be labled as NULL. We selected cells that met either of these two criteria.
We used this sql function: 

select *
from planet_osm_polygon
where "natural" = 'wetland'
or wetland is not null

in our final map the wetland layer is placed over the subward density layer so that the viewer can analyze whether the subwards with 
the highest density are in fact in the wetland area.  

here is a link to look at all the sql functions we used from start to finish [SQl](noteslab5.sql)





