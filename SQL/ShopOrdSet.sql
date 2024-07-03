select t.*,
       DECODE(use_cost_distribution, 'STANDARD', 'TRUE', 'FALSE') use_cost_distribution,       
       Part_Cost_History_API.Get_Std_Order_Size(contract,
                                                part_no,
                                                Shop_Order_Cost_Util_API.Get_Part_Cost_History_Seq_No(order_no,
                                                                                                      release_no,
                                                                                                      sequence_no,
                                                                                                      state,
                                                                                                      contract,
                                                                                                      part_no,
                                                                                                      configuration_id,
                                                                                                      revised_start_date,
                                                                                                      NVL(close_date,
                                                                                                          revised_start_date)),
                                                configuration_id) costing_std_lot_size,
       Part_Cost_History_API.Get_Effective_Date(contract,
                                                part_no,
                                                configuration_id,
                                                revised_start_date) effective_date,
       Shop_Order_Cost_Util_API.Get_Calculation_Date(order_no,
                                                     release_no,
                                                     sequence_no) calculation_date,
       Shop_Order_Cost_Util_API.Get_Actual_Start_Date(order_no,
                                                      release_no,
                                                      sequence_no) actual_start_date,
       INVENTORY_PART_API.Get_Part_Cost_Group_Id(CONTRACT, PART_NO) part_cost_group_i_d,
       Activity_API.Get_Program_Id(activity_seq) program_i_d,
       ACTIVITY_API.Get_Sub_Project_Id(ACTIVITY_SEQ) sub_project_i_d,
       ACTIVITY_API.Get_Activity_No(ACTIVITY_SEQ) activity_id,
       CUSTOMER_ORDER_NO oe_order_no,
       CUSTOMER_REL_NO oe_rel_no,
       CUSTOMER_LINE_NO oe_line_no,
       Shop_Order_Cost_Util_API.Get_Material_Cost2(order_no,
                                                   release_no,
                                                   sequence_no) material_cost,
       Shop_Order_Cost_Util_API.Get_Material_Oh(order_no,
                                                release_no,
                                                sequence_no) material_o_h,
       Shop_Order_Cost_Util_API.Get_General_Oh(order_no,
                                               release_no,
                                               sequence_no) general_o_h,
       Shop_Order_Cost_Util_API.Get_Operation_Scrap(order_no,
                                                    release_no,
                                                    sequence_no) op_scrap,
       Shop_Order_Cost_Util_API.Get_Operation_Cost(order_no,
                                                   release_no,
                                                   sequence_no) operation_cost,
       Shop_Order_Cost_Util_API.Get_Overhead1(order_no,
                                              release_no,
                                              sequence_no) overhead1,
       Shop_Order_Cost_Util_API.Get_Overhead2(order_no,
                                              release_no,
                                              sequence_no) overhead2,
       Shop_Order_Cost_Util_API.Get_Labor_Op_Cost(order_no,
                                                  release_no,
                                                  sequence_no) labor_cost,
       Shop_Order_Cost_Util_API.Get_Labor_Oh(order_no,
                                             release_no,
                                             sequence_no) labor_o_h,
       Shop_Order_Cost_Util_API.Get_Subcontr(order_no,
                                             release_no,
                                             sequence_no) subcontracting,
       Shop_Order_Cost_Util_API.Get_Subcontr_Oh(order_no,
                                                release_no,
                                                sequence_no) subcontract_o_h,
       0 current_w_i_p,
       Shop_Order_Cost_Util_API.Get_Current_Received(order_no,
                                                     release_no,
                                                     sequence_no) received_value,
       Shop_Order_Cost_Util_API.Get_Internal_Wip(order_no,
                                                 release_no,
                                                 sequence_no) internal_w_i_p,
       Shop_Order_Cost_Util_API.Get_Closing_Variance(order_no,
                                                     release_no,
                                                     sequence_no) calc_varience,
       Shop_Order_Cost_Util_API.Get_Wip_At_Supplier(order_no,
                                                    release_no,
                                                    sequence_no) supplier_w_i_p,
       0 accum_cost_op_scrap,
       Shop_Order_Cost_Util_API.Get_Comp_Scrap(order_no,
                                               release_no,
                                               sequence_no) scrap_comp_value,
       0 accum_cost,
       0 total,
       ORDER_TYPE_API.DECODE('SHOP ORDER') order_type,
       CASE
         WHEN ORDER_CODE_DB IN ('A', 'B', 'D') OR
              (ORDER_CODE_DB = 'F' AND
              (MRO_VISIT_ID IS NOT NULL OR
              (CRO_NO IS NOT NULL AND DISPO_ORDER_NO IS NOT NULL))) THEN
          'TRUE'
         ELSE
          'FALSE'
       END is_mro_shop_order                                                                                                                                              
from SHOP_ORD t
where to_date(substr(t.OBJVERSION, 0, 8), 'YYYYMMDD') between to_date('20181101', 'YYYYMMDD') AND  to_date('20240331', 'YYYYMMDD');
