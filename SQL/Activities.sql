select t.*,
       Project_API.Get_Company(Project_ID) Company,
       Activity_API.Get_Activity_Date_Exception(ACTIVITY_SEQ) EmployeeAllocationDateException,
       Activity_History_API.Activity_History_Log_Exist(ACTIVITY_SEQ) ActivityHistoryLogExist,
       Project_API.Get_Access_On_Off(Project_Id) AccessOn,
       Project_API.Get_Manager(Project_ID) Manager
  from ACTIVITY_SUM_DETAIL t
 where to_date(substr(t.OBJVERSION, 0, 8), 'YYYYMMDD') between
       to_date('20181101', 'YYYYMMDD') AND to_date('20240331', 'YYYYMMDD');
