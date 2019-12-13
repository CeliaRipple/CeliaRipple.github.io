:: final project pgrouting 
useful link
https://anitagraser.com/2011/02/07/a-beginners-guide-to-pgrouting/ 

::load OSM data, use OSM2PGSQL function to load data into database 

::create topology. This will make the planet_OSM_roads layer useable for routing
:: add source and target columns

Alter table planet_OSM_roads Add column source integer;
Alter table planet_OSM_roads Add column target integer

::create topology 
SELECT pgr_createTopology('planet_osm_roads', 0.00001, 'way', 'osm_id')

::analyze the topology. 
SELECT pgr_analyzeGraph('planet_osm_roads', 0.000001, the_geom := 'way', id := 'osm_id')

::Dijkstra shortest distance only requires "target", "Source", "cost", and "id". Now calculate cost as the length 

	 ALTER TABLE planet_osm_roads ADD COLUMN cost double precision;
UPDATE planet_osm_roads SET cost = st_length(geography(way))

::now calculate shortest distance between two points 
SELECT * FROM pgr_dijkstra(
    'SELECT osm_id AS id,
         source,
         target,
		 cost
		 FROM planet_osm_roads',
    2633, 3710,
    directed := false)
	
create view shortest 

alter table planet_osm_roads add column walkingroute integer;
update planet_osm_roads
set walkingroute = edge
from shortest
where osm_id = edge

:: select by attribute 
"walkingroute" is not null
export selected features > walkingroute

:::osm line transform to Nad 83
change into NAD83 2272
ALTER TABLE planet_osm_line
 ALTER COLUMN way TYPE geometry(linestring,2272) 
  USING st_transform(way,2272);


 

