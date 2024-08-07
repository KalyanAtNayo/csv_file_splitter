SELECT t.*,
invoice_type_api.get_description_db(t.company,(party_type_api.encode(t.party_type)), t.invoice_type) invoicetypedescription,
customer_info_api.get_name(identity) customername,
DECODE(nvl(charge_seq_no, rma_charge_no) ,null, 'FALSE', 'TRUE') Charge,
customer_order_inv_item_api.get_tot_discount_for_ivc_item(company,invoice_id,item_id) totalorderlinediscount,
source_tax_item_api.get_tax_code_percentage(company, 'INVOICE', invoice_id, item_id, '*', '*', '*', vat_code) taxrate,
source_tax_item_api.multiple_tax_items_exist(company, 'INVOICE', invoice_id, item_id, '*', '*', '*') multipletaxlines,
invoice_type_api.get_correction_invoice_db(company, 'CUSTOMER', invoice_type) correctioninvoice,
customer_order_inv_item_api.get_condition_code(company, invoice_id, item_id) conditioncode,
condition_code_api.get_description(customer_order_inv_item_api.get_condition_code(company, invoice_id, item_id)) conditioncodedescription,
project_api.get_program_id(customer_order_line_api.get_project_id(order_no, line_no, release_no, line_item_no)) programid,
project_program_global_api.get_description(project_api.get_program_id(customer_order_line_api.get_project_id(order_no, line_no, release_no, line_item_no))) programdescription,
customer_order_line_api.get_project_id(order_no, line_no, release_no, line_item_no) projectid,
project_api.get_name(customer_order_line_api.get_project_id(order_no, line_no, release_no, line_item_no)) projectname,
activity_api.get_sub_project_id(customer_order_line_api.get_activity_seq(order_no, line_no, release_no, line_item_no)) subprojectid,
activity_api.get_sub_project_description(customer_order_line_api.get_activity_seq(order_no, line_no, release_no, line_item_no)) subprojectdescription,
activity_api.get_activity_no(customer_order_line_api.get_activity_seq(order_no, line_no, release_no, line_item_no)) activityid,
activity_api.get_description(customer_order_line_api.get_activity_seq(order_no, line_no, release_no, line_item_no)) activitydescription,
currency_code_api.get_currency_rounding( company, currency) rounding,
rental_transaction_manager_api.calculate_chargeable_days(rental_transaction_id) invoiceddurationdays,
rental_mode_api.get_description(rental_transaction_api.get_rental_mode_id(rental_transaction_id)) rentalmodedescription,
customer_order_line_api.get_activity_seq(order_no, line_no, release_no, line_item_no) activitysequence,
invoice_api.get_due_date(company, invoice_id) duedate,
company_localization_info_api.get_parameter_value_db(company, 'ACQUISITION_ORIGIN') acquisitionoriginenabled,
company_localization_info_api.get_parameter_value_db(company, 'GOOD_SERVICE_STATISTICAL_CODE') goodservicestatisticalcodeenabled,
DECODE(DISC_PRICE_ROUND,'TRUE',DECODE(USE_PRICE_INCL_TAX_DB, 'FALSE',ORIGINAL_DISCOUNT, DISCOUNT),DISCOUNT) Discount,
DECODE(DISC_PRICE_ROUND,'TRUE',DECODE(USE_PRICE_INCL_TAX_DB, 'FALSE',ORIGINAL_ORDER_DISCOUNT, ORDER_DISCOUNT),ORDER_DISCOUNT) OrderDiscount,
DECODE(DISC_PRICE_ROUND,'TRUE',DECODE(USE_PRICE_INCL_TAX_DB, 'FALSE',ORIGINAL_ADD_DISCOUNT, ADDITIONAL_DISCOUNT),ADDITIONAL_DISCOUNT) AdditionalDiscount
FROM CUSTOMER_ORDER_INV_JOIN t
WHERE to_date(t.invoice_date, 'DD-MON-YY') between to_date('01-NOV-18', 'DD-MON-YY') AND  to_date('31-MAR-24', 'DD-MON-YY');
