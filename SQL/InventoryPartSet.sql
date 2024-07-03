select t.*,
Inventory_Part_API.Get_Description(contract, part_no) PartDescriptionInUse,
Iso_Unit_API.Get_Description(unit_meas) UnitOfMeasureDescription,
Iso_Unit_API.Get_Description(catch_unit_meas) CatchUnitMeasDescription,
Input_Unit_Meas_Group_API.Get_Description(input_unit_meas_group_id) InputUnitDescription,
Commodity_Group_API.Get_Description(prime_commodity) PrimeCommodityGrpDescription,
Commodity_Group_API.Get_Description(second_commodity) SecondCommodityGrpDescription,
Safety_Instruction_API.Get_Description(hazard_code) SafetyInstructionDescription,
Accounting_Group_API.Get_Description(accounting_group) AccountingGroupDescription,
Inventory_Product_Code_API.Get_Description(part_product_code) ProductCodeDescription,
Inventory_Product_Family_API.Get_Description(part_product_family) ProductFamilyDescription,
Inventory_Part_API.Get_Weight_Net(contract,part_no) NetWeight,
Company_Invent_Info_API.Get_Uom_For_Weight(Site_API.Get_Company(contract)) WeightUom,
Inventory_Part_API.Get_Volume_Net(contract,part_no) NetVolume,
Company_Invent_Info_API.Get_Uom_For_Volume(Site_API.Get_Company(contract)) VolumeUom,
Inventory_Part_In_Stock_API.Get_Inventory_Qty_Onhand(contract,part_no,null) OnHandQty,
Inventory_Part_In_Stock_API.Get_Inventory_Qty_Onhand(contract,part_no,null,'CATCH') OnHandCatchQty,
Inventory_Part_API.Get_Ultd_Purch_Supply_Date(contract, part_no) UnlimitedPurchSupplyDate,
Inventory_Part_API.Get_Ultd_Manuf_Supply_Date(contract, part_no) UnlimitedManufSupplyDate,
Inventory_Part_API.Get_Ultd_Expected_Supply_Date(contract, part_no) UnlimitedExpectedSupplyDate,
Inventory_Part_API.Get_Superseded_By(contract, part_no) SupersededByPart,
Inventory_Part_Planning_API.Get_Order_Requisition_Db (Contract, Part_No) SupplyTypeDb,
Supply_Source_Part_Manager_API.Is_Part_Internally_Sourced(contract, part_no) MultiSitePlannedPart,
Part_Catalog_API.Get_Description(part_no) PartCatalogPartDescription,
Part_Gtin_API.Get_Default_Gtin_No(part_no) GTin,
Part_Gtin_API.Get_Gtin_Series(part_no, Part_Gtin_API.Get_Default_Gtin_No(part_no)) GTINSeries,
Inventory_Part_API.Get_Putaway_Zone_Refill_Option(contract,part_no) OperativeValue,
Inventory_Part_API.Get_Putaway_Refill_Option_Src(contract, part_no) OperativeValueSource,
Company_Site_API.Get_Country_Db(contract) CountryCode,
Site_Invent_Info_API.Get_Use_Partca_Desc_Invent_Db(contract) UsePartcaDescInventDb,
Site_Invent_Info_API.Get_Default_Qty_Calc_Round(contract) DefaultQtyCalcRound,
Part_Catalog_API.Get_Std_Name_Id(PART_NO) || ' - ' || Standard_Names_Language_API.Get_Std_Name(NULL,Part_Catalog_API.Get_Std_Name_Id(PART_NO)) PartCatalogStandardName,
Forecast_Part_Util_API.Check_Any_Forecast_Part_Exist(Contract, Part_No) AnyForecastPartExists,
Forecast_Part_Util_API.Check_All_Forecast_Parts_Exist(Contract, Part_No) AllForecastPartsExist
from inventory_part t
where to_date(substr(t.OBJVERSION, 0, 8), 'YYYYMMDD') between to_date('20181101', 'YYYYMMDD') AND  to_date('20240331', 'YYYYMMDD');
