select t.*,
       NVL(withheld_tax_curr_amount, 0) -
       NVL(withheld_reduct_curr_amount, 0) TaxWithheldInCurrentPayment
  from ledger_transaction_su_qry t
 where pay_date between to_date('01-11-2018', 'dd-mm-yyyy') and
       to_date('31-03-2024', 'dd-mm-yyyy');
