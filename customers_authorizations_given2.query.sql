select id, primary_email, name,
"eindkomst",
"lønsum",
"selvangivelse_selskaber",
"udbytte",
"selvangivelse_personlig",
"skattekonto",
"moms",
already_given_customer_authorizations(id) @> all_required_customer_authorizations(id) AS all_authorizations_given,
all_required_customer_authorizations(id),
already_given_customer_authorizations(id),
(SELECT ARRAY(SELECT unnest(all_required_customer_authorizations(id)) EXCEPT SELECT unnest(already_given_customer_authorizations(id)))) AS missing_authorizations
from customers
where potential_customer is true
order by id
