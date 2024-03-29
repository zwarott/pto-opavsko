-- Create trigger function for updating metadata info (existing data + geometry)
CREATE OR REPLACE FUNCTION public.metadata_update_tf()
RETURNS trigger AS $$
BEGIN
    RAISE NOTICE 'Trigger fired';
    -- Update default metadata for every update operation
    NEW.date_modified = now();
    NEW.modified_by = current_user;

    -- Update default metadata only if the geometry column is changed
    IF NEW.geom IS DISTINCT FROM OLD.geom THEN
        RAISE NOTICE 'Geometry changed';
        NEW.date_modified = now();
        NEW.modified_by = current_user;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
