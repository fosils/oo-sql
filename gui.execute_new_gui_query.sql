CREATE OR REPLACE FUNCTION gui.execute_new_gui_query()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    f_need_update BOOL := (OLD.name IS DISTINCT FROM NEW.name) OR (OLD.query IS DISTINCT FROM NEW.query);
    f_query RECORD;
BEGIN
    IF OLD.name <> '' AND f_need_update THEN
        EXECUTE 'DROP VIEW IF EXISTS gui.' || quote_ident(OLD.name) || ' CASCADE';
    END IF;
    IF NEW.name <> '' AND f_need_update AND COALESCE(NEW.query, '') <> '' THEN
        PERFORM gui.create_view(NEW.name, NEW.query);
        INSERT INTO gui.windows_history (category, name, query) VALUES (NEW.category, NEW.name, NEW.query);
        IF OLD.query IS DISTINCT FROM NEW.query THEN
            PERFORM gui.open_new_window(get_current_user(), NEW.id);
        END IF;
    END IF;
    IF COALESCE(NEW.fk_queries, '') <> '' AND OLD.fk_queries IS DISTINCT FROM NEW.fk_queries THEN
        FOR f_query IN SELECT unnest(string_to_array(NEW.fk_queries, ';')) AS q LOOP
            EXECUTE f_query.q;
        END LOOP;
    END IF;
    RETURN NEW;
END
$function$
