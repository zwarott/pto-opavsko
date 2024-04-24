-- List tables that have stored layer styles
SELECT
  f_table_schema AS schema,
  f_table_name AS table,
  stylename AS style,
  useasdefault AS default_style,
  update_time AS updated,
  type
FROM
  public.layer_styles;
