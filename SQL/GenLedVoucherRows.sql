select t.*,
       Gen_Led_Voucher_Row_API.Get_Delivery_Type_Description(COMPANY,
                                                             DELIV_TYPE_ID) DeliveryTypeDescription,
       DECODE(Function_Group,
              'I',
              Gen_Led_Voucher_Row_API.Check_Posting_Proposal(COMPANY,
                                                             VOUCHER_TYPE,
                                                             VOUCHER_NO,
                                                             ACCOUNTING_YEAR,
                                                             PARTY_TYPE_ID),
              'J',
              Gen_Led_Voucher_Row_API.Check_Posting_Proposal(COMPANY,
                                                             VOUCHER_TYPE,
                                                             VOUCHER_NO,
                                                             ACCOUNTING_YEAR,
                                                             PARTY_TYPE_ID)) CheckPostingProposal
  from GEN_LED_VOUCHER_ROW_UNION_QRY t
 where to_date(substr(t.OBJVERSION, 0, 8), 'YYYYMMDD') between
       to_date('20181101', 'YYYYMMDD') AND to_date('20240331', 'YYYYMMDD');
