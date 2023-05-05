-- Define the function that returns the count of un-geocoded waypoints

CREATE OR REPLACE FUNCTION waypoints_pending_count()
RETURNS integer
LANGUAGE plpgsql AS $$
  BEGIN
  RETURN (SELECT COUNT(*) AS c FROM waypoint_data WHERE geocode_attempts = 0);
  END;
$$;
