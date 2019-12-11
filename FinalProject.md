# Final Project 

# Introduction 

For my final project I decided to use the pgrouting function of PostGIS along with OSM data to evaluate the "walkability" of routes in Philadelphia. 
Improving the walkability of cities is a current focus for urban planners. There are some cities in the U.S. that are seen as more walkable than others. With this project I want to look at what makes a city walkable and evaluate if pgrouting can be used as a tool to assess the walkability of routes in a city. 

# Process
First I exported the OSM data on the city of Philadelphia from [Open street map](https://www.openstreetmap.org/#map=11/40.0026/-75.2385) 
The file that I downloaded included a data layer, planet_osm_roads, of the roads in Philadelphia. This is the main layer I worked with in pgrouting. To upload the data into my database I used osm2pgsql which can be found here: https://github.com/openstreetmap/osm2pgsql
Once the data has been loaded into the database the first step is to prepare the planet_osm_roads layer to be used for routing by creating topology. This step marks the verticies between road segments. These "nodes" will be used to locate the start and end points on roads while routing. 

Start by adding columns to the planet_osm_roads layer for the source (start of a segment) and the target (end of a segment).
```sql
Alter table planet_OSM_roads Add column source integer;
Alter table planet_OSM_roads Add column target integer
```
Then use the create topology function 
```sql
SELECT pgr_createTopology('planet_osm_roads', 0.00001, 'way', 'osm_id')
```
This function also creates a new table with just the nodes for the road segments. 

The final step before routing is to create a "cost" column. For this initial analysis I decided to use distance as the cost, but cost could also be time, or other factors. 

Add a column for cost 
``` sql
ALTER TABLE planet_osm_roads ADD COLUMN cost double precision;
UPDATE planet_osm_roads SET cost = st_length(geography(way))
```
Next I chose two locations on the OSM map to route between. I chose the Penn museum and City Hall. For the next routing step, I chose the nodes that were the closest to their locations on the OSM map. Penn museum: 2633 City Hall: 3710
To find the shortest route in between these points I used the pgr_dijikstra function. More information about this function can be found here https://docs.pgrouting.org/2.2/en/src/dijkstra/doc/pgr_dijkstra.html

```sql 
SELECT * FROM pgr_dijkstra(
    'SELECT osm_id AS id,
         source,
         target,
		 cost
		 FROM planet_osm_roads',
    2633, 3710,
    directed := false)
```

The return from this function gives the route by the sequence, the nodes, edges, cost, and aggregated cost which in this example amounts to distance. 

To save this route I created a view called "shortest" 
then used a join to add this route to the planet_osm_roads layer as "walkingroute." 
``` sql
alter table planet_osm_roads add column walkingroute integer;
update planet_osm_roads
set walkingroute = edge
from shortest
where osm_id = edge
```
From here I moved on to visulizing the results in QGIS. I loaded the planet_osm_roads layer into Q along with the OSM standard background map using the QuickMapServices plugin. 

In QGIS I used the select by attribute function where "walkingroute" is not null to select my route on the map. Then I exported my route.  
