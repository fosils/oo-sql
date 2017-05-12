CREATE OR REPLACE FUNCTION public.already_given_customer_authorizations(eindkomst yes_no_unknown, lønsum yes_no_unknown, selvangivelse_selskaber yes_no_unknown, udbytte yes_no_unknown, selvangivelse_personlig yes_no_unknown, skattekonto yes_no_unknown, moms yes_no_unknown) RETURNS varchar[] LANGUAGE sql IMMUTABLE STRICT AS $body$
SELECT
CASE WHEN "eindkomst" = 'yes' THEN '{e-indkomst}'::varchar[] ELSE '{}'::varchar[] END ||
CASE WHEN "lønsum" = 'yes' THEN '{lønsum}'::varchar[] ELSE '{}'::varchar[] END ||
CASE WHEN "selvangivelse_selskaber" = 'yes' THEN '{selvangivelse_selskaber}'::varchar[] ELSE '{}'::varchar[] END ||
CASE WHEN "udbytte" = 'yes' THEN '{udbytte}'::varchar[] ELSE '{}'::varchar[] END ||
CASE WHEN "selvangivelse_personlig" = 'yes' THEN '{selvangivelse_personlig}'::varchar[] ELSE '{}'::varchar[] END ||
CASE WHEN "skattekonto" = 'yes' THEN '{skattekonto}'::varchar[] ELSE '{}'::varchar[] END ||
CASE WHEN "moms" = 'yes' THEN '{moms}'::varchar[] ELSE '{}'::varchar[] END
$body$;
