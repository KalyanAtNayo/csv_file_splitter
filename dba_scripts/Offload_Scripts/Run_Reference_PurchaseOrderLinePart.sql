-- ==== *** Modify the fileloc and filename for your needs *** ====
-- ====
-- ==== Define file name and location
-- ================================================================
set define "&"
#define fileloc ='R:\work\00_Cutover';
define fileloc ='/Users/kalyan/Workspaces/python-examples/nt_csv_file_splitter/csv_file_splitter/dba_scripts';
define scriptloc='Offload_Scripts'
define filename ='Reference_PurchaseOrderLinePart';
 
-- ==========================================
-- ==== Set up Environment
-- ==========================================
ALTER SESSION set NLS_DATE_FORMAT = 'yyyy-mm-dd hh:mi:ss';
 
set echo off
-- set termout off
set feedback OFF
 
-- ==== Capture time for use in filename
col date_val new_value date_val
select to_char(sysdate,'yyymmdd_hhmiss') date_val from dual;
 
SET MARKUP CSV ON delimiter , quote ON
 
-- ==========================================
-- ==== Capture Start time
-- ==========================================
 
SPOOL &fileloc\&filename..begin replace
select 'STARTING: '||systimestamp from dual;
 
-- ==========================================
-- ==== Start Spool of SQL output
-- ==========================================
 
SPOOL &fileloc\&scriptloc\&filename._&date_val..csv replace
 
-- >>>>>>>>> Replace below sql with your SQL to capture output as CSV
@&filename..sql
-- <<<<<<<<< End SQL
 
-- ==========================================
-- ==== Capture End time
-- ==========================================
 
SPOOL &fileloc\&filename..end replace
select 'ENDED: '||systimestamp from dual;
spool off
quit