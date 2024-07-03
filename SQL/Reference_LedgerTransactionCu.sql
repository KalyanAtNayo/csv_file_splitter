select t.*,
       DECODE(is_new_ledger_item,
              'FALSE',
              paid_amount - NVL(boe_discount_fee, 0),
              paid_amount) PaidAmount
  from LEDGER_TRANSACTION_CU_QRY t
 where pay_date between to_date('01-11-2018', 'dd-mm-yyyy') and
       to_date('31-03-2024', 'dd-mm-yyyy');
