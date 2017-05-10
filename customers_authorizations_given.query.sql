select id, primary_email, name,
"eindkomst",
"lønsum",
"selvangivelse_selskaber",
"udbytte",
"selvangivelse_personlig",
"skattekonto",
"moms",
CASE WHEN "eindkomst" = 'yes' THEN '{eindkomst}'::varchar[] ELSE '{}'::varchar[] END ||
CASE WHEN "lønsum" = 'yes' THEN '{lønsum}'::varchar[] ELSE '{}'::varchar[] END ||
CASE WHEN "selvangivelse_selskaber" = 'yes' THEN '{selvangivelse_selskaber}'::varchar[] ELSE '{}'::varchar[] END ||
CASE WHEN "udbytte" = 'yes' THEN '{udbytte}'::varchar[] ELSE '{}'::varchar[] END ||
CASE WHEN "selvangivelse_personlig" = 'yes' THEN '{selvangivelse_personlig}'::varchar[] ELSE '{}'::varchar[] END ||
CASE WHEN "skattekonto" = 'yes' THEN '{skattekonto}'::varchar[] ELSE '{}'::varchar[] END ||
CASE WHEN "moms" = 'yes' THEN '{moms}'::varchar[] ELSE '{}'::varchar[] END @> customer_authorization(get_extra_packages_previous_year_array(id), get_extra_packages_current_year_array(id), get_service_package_previous_year(id), get_service_package_current_year(id), company_type, has_non_equity_employees, vat_type) AS all_authorizations_given
from customers
where potential_customer is true
order by id
