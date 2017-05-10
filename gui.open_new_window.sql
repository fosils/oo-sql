CREATE OR REPLACE FUNCTION gui.open_new_window(p_username text, p_viewid integer, p_x integer DEFAULT NULL::integer, p_y integer DEFAULT NULL::integer, p_width integer DEFAULT NULL::integer, p_height integer DEFAULT NULL::integer, p_id text DEFAULT NULL::text, p_colname text DEFAULT NULL::text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
v_payload text;
BEGIN
v_payload := COALESCE(p_username, '') || ',' || p_viewid::text || ',' || COALESCE(p_x::text, '') || ',' || COALESCE(p_y::text, '') || ',' || COALESCE(p_width::text, '') || ',' || COALESCE(p_height::text, '') || ',' || COALESCE(p_id, '') || ',' || COALESCE(p_colname, '');
EXECUTE 'NOTIFY open_new_window, ''' || v_payload || '''';
END
$function$
