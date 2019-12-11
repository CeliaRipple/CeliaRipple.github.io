# Final Project 

# Introduction 

For my final project I decided to use the pgrouting function of PostGIS along with OSM data to evaluate the "walkability" of routes in Philadelphia. 
Improving the walkability of cities is a current focus for urban planners. There are some cities in the U.S. that are seen as more walkable than others. With this project I want to look at what makes a city walkable and evaluate if pgrouting can be used as a tool to assess the walkability of routes in a city. 

# Process
First I exported the OSM data on the city of Philadelphia from [Open street map](https://www.openstreetmap.org/#map=11/40.0026/-75.2385) 
The file that I downloaded included a data layer, planet_osm_roads, of the roads in Philadelphia. This is the main layer I worked with in pgrouting. To upload the data into my database I used osm2pgsql which can be found here: https://github.com/openstreetmap/osm2pgsql
Once the data has been loaded into the database the first step is to prepare the planet_osm_roads layer to be used for routing by creating topology. This step marks the verticies between road segments. These "nodes" will be used to locate the start and end points on roads while routing. 

Start by adding columns to the planet_osm_roads layer
```sql
Alter table planet_OSM_roads Add column source integer;
Alter table planet_OSM_roads Add column target integer
```
