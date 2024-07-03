SELECT t.*,
       decode(print_amounts_incl_tax_db, 'TRUE', 'TRUE', 'FALSE') print_amounts_incl_tax_db,
       DECODE(Document_Text_API.Note_Id_Exist(note_id),
              '1',
              'TRUE',
              'FALSE') document_text,
       decode(email_purchase_order_db, 'TRUE', 'TRUE', 'FALSE') email_purchase_order_db,
       decode(create_confirmation_chg_ord_db, 'TRUE', 'TRUE', 'FALSE') create_confirmation_chg_ord_db,
       decode(end_of_month_db, 'TRUE', 'TRUE', 'FALSE') end_of_month_db,
       decode(rec_adv_self_billing_db, 'TRUE', 'TRUE', 'FALSE') rec_adv_self_billing_db,
       decode(b2b_conf_order_with_diff_db, 'TRUE', 'TRUE', 'FALSE') b2b_conf_order_with_diff_db,
       DECODE(User_Default_API.Get_Contract,
              NULL,
              User_Profile_SYS.Get_Default('COMPANY',
                                           Fnd_Session_API.Get_Fnd_User),
              Site_API.Get_Company(User_Default_API.Get_Contract)) temp_company,
       DECODE(Dictionary_SYS.Component_Is_Active_Num('INVOIC'),
              '1',
              'TRUE',
              'FALSE') invoic_installed,
       Classification_Standard_API.Get_Description(classification_standard) classification_standard_desc
  FROM SUPPLIER t
 WHERE to_date(substr(OBJVERSION, 0, 8), 'YYYYMMDD') between
       to_date('20181101', 'YYYYMMDD') AND to_date('20240331', 'YYYYMMDD');
