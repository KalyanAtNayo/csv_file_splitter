select t.*,
       Personal_Data_Man_Util_API.Is_Valid_Consent_By_Keys('SUPPLIER',
                                                           supplier_id,
                                                           NULL,
                                                           trunc(sysdate)) ValidDataProcessingPurpose
  from Supplier_Info_General t
 where to_date(substr(t.OBJVERSION, 0, 8), 'YYYYMMDD') between
       to_date('20181101', 'YYYYMMDD') AND to_date('20240331', 'YYYYMMDD');
