SELECT t.*,
       Project_API.Get_Earliest_Start(project_id) EarliestStart,
       Project_API.Get_Latest_Early_Finish(project_id) LatestFinish,
       PROJECT_HISTORY_LOG_API.Get_Baseline_Rev_Comment(PROJECT_ID,
                                                        BASELINE_REVISION_NUMBER) BaselineRevisionComment,
       DECODE(ACCESS_ON_OFF, 1, 'TRUE', 'FALSE') AccessOnOff,
       Project_API.Get_Project_Date_Exception(PROJECT_ID) ProjectDateException,
       PROJECT_HISTORY_LOG_API.Check_Exist_For_Project(PROJECT_ID) History,
       Sub_Project_API.Is_Children_Excluded_From_Intg(project_id, null) IsChildrenExcludedFromIntegrations,
       Project_Forecast_API.Check_Exist_For_Project(PROJECT_ID) CheckForecast,
       Change_Object_API.Project_Connected_Cco_Exist(project_id) ChangeOrdersExists
  FROM PROJECT t
 WHERE to_date(substr(t.OBJVERSION, 0, 8), 'YYYYMMDD') between
       to_date('20181101', 'YYYYMMDD') AND to_date('20240331', 'YYYYMMDD')
