select t.*,
       Invoice_Library_API.Get_Identity_Name(company,
                                             identity,
                                             party_type,
                                             invoice_address_id) Name,
       to_char(Accounting_Period_API.Get_Accounting_Year(company,
                                                         invoice_date)) AccountingYearStr,
       Accounting_Period_API.Get_Year_Period_Str(company, invoice_date) AccountingPeriodStr,
       Invoice_Note_API.Check_Note_Exist(company, invoice_id) Notes,
       invoice_text_id || ' ' || invoice_text InvoiceTextRef,
       Payment_Plan_API.Overdue_Invoices_Exist(company, invoice_id) Overdue,
       Invoic_Data_Reporting_Item_API.Get_Sii_Invoice_Status(company,
                                                             invoice_id) SiiInvoiceStatus
  from outgoing_invoice_qry t
 where invoice_date between to_date('01-11-2018', 'dd-mm-yyyy') and
       to_date('31-03-2024', 'dd-mm-yyyy');
