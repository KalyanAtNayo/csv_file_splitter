SELECT t.*,
       decode(status_code, '2', 'TRUE', 'FALSE') status_code,
       Site_API.Get_Description(contract) site_description,
       Purchase_Part_API.Get_Description(contract, part_no) part_description,
       Supplier_API.Get_Vendor_Name(vendor_no) supplier_name,
       Statutory_Fee_API.Get_Description(company, fee_code) tax_code_description,
       Packing_Instruction_API.Get_Description(packing_instruction_id) description,
       Purchase_Status_API.Get_Status_Message(status_code, 'IPADD') status_description,
       Contact_Util_API.Get_Supp_Contact_Name(vendor_no,
                                              Supplier_Address_API.Get_Address_No(vendor_no,
                                                                                  Address_Type_Code_API.Get_Client_Value(1)),
                                              contact) contact_name,
       DECODE(warranty_id, NULL, 'FALSE', 'TRUE') supplier_warranty,
       Inspection_Rule_API.Get_Description(inspection_code) inspection_code_description,
       DECODE(Document_Text_API.Note_Id_Exist(note_id),
              '1',
              'TRUE',
              'FALSE') document_text,
       decode(external_service_allowed_db, 'TRUE', 'TRUE', 'FALSE') external_service_allowed_db,
       decode(quick_registered_part_db, 'TRUE', 'TRUE', 'FALSE') quick_registered_part_db,
       Inventory_Part_Planning_API.Get_Next_Order_Date(contract,
                                                       part_no,
                                                       vendor_no) next_order_date,
       Inventory_Part_Planning_API.Get_Days_To_Next_Order_Date(contract,
                                                               part_no,
                                                               vendor_no) days_to_next_order_date,
       Tax_Handling_Purch_Util_API.Supplier_Is_Taxable(company, vendor_no) supplier_taxable,
       Supplier_Info_Msg_Setup_API.Get_Default_Media_Code(vendor_no,
                                                          'ORDERS') media_code,
       Part_Catalog_Api.Get_Configurable_Db(part_no) configurable_db,
       Purchase_Order_API.Is_Msg_Class_Registered(vendor_no,
                                                  'ORDERS',
                                                  Supplier_Info_Msg_Setup_API.Get_Default_Media_Code(vendor_no,
                                                                                                     'ORDERS')) msg_class_registered,
       Supplier_Address_API.Get_Address_No(vendor_no,
                                           Address_Type_Code_API.Get_Client_Value(1)) supplier_address_id,
       Purchase_Part_Supplier_API.Get_Default_Size(contract,
                                                   part_no,
                                                   vendor_no,
                                                   'WEIGHT') net_weight,
       Company_Invent_Info_API.Get_Uom_For_Weight(company) weight_uom,
       Purchase_Part_Supplier_API.Get_Default_Size(contract,
                                                   part_no,
                                                   vendor_no,
                                                   'VOLUME') net_volume,
       Company_Invent_Info_API.Get_Uom_For_Volume(company) volume_uom,
       DECODE(Purchase_Part_API.Is_Inventory_Part(contract, part_no),
              1,
              'TRUE',
              'FALSE') inventory_part,
       Purchase_Part_API.Get_Taxable_Db(contract, part_no) taxable_db,
       Inspection_Rule_API.Get_Inspection_Type_Db(INSPECTION_CODE) inspection_type,
       Inventory_Part_Planning_API.Get_Planning_Method(contract, part_no) inventory_planning_method,
       Inventory_Part_API.Get_Unit_Meas(contract, part_no) inv_unit_meas,
       Supplier_API.Get_Customer_No(vendor_no) customer_exist,
       Sales_Part_API.Get_Catalog_No_For_Purch_No(contract, part_no) sales_part_exist,
       Purchase_Quantity_Price_API.Check_Active_Price_Lines_Exist(contract,
                                                                  part_no,
                                                                  vendor_no,
                                                                  'FALSE') active_price_list,
       Purchase_Quantity_Price_API.Check_Active_Price_Lines_Exist(contract,
                                                                  part_no,
                                                                  vendor_no,
                                                                  'TRUE') active_rental_price_list,
       Dictionary_SYS.Component_Is_Active_Num('DOCMAN') is_docman_installed,
       Purchase_Part_Supplier_API.Approval_Connection_Available('PurchasePartSupplier',
                                                                'ApprovalRouting') is_object_connection_available,
       'SUPPLIER' party_type_supplier,
       Income_Type_API.Get_Income_Type_Id(internal_income_type) income_type_id
  FROM PURCHASE_PART_SUPPLIER t
  WHERE to_date(substr(t.OBJVERSION, 0, 8), 'YYYYMMDD') between
       to_date('20181101', 'YYYYMMDD') AND to_date('20240331', 'YYYYMMDD');
