CREATE OR REPLACE FUNCTION public.all_required_customer_authorizations(customer_id integer) RETURNS varchar[] LANGUAGE sql STABLE STRICT AS $body$
SELECT customer_authorization(get_extra_packages_previous_year_array(id), get_extra_packages_current_year_array(id), get_service_package_previous_year(id), get_service_package_current_year(id), company_type, has_employees, vat_type)
FROM customers
WHERE id = customer_id
$body$
