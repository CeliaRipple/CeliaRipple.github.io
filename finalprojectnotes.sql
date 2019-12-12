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

::analyze the topology. I do not know what was supposed to come out of this. 
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

::visulize on the map does not work----
select from planet_osm_roads
where edge in (select edge from shortest)

alter table planet_osm_roads add column walkingroute integer;
update planet_osm_roads
set walkingroute = edge
from shortest
where osm_id = edge

:: select by attribute 
"walkingroute" is not null
export selected features > walkingroute

ALTER TABLE planet_osm_roads ADD COLUMN traveltime double precision;
UPDATE planet_osm_roads SET traveltime = cost / 6000



::: DAR ES SALAM
:: create topology 

Alter table roads Add column source integer;
Alter table roads Add column target integer

SELECT pgr_createTopology('roads', 0.001, 'geom', 'id')

SELECT pgr_analyzeGraph('roads', 0.001, the_geom := 'geom', id := 'id')

::cost as distance 
ALTER TABLE roads ADD COLUMN cost double precision;
UPDATE roads SET cost = st_length(geography(geom))

:: weird extra step?
CREATE INDEX source_idx ON roads(source);
CREATE INDEX target_idx ON roads(target);
CREATE INDEX geom_idx ON roads USING GIST(geom);


ALTER TABLE roads ADD COLUMN traveltime double precision;
UPDATE roads SET traveltime = cost / 6000

:::osm line
change into NAD83 2272
ALTER TABLE planet_osm_line
 ALTER COLUMN way TYPE geometry(linestring,2272) 
  USING st_transform(way,2272);

Alter table validlines Add column source integer;
Alter table validlines Add column target integer

SELECT pgr_createTopology('planet_osm_line', 0.00001, 'way', 'osm_id')

ALTER TABLE planet_osm_line ADD COLUMN cost double precision;
UPDATE planet_osm_line SET cost = st_length(geography(way))


Create table walkingroute2 as
SELECT * FROM pgr_dijkstra(
    'SELECT osm_id AS id, source, target, cost FROM planet_osm_roads',
    2633, ARRAY[2350,3346,3710],
    true)
	
	alter table planet_osm_roads add column walkingroute2 int
	
	update planet_osm_roads 
set walkingroute2 = edge
from walkingroute2
where osm_id = edge
 

