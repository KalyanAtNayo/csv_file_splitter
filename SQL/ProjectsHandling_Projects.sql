select t.*,
       Project_API.Is_Big_Project(PROJECT_ID) LargeProject,
       Project_History_Log_API.Get_Baseline_Rev_Comment(PROJECT_ID,
                                                        BASELINE_REVISION_NUMBER) BaselineRevisionComment,
       Project_API.Get_Project_Date_Exception(PROJECT_ID) EmployeeAllocationDateException,
       Planned_Netting_Group_API.Project_Png_Connected(DEFAULT_SITE,
                                                       PROJECT_ID) ProjectPngExists,
       Project_Forecast_API.Check_Exist_For_Project(PROJECT_ID) CheckForecast,
       Company_Finance_API.Get_Company_Name(Company) CompanyName,
       Customer_Info_Api.Get_Customer_Category_Db(Customer_Id) CustomerCategory,
       PROJECT_HISTORY_LOG_API.Check_Exist_For_Project(PROJECT_ID) History
  from project_base t
 where to_date(substr(t.OBJVERSION, 0, 8), 'YYYYMMDD') between
       to_date('20181101', 'YYYYMMDD') AND to_date('20240331', 'YYYYMMDD');
