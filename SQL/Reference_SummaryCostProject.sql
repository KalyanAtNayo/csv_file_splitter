SELECT t.*,
       PROJECT_API.Get_Earned_Value_Method_Db(PROJECT_ID) EarnedValueMethodDb,
       PROJECT_CONNECTION_TEMP_API.Get_Progress_Cost(PROJECT_ID,
                                                     CONTROL_CATEGORY) ProgressCost
  FROM PROJ_CON_DET_SUM_COST_PROJECT t
 WHERE to_date(substr(t.OBJVERSION, 0, 8), 'YYYYMMDD') between
       to_date('20181101', 'YYYYMMDD') AND to_date('20240331', 'YYYYMMDD');
