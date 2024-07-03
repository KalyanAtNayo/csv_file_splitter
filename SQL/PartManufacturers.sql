select t.*,
       PART_CATALOG_API.Get_Description(PART_NO) PartDescription,
       Standard_Names_API.Get_Std_Name(PART_CATALOG_API.Get_Std_Name_Id(PART_NO)) StandardName
  from Part_Manufacturer t
 where to_date(substr(t.OBJVERSION, 0, 8), 'YYYYMMDD') between
       to_date('20181101', 'YYYYMMDD') AND to_date('20240331', 'YYYYMMDD');
