SELECT t.*,
       DECODE(ORDER_CODE_DB,
              'M',
              PART_REVISION_API.GET_REV_BY_DATE_AND_TYPE(CONTRACT,
                                                         PART_NO,
                                                         REVISED_START_DATE,
                                                         'PRODUCE'),
              'RM',
              PART_REVISION_API.GET_REV_BY_DATE_AND_TYPE(CONTRACT,
                                                         PART_NO,
                                                         REVISED_START_DATE,
                                                         'PRODUCE'),
              PART_REVISION_API.GET_REV_BY_DATE_AND_TYPE(CONTRACT,
                                                         PART_NO,
                                                         REVISED_START_DATE,
                                                         'REPAIR')) part_revision,
       
       DECODE(packing_instruction_id,
              NULL,
              NULL,
              Packing_Instruction_API.Get_Description(packing_instruction_id)) packing_instruction_desc,
       DECODE(owning_customer_no,
              NULL,
              NULL,
              Cust_Ord_Customer_API.Get_Name(owning_customer_no)) owning_customer_name,
       Shop_Ord_API.Get_Mtrl_State_Db__(ORDER_NO, RELEASE_NO, SEQUENCE_NO) shop_order_material_summary_status,
       Shop_Ord_Util_API.Get_Oper_State_Db(ORDER_NO,
                                           RELEASE_NO,
                                           SEQUENCE_NO) operation_status,
       Shop_Ord_Util_API.Get_Prod_State_Db(ORDER_NO,
                                           RELEASE_NO,
                                           SEQUENCE_NO) product_status,
       Manufactured_Part_API.Is_Byproduct_Received(ORDER_NO,
                                                   RELEASE_NO,
                                                   SEQUENCE_NO) is_byproduct_received,
       SHOP_ORD_UTIL_API.INTERRUPTION_EXISTS(ORDER_NO,
                                             RELEASE_NO,
                                             SEQUENCE_NO) interruption_exists,
       DECODE(PROJECT_ID,
              NULL,
              NULL,
              PROJECT_PROGRAM_GLOBAL_API.GET_DESCRIPTION(PROJECT_API.GET_PROGRAM_ID(PROJECT_ID))) program_description,
       DECODE(ACTIVITY_SEQ,
              NULL,
              NULL,
              ACTIVITY_API.Get_Sub_Project_Description(ACTIVITY_SEQ)) sub_project_description,
       SHOP_MATERIAL_ALLOC_LIST_API.EXIST_ANY_ALLOCS(ORDER_NO,
                                                     RELEASE_NO,
                                                     SEQUENCE_NO) allocations_exist,
       Shop_Ord_API.Get_Remaining_Qty(order_no, release_no, sequence_no) remaining_qty,
       DECODE(CONFIGURATION_ID, '*', 'FALSE', 'TRUE') has_configuration,
       PLANNING_ALERT_API.IS_PLANNING_ALERT_EXIST(ORDER_NO,
                                                  RELEASE_NO,
                                                  SEQUENCE_NO) planning_alert_exists,
       PLANNING_ALERT_API.GET_EARLIEST_PLANNABLE_DATE(ORDER_NO,
                                                      RELEASE_NO,
                                                      SEQUENCE_NO) earliest_plannable_date,
       Inventory_Product_Code_API.Get_Description(INVENTORY_PART_API.Get_Part_Product_Code(CONTRACT,
                                                                                           PART_NO)) product_code_description,
       Inventory_Product_Family_API.Get_Description(INVENTORY_PART_API.Get_Part_Product_Family(CONTRACT,
                                                                                               PART_NO)) product_family_description,
       DECODE(park_person_id,
              NULL,
              NULL,
              Person_Info_API.Get_Name(park_person_id)) park_person_name,
       MRB_INT_API.EXIST_CONNECTION_BY_ORDER(ORDER_NO,
                                             RELEASE_NO,
                                             SEQUENCE_NO,
                                             0,
                                             'SHOP ORDER WIP') m_r_b_exists,
       QMAN_CTRL_PLAN_SHOP_ORDER_API.GET_CONTROL_PLAN_NO(ORDER_NO,
                                                         RELEASE_NO,
                                                         SEQUENCE_NO) control_plan_no,
       QMAN_CTRL_PLAN_SHOP_ORDER_API.GET_CTRL_PLAN_REVISION_NO(ORDER_NO,
                                                               RELEASE_NO,
                                                               SEQUENCE_NO) control_plan_revision_no,
       CASE
         WHEN REVISED_DUE_DATE > NEED_DATE THEN
          'TRUE'
         ELSE
          'FALSE'
       END tardy,
       Part_Revision_API.Get_Eff_Phase_In_Date(contract,
                                               part_no,
                                               Eng_Chg_Level) eff_phase_in_date,
       Part_Revision_API.Get_Eff_Phase_Out_Date(contract,
                                                part_no,
                                                Eng_Chg_Level) eff_phase_out_date,
       CASE
         WHEN ORDER_CODE IN ('A', 'B', 'D') OR
              (ORDER_CODE = 'F' AND
              (MRO_VISIT_ID IS NOT NULL OR CRO_NO IS NOT NULL)) THEN
          'TRUE'
         ELSE
          'FALSE'
       END is_mro_or_cro_shop_order,
       CASE
         WHEN ORDER_CODE_DB IN ('A', 'B') OR
              (ORDER_CODE_DB = 'F' AND
              (MRO_VISIT_ID IS NOT NULL OR
              (CRO_NO IS NOT NULL AND DISPO_ORDER_NO IS NOT NULL))) THEN
          'TRUE'
         ELSE
          'FALSE'
       END is_mro_shop_order,
       CASE
         WHEN (ORDER_CODE_DB = 'D' AND
              (DEMAND_CODE_DB = 'MRO' OR DEMAND_CODE_DB = 'CRO')) THEN
          'TRUE'
         ELSE
          'FALSE'
       END is_disposition_shop_order,
       DECODE(SHOP_ORD_API.IS_CBS_SITE(CONTRACT), 1, 'TRUE', 'FALSE') is_cbs_site,
       Shop_Ord_API.Is_Mso_Enabled(contract) mso_enabled,
       DECODE(ORDER_CODE_DB,
              'M',
              Part_Revision_API.Get_Rev_By_Date_And_Type(CONTRACT,
                                                         PART_NO,
                                                         REVISED_START_DATE,
                                                         'PRODUCE'),
              'RM',
              Part_Revision_API.Get_Rev_By_Date_And_Type(CONTRACT,
                                                         PART_NO,
                                                         REVISED_START_DATE,
                                                         'PRODUCE'),
              Part_Revision_API.Get_Rev_By_Date_And_Type(CONTRACT,
                                                         PART_NO,
                                                         REVISED_START_DATE,
                                                         'REPAIR')) valid_revision,
       SHOP_MATERIAL_PICK_UTIL_API.WAREHOUSE_PICK_LINES_EXIST(ORDER_NO,
                                                              RELEASE_NO,
                                                              SEQUENCE_NO,
                                                              NULL) exist_warehouse_pick_lines,
       NVL(CONFIGURATION_ID, '*') configuration_id_temp,
       NVL(PROJECT_ID, '*') project_id_temp,
       Shop_Ord_Util_API.Unique_Customer_Exists(ORDER_NO,
                                                RELEASE_NO,
                                                SEQUENCE_NO) unique_customer_exists,
       SHOP_ORD_UTIL_API.CHECK_ORIGINAL_ORDER_EXIST(ORDER_NO,
                                                    RELEASE_NO,
                                                    SEQUENCE_NO) original_order_exist,
       SHOP_ORD_SPLIT_CHECK_HEAD_API.IS_CHECKLIST_APPROVED(ORDER_NO,
                                                           RELEASE_NO,
                                                           SEQUENCE_NO) checklist_approved,
       SHOP_ORDER_OPERATION_LIST_API.IS_SHIPPED_OUTSIDE_OP_EXIST(ORDER_NO,
                                                                 RELEASE_NO,
                                                                 SEQUENCE_NO) shipped_operations_exist,
       SHOP_ORD_API.IS_SPLIT_OPERATIONS_EXISTS(ORDER_NO,
                                               RELEASE_NO,
                                               SEQUENCE_NO) split_operations_exist,
       
       SUBSTR(SOURCE, 1, INSTR(SOURCE, '^') - 1) source_type,
       Manufactured_Part_API.Part_Has_Byproducts(ORDER_NO,
                                                 RELEASE_NO,
                                                 SEQUENCE_NO) has_byproducts,
       Manufactured_Part_API.Part_Has_DA_Components(ORDER_NO,
                                                    RELEASE_NO,
                                                    SEQUENCE_NO) has_disassembly_components,
       Inventory_Part_API.Get_Planner_Buyer(contract, part_no) planner_buyer,
       Site_API.Get_Site_Date(contract) + NVL('7', 0) week_later_date,
       CASE
         WHEN EXTRACT(YEAR FROM revised_start_date) <
              EXTRACT(YEAR FROM Site_API.Get_Site_Date(contract)) THEN
          '< ' || EXTRACT(YEAR FROM Site_API.Get_Site_Date(contract)) || '-' ||
          TO_CHAR(Site_API.Get_Site_Date(contract), 'IW')
         WHEN trunc(revised_start_date, 'IW') <
              trunc(Site_API.Get_Site_Date(contract), 'IW') THEN
          '< ' || EXTRACT(YEAR FROM revised_start_date) || '-' ||
          TO_CHAR(Site_API.Get_Site_Date(contract), 'IW')
         WHEN trunc(to_char(revised_start_date, 'IW')) = '1' AND
              to_number(to_char(revised_start_date, 'MMDD')) > 1223 THEN
          EXTRACT(YEAR FROM revised_start_date) + 1 || '-' || '01'
         ELSE
          EXTRACT(YEAR FROM revised_start_date) || '-' ||
          TO_CHAR(revised_start_date, 'IW')
       END week,
       Shop_Ord_Util_API.Get_Outside_Op_WC_List(order_no,
                                                release_no,
                                                sequence_no) out_so_wc_nos,
       Shop_Ord_Util_API.Is_Outside_Oper_Exist(order_no,
                                               release_no,
                                               sequence_no) has_out_op_order,
       sysdate today,
       Shop_Ord_Util_API.Get_Outside_Op_Item_List(order_no,
                                                  release_no,
                                                  sequence_no) outside_op_item,
       Shop_Ord_Util_API.Get_Outside_Department_List(order_no,
                                                     release_no,
                                                     sequence_no) outside_department_no,
       Shop_Ord_Util_API.Get_Po_Buyer_Code_List(order_no,
                                                release_no,
                                                sequence_no) po_buyer_code,
       Shop_Ord_Util_API.Get_Pr_Buyer_Code_List(order_no,
                                                release_no,
                                                sequence_no) pr_buyer_code,
       Shop_Ord_Util_API.Get_Po_Vendor_No_List(order_no,
                                               release_no,
                                               sequence_no) po_vendor_no,
       Shop_Ord_Util_API.Get_Pr_Vendor_No_List(order_no,
                                               release_no,
                                               sequence_no) pr_vendor_no,
       Shop_Order_Operation_API.Is_Operation_Exist(order_no,
                                                   release_no,
                                                   sequence_no) has_so_operations,
       Site_API.Get_Site_Date(contract) site_date,
       Shop_Ord_API.Split_Orders_Info_Exists(Order_No,
                                             Release_No,
                                             Sequence_No) split_info_exists,
       CASE
         WHEN (Reserved_Lot_Batch_API.Get_Sum_Qty_Reserved_Ord(ORDER_NO,
                                                               RELEASE_NO,
                                                               SEQUENCE_NO,
                                                               NULL,
                                                               'SHOP_ORD') <
              REVISED_QTY_DUE + OPERATION_QTY_DEVIATION) THEN
          'TRUE'
         ELSE
          'FALSE'
       END sum_qty_reserved,
       Reserved_Lot_Batch_API.Lot_Batch_Exist(ORDER_NO,
                                              RELEASE_NO,
                                              SEQUENCE_NO) lot_batch_exist,
       Customer_Order_Shop_Order_API.Check_Cust_Ord_For_Shop_Ord(ORDER_NO,
                                                                 RELEASE_NO,
                                                                 SEQUENCE_NO) pegged_customer_order,
       Shop_Material_Shop_Order_API.Get_No_Demand_Peggings(ORDER_NO,
                                                           RELEASE_NO,
                                                           SEQUENCE_NO) pegged_shop_order,
       Serial_No_Reservation_API.Get_Count_Reservation(ORDER_NO,
                                                       RELEASE_NO,
                                                       SEQUENCE_NO,
                                                       NULL,
                                                       'SHOP ORDER',
                                                       PART_NO) count_reservation,
       Level_1_Part_By_Ms_Set_API.Get_Planning_Tf_Date(CONTRACT,
                                                       PART_NO,
                                                       '*',
                                                       1) planning_tf_date,
       Level_1_Part_API.Get_Parent_Part_No(CONTRACT,
                                           PART_NO,
                                           NVL(PROJECT_ID, '*')) ms_family_part,
       Inventory_Part_API.Get_Planner_Buyer(CONTRACT, PART_NO) planner,
       Manufactured_Part_API.Is_Partial_Part_Received(ORDER_NO,
                                                      RELEASE_NO,
                                                      SEQUENCE_NO) is_partial_part_received,
       DECODE(order_code_db,
              'DA',
              Manufactured_Part_API.Get_Total_Op_Cost_Factor(Order_No,
                                                             Release_no,
                                                             Sequence_No),
              NULL) total_op_cost_factor,
       DECODE(order_code_db,
              'DA',
              Manufactured_Part_API.Get_Total_Gen_Oh_Cost_Factor(Order_No,
                                                                 Release_no,
                                                                 Sequence_No),
              NULL) total_gen_oh_cost_factor,
       Shop_Ord_API.Ops_With_Manual_Op_Qty_Exist(ORDER_NO,
                                                 RELEASE_NO,
                                                 SEQUENCE_NO) op_with_manual_op_qty_exists,
       OBJSTATE status_db_val

  FROM SHOP_ORD t
where to_date(substr(t.OBJVERSION, 0, 8), 'YYYYMMDD') between to_date('20181101', 'YYYYMMDD') AND  to_date('20240331', 'YYYYMMDD');
