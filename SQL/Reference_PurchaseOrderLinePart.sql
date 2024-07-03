SELECT t.*, Pur_Ord_Date_Calculation_API.Get_Latest_Possible_Order_Date(contract,
                                                                   part_no,
                                                                   vendor_no,
                                                                   Purchase_Order_API.Get_Addr_No(order_no),
                                                                   ship_via_code,
                                                                   ext_transport_calendar_id,
                                                                   planned_receipt_date,
                                                                   internal_control_time,
                                                                   route_id,
                                                                   date_entered,
                                                                   external_service_type_ => service_type) latest_order_date,
       DECODE(Document_Text_API.Note_Id_Exist(note_id),
              '1',
              'TRUE',
              'FALSE') document_text_db,
       Purchase_Order_Line_Part_API.Get_Total_In_Order_Curr(order_no,
                                                            line_no,
                                                            release_no) net_amt_curr,
       Purchase_Order_Line_Part_API.Get_Line_Total(order_no,
                                                   line_no,
                                                   release_no) net_amount_base,
       Purchase_Order_Line_Part_API.Get_Line_Total_Incl_Tax(order_no,
                                                            line_no,
                                                            release_no) gross_amt_base,
       Purchase_Order_Line_Part_API.Get_Total_Incl_Tax_Curr(order_no,
                                                            line_no,
                                                            release_no) gross_amt_curr,
       decode(taxable_db, 'TRUE', 'TRUE', 'FALSE') taxable_db,
       Statutory_Fee_API.Get_Description(company, fee_code) fee_code_description,
       Source_Tax_Item_API.Multiple_Tax_Items_Exist(company,
                                                    'PURCHASE_ORDER_LINE',
                                                    order_no,
                                                    line_no,
                                                    release_no,
                                                    '*',
                                                    '*') multiple_tax_lines_db,
       Purchase_Util_API.Get_Invoiced_Curr_Rate(currency_rate,
                                                company,
                                                currency_code) currency_rate2,
       DECODE(Purchase_Part_Supplier_API.Get_Orders_Price_Option_Db(purchase_site,
                                                                    part_no,
                                                                    vendor_no),
              'SENDPRICE',
              'TRUE',
              'FALSE') send_order_price,
       Delivery_Control_Code_API.Get_Description(delivery_control_code) delivery_control_code_desc,
       Inspection_Rule_API.Get_Description(inspection_code) inspection_code_description,
       Purchase_Part_Supplier_API.Get_Calc_Rounded_Qty(contract,
                                                       part_no,
                                                       vendor_no,
                                                       qty_to_inspect,
                                                       'ADD') qty_to_inspect,
       decode(inventory_part_db, 'TRUE', 'TRUE', 'FALSE') inventory_part_db,
       Supplier_Assortment_API.Get_Description(assortment) supplier_assortment_description,
       DECODE(part_ownership_db,
              'CUSTOMER OWNED',
              owning_customer_no,
              'CONSIGNMENT',
              vendor_no,
              'SUPPLIER LOANED',
              vendor_no) owner,
       DECODE(part_ownership_db,
              'COMPANY OWNED',
              NULL,
              Customer_Info_API.Get_Name(owning_customer_no)) owning_customer_name,
       Inventory_Transaction_Hist_API.Check_Receipt_In_Place(order_no,
                                                             line_no,
                                                             release_no) received_in_place_db,
       Purchase_Requisition_API.Get_Receiver(requisition_no) requisition_ordered_for,
       Purchase_Order_Milestone_API.Milestone_Exist(order_no,
                                                    line_no,
                                                    release_no) milestone_stage_payment_exists_db,
       NVL(Pur_Order_Cust_Order_Comp_API.Get_Cust_Order_No(order_no,
                                                           line_no,
                                                           release_no),
           Pur_Order_Exchange_Comp_API.Get_Cust_Order_No(order_no,
                                                         line_no,
                                                         release_no)) customer_order_no,
       NVL(project_id, '*') project_id1,
       CASE
         WHEN project_id IS NULL THEN
          '*'
         WHEN activity_seq > 0 THEN
          project_id
         ELSE
          '*'
       END project_id2,
       Project_API.Get_Program_Id(project_id) program_id,
       Project_Program_Global_API.Get_Description(Project_API.Get_Program_Id(project_id)) program_description,
       Project_API.Get_Name(PROJECT_ID) project_name,
       Activity_API.Get_Sub_Project_Id(activity_seq) sub_project_id,
       Activity_API.Get_Sub_Project_Description(activity_seq) sub_project_description,
       Activity_API.Get_Activity_No(activity_seq) activity_no,
       Activity_API.Get_Description(activity_seq) activity_description,
       DECODE(demand_code_db, 'WO', TO_NUMBER(demand_order_no)) work_order_no,
       DECODE(demand_code_db, 'DOP', TO_NUMBER(demand_release)) dop_order_id,
       DECODE(Pre_Accounting_API.Distribution_Exist(pre_accounting_id),
              '1',
              'TRUE',
              'FALSE') distributed_pre_posting_db,
       decode(create_fa_obj_db, 'TRUE', 'TRUE', 'FALSE') create_fa_obj_db,
       decode(fa_obj_per_unit_db, 'TRUE', 'TRUE', 'FALSE') fa_obj_per_unit_db,
       DECODE(warranty_id, NULL, 'FALSE', 'TRUE') supplier_warranty_db,
       Order_Cancel_Reason_API.Get_Reason_Description(cancel_reason) cancel_reason_description,
       Purchase_Order_Line_API.Get_Due_At_Dock(order_no,
                                               line_no,
                                               release_no) due_at_dock,
       Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(part_no) serial_handled_db,
       Part_Catalog_API.Get_Lot_Tracking_Code_Db(PART_NO) lot_handled_db,
       Part_Gtin_API.Get_Default_Gtin_No(part_no) gtin_no,
       Company_Invent_Info_API.Get_Uom_For_Weight(company) weight_uom,
       Company_Invent_Info_API.Get_Uom_For_Volume(company) volume_uom,
       decode(intrastat_affected_db, 'TRUE', 'TRUE', 'FALSE') intrastat_affected_db,
       Quotation_Line_Part_Ord_API.Get_Po_Connected_Inquiry_No(order_no,
                                                               line_no,
                                                               release_no,
                                                               vendor_no) request_no,
       Quotation_Line_Part_Ord_API.Get_Po_Connected_Line_No(order_no,
                                                            line_no,
                                                            release_no,
                                                            vendor_no) request_line_no,
       Quotation_Line_Part_Ord_API.Get_Po_Connected_Revision_No(order_no,
                                                                line_no,
                                                                release_no,
                                                                vendor_no) request_revision_no,
       decode(rental_db, 'TRUE', 'TRUE', 'FALSE') rental_db,
       decode(external_project_resource_db, 'TRUE', 'TRUE', 'FALSE') external_project_resource_db,
       nvl2(NULL,
            to_date('1970-01-01-' || to_char(NULL, 'HH24.MI.SS'),
                    'YYYY-MM-DD-HH24.MI.SS'),
            null) planned_rental_start_time,
       Purchase_Order_Line_Part_API.Is_Cro_Attached(demand_code_db,
                                                    demand_order_no,
                                                    demand_release,
                                                    demand_sequence_no) cro_attached_db,
       Purchase_Part_API.Get_Stat_Grp(purchase_site, part_no) stat_grp,
       Purchase_Part_Group_API.Get_Description(Purchase_Part_API.Get_Stat_Grp(purchase_site,
                                                                              part_no)) stat_grp_description,
       SUBSTR(Purchase_Part_API.Get_Std_Name(contract, part_no), 1, 25) standard_name,
       Purch_Line_Revision_Status_API.Get_Purch_Revision_Status_Db(order_no,
                                                                   line_no,
                                                                   release_no) purch_revision_status,
       Supplier_Info_API.Get_Name(invoicing_supplier) invoicing_supplier_name,
       Condition_Code_API.Get_Description(condition_code) condition_code_description,
       Order_Proc_Type_API.Get_Description(process_type) process_type_description,
       External_Service_Type_API.Get_Description(service_type) service_type_description,
       Packing_Instruction_API.Get_Description(packing_instruction_id) packing_instruction_description,
       Purchase_Order_Line_API.Fully_Arrived(order_no, line_no, release_no) fully_arrived_db,
       DECODE(demand_code_db,
              'DOP',
              Dop_Order_API.Get_Objstate(demand_order_no, demand_release)) dop_objstate,
       'FALSE' replicate_columns_modified,
       'FALSE' replicate_packing_instruction_id,
       Purchase_Order_Line_Part_API.Get_Ord_Conf_For_Cust(order_no,
                                                          line_no,
                                                          release_no) allow_order_confirmation,
       'FALSE' tax_code_flag_db,
       'FALSE' tax_edited_db,
       'TRUE' method_state_db,
       'FALSE' disconnect_exp_license,
       'TRUE' fetch_tax_codes,
       Part_Serial_Rule_API.Encode(Part_Catalog_API.Get_Serial_Rule(part_no)) serial_rule,
       Serial_No_Reservation_API.Get_Count_Reservation(order_no,
                                                       line_no,
                                                       release_no,
                                                       NULL,
                                                       'PURCHASE ORDER',
                                                       part_no) count_reservation,
       External_Service_Price_API.Get_External_Service_Lead_Time(contract,
                                                                 part_no,
                                                                 vendor_no,
                                                                 service_type) external_service_lead_time,
       Manufacturer_Info_API.Get_Country(manufacturer_id) country,
       Purchase_Req_Line_API.Get_Delivery_Method_Db(requisition_no,
                                                    req_line,
                                                    req_release) delivery_method,
       Assortment_Node_API.Get_Description(category_assortment,
                                           category_assortment_node) category_assortment_node_desc,
       DECODE(Purchase_Order_API.Is_Component_Installed('MFGSTD'),
              1,
              'TRUE',
              'FALSE') is_mfgstd_installed,
       Inventory_Part_API.Get_Second_Commodity(Contract, Part_No) commodity_group2,
       DECODE(Connected_Phrase_API.Check_Phrase_Exists('PURCHASE_ORDER_LINE',
                                                       order_no,
                                                       line_no,
                                                       release_no,
                                                       '*',
                                                       '*'),
              1,
              'TRUE',
              'FALSE') contract_clauses_exist,
       'SUPPLIER' party_type_supplier,
       Income_Type_API.Get_Income_Type_Id(internal_income_type) income_type_id,
       Identity_Invoice_Info_API.Is_Cis_Supplier(company,
                                                 invoicing_supplier,
                                                 Party_Type_API.Decode('SUPPLIER')) is_supplier_cis,
       (SELECT value1
          FROM (SELECT contract             key1,
                       part_no              key2,
                       eng_chg_level        key3,
                       technical_drawing_no value1
                  FROM PART_REVISION)
         WHERE contract = key1
           AND part_no = key2
           AND eng_chg_level = key3) technical_drawing_no
  FROM PURCHASE_ORDER_LINE_PART_CFV t
 WHERE RENTAL_DB = 'FALSE'
 AND to_date(substr(OBJVERSION, 0, 8), 'YYYYMMDD') between to_date('20181101', 'YYYYMMDD') AND  to_date('20240331', 'YYYYMMDD');