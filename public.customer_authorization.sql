CREATE OR REPLACE FUNCTION crm.customer_authorization(extra_packages_previous_year character varying[], extra_packages_current_year character varying[], service_package_previous_year character varying, service_package_current_year character varying, company_type company_type_enum, has_non_equity_employees character varying, vat_type character varying)
 RETURNS character varying[]
 LANGUAGE plpgsql
 IMMUTABLE
AS $function$
DECLARE
    v_return varchar[] := '{}';
BEGIN
    IF service_package_previous_year <> 'whitelabel' AND service_package_current_year <> 'whitelabel' THEN
        IF service_package_previous_year NOT IN ('Holding', 'Privat selvangivelse', 'Only annual rental') AND
           service_package_current_year NOT IN ('Holding', 'Privat selvangivelse', 'Only annual rental') AND
           has_non_equity_employees IN ('unknown', 'yes')
        THEN
            v_return := v_return || '{e-indkomst}';
        END IF;
        IF vat_type IN ('Lønsum') THEN
            v_return := v_return || '{lønsum}';
        END IF;
        IF (service_package_previous_year IN ('Plus', 'Holding', 'Only annual report', 'Plus-CBIT', 'Only annual rental') OR
            service_package_current_year IN ('Plus', 'Holding', 'Only annual report', 'Plus-CBIT', 'Only annual rental')) AND
           company_type IN ('ApS', 'IVS')
        THEN
            v_return := v_return || '{selvangivelse_selskaber,udbytte}';
        END IF;
        IF (service_package_previous_year IN ('Plus', 'Plus-CBIT', 'Only annual report', 'Only annual rental', 'Privat selvangivelse') OR
            service_package_current_year IN ('Plus', 'Plus-CBIT', 'Only annual report', 'Only annual rental', 'Privat selvangivelse')) AND
           company_type IN ('Enkeltmandsvirksomhed', 'Enkeltmandsvirksomhed-VSO', 'I/S', 'Forening')
        THEN
            v_return := v_return || '{selvangivelse_personlig}';
        END IF;
        IF (service_package_previous_year IN ('Plus', 'Plus-CBIT', 'Holding', 'Only annual report', 'Only annual report rental') OR
            service_package_current_year IN ('Plus', 'Plus-CBIT', 'Holding', 'Only annual report', 'Only annual report rental'))
        THEN
            v_return := v_return || '{skattekonto}';
        END IF;
        IF ((service_package_previous_year IN ('Plus', 'Plus-CBIT') OR
            service_package_current_year IN ('Plus', 'Plus-CBIT')) AND
            vat_type = 'VAT') OR
           ('Momsindberetning' = ANY (COALESCE(extra_packages_previous_year, '{}'::varchar[]) || COALESCE(extra_packages_current_year, '{}'::varchar[])))
        THEN
            v_return := v_return || '{moms}';
        END IF;

        IF v_return = '{}' AND has_non_equity_employees <> 'no' THEN
            v_return := '{unknown}';
        END IF;
    END IF;
    RETURN v_return;
END
$function$
