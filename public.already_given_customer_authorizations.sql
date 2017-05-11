CREATE OR REPLACE FUNCTION public.already_given_customer_authorizations(customer_id integer) RETURNS varchar[] LANGUAGE sql STABLE STRICT AS $body$
SELECT
CASE WHEN "eindkomst" = 'yes' THEN '{e-indkomst}'::varchar[] ELSE '{}'::varchar[] END ||
CASE WHEN "lønsum" = 'yes' THEN '{lønsum}'::varchar[] ELSE '{}'::varchar[] END ||
CASE WHEN "selvangivelse_selskaber" = 'yes' THEN '{selvangivelse_selskaber}'::varchar[] ELSE '{}'::varchar[] END ||
CASE WHEN "udbytte" = 'yes' THEN '{udbytte}'::varchar[] ELSE '{}'::varchar[] END ||
CASE WHEN "selvangivelse_personlig" = 'yes' THEN '{selvangivelse_personlig}'::varchar[] ELSE '{}'::varchar[] END ||
CASE WHEN "skattekonto" = 'yes' THEN '{skattekonto}'::varchar[] ELSE '{}'::varchar[] END ||
CASE WHEN "moms" = 'yes' THEN '{moms}'::varchar[] ELSE '{}'::varchar[] END
FROM customers
WHERE id = customer_id
$body$
