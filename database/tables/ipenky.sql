-- Create ipenky db table
CREATE TABLE overview_75k.ipenky(
  fid SERIAL PRIMARY KEY,
  id INTEGER,
  info VARCHAR(255),
  rotation INTEGER,
  x FLOAT,
  y FLOAT,
  geom GEOMETRY(Point, 5514),
  created_by VARCHAR(255),
  date_created TIMESTAMPTZ,
  modified_by VARCHAR(255),
  date_modified TIMESTAMPTZ
);

-- Create spatial index
CREATE INDEX ipenky_geom_x
	ON overview_75k.ipenky USING GIST (geom);

-- Create trigger for generating coordinates and info about creating/updating
CREATE TRIGGER ipenky_trigger
BEFORE UPDATE OR INSERT ON overview_75k.ipenky 
	FOR EACH ROW EXECUTE PROCEDURE public.metadata_coordinates_tf();
