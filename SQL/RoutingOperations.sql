SELECT A.*,
       (SELECT min(condition_line_no)
          FROM config_condition2
         WHERE condition_id = A.condition_id) min_condition_line_no,
       (SELECT max(condition_line_no)
          FROM config_condition2
         WHERE condition_id = A.condition_id) max_condition_line_no,
       (SELECT min(action_sequence_no)
          FROM config_action2
         WHERE action_id = A.action_id) min_action_sequence_no,
       (SELECT max(action_sequence_no)
          FROM config_action2
         WHERE action_id = A.action_id) max_action_sequence_no,
       (SELECT count(*)
          FROM routing_operation_tool
         WHERE CONTRACT = A.contract
           AND PART_NO = A.part_no
           AND ROUTING_REVISION = A.routing_revision
           AND BOM_TYPE_DB = A.bom_type
           AND ALTERNATIVE_NO = A.alternative_no
           AND OPERATION_ID = A.operation_id) tools_count,
       (SELECT count(*)
          FROM routing_oper_work_guide
         WHERE CONTRACT = A.contract
           AND part_no = A.part_no
           AND routing_revision = A.routing_revision
           AND BOM_TYPE_DB = A.bom_type
           AND alternative_no = A.alternative_no
           AND operation_id = A.operation_id) work_guide_count
  FROM (SELECT t.*,
               OPERATION_NO || ' - ' || OPERATION_DESCRIPTION operation_selector_header_title,
               --decode(include_setup_for_overlap_db, 'Y', 'TRUE', 'FALSE') include_setup_for_overlap_db,
               WORK_CENTER_API.Get_Capacity_Flag(contract, WORK_CENTER_NO) capacity_flag,
               DECODE(ROUTING_OPER_WORK_GUIDE_API.Is_Guideline_Exist(CONTRACT,
                                                                     PART_NO,
                                                                     ROUTING_REVISION,
                                                                     BOM_TYPE_DB,
                                                                     ALTERNATIVE_NO,
                                                                     OPERATION_ID),
                      'Y',
                      'TRUE',
                      'FALSE') work_guideline,
               DECODE(Config_Rule_Exist_API.Encode(Config_Condition_Manager_API.Operation_Rules_Exist(CONTRACT,
                                                                                                      PART_NO,
                                                                                                      ROUTING_REVISION,
                                                                                                      BOM_TYPE,
                                                                                                      ALTERNATIVE_NO,
                                                                                                      OPERATION_ID)),
                      'RULESEXIST',
                      'TRUE',
                      'FALSE') rules_exist2,
               WORK_CENTER_API.Get_Vendor_No2(CONTRACT,
                                              WORK_CENTER_NO,
                                              OUTSIDE_OP_ITEM) cols_supplier_no,
               DECODE(Document_Text_API.Note_Id_Exist(NOTE_ID),
                      '0',
                      'FALSE',
                      'TRUE') document_text,
               Part_Catalog_API.Get_Configurable_Db(part_no) configurable_db,
               Config_Part_Catalog_API.Get_Config_Family_Id(PART_NO) config_family_id,
               'ConfigOperation' config_condition_row_type_db,
               Config_Action_Object_API.Decode('OPERATION') config_action_object_parent,
               (SELECT value1
                  FROM (SELECT contract                     key1,
                               part_no                      key2,
                               routing_revision             key3,
                               bom_type_db                  key4,
                               alternative_no               key5,
                               config_condition_row_type_db key6,
                               operation_id                 key7,
                               condition_id                 value1
                          FROM config_condition_group2)
                 WHERE CONTRACT = key1
                   AND PART_NO = key2
                   AND ROUTING_REVISION = key3
                   AND BOM_TYPE_DB = key4
                   AND ALTERNATIVE_NO = key5
                   AND 'ConfigOperation' = key6
                   AND OPERATION_ID = key7) condition_id,
               (SELECT value1
                  FROM (SELECT contract                  key1,
                               part_no                   key2,
                               routing_revision          key3,
                               bom_type_db               key4,
                               alternative_no            key5,
                               config_action_row_type_db key6,
                               operation_id              key7,
                               action_id                 value1
                          FROM config_action_group2)
                 WHERE CONTRACT = key1
                   AND PART_NO = key2
                   AND ROUTING_REVISION = key3
                   AND BOM_TYPE_DB = key4
                   AND ALTERNATIVE_NO = key5
                   AND 'ConfigOperation' = key6
                   AND OPERATION_ID = key7) action_id
          FROM routing_operation t) A
WHERE to_date(substr(OBJVERSION, 0, 8), 'YYYYMMDD') between to_date('20181101', 'YYYYMMDD') AND  to_date('20240331', 'YYYYMMDD');          
