select t.*,
       Invoice_Note_API.Check_Note_Exist(company, invoice_id) Notes,
       Payment_Plan_Auth_API.On_Hold_Installment_Exists(invoice_id, company) OnHoldInstallmentExists,
       correction_reason_id || ' ' || correction_reason CorrectionReasonRef,
       Invoice_Text_Id || '  ' || Invoice_Text InvoiceTextRef,
       Company_Invoice_Info_API.Get_Use_Posting_Proposal(company) UsePostingProposal,
       Payment_Plan_API.Overdue_Invoices_Exist(company, invoice_id) Overdue,
       Invoic_Data_Reporting_Item_API.Get_Sii_Invoice_Status(company,
                                                             invoice_id) SiiInvoiceStatus
  from incoming_invoice2 t
 where invoice_date between to_date('01-11-2018', 'dd-mm-yyyy') and
       to_date('31-03-2024', 'dd-mm-yyyy');
