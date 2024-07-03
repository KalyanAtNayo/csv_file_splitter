SELECT t.*,
       TO_CHAR(TO_DATE(stat_year_no || LPAD(stat_period_no, 2, '0') || '01', 'YYYYMMDD'), 'YYYYMMDDHH24MISS')  c_objversion
  FROM inventory_value_part_sum_ext t
 WHERE TO_DATE(stat_year_no || LPAD(stat_period_no, 2, '0') || '01', 'YYYYMMDD') between
       to_date('20181101', 'YYYYMMDD') AND to_date('20240331', 'YYYYMMDD');
