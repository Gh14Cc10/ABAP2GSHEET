*&---------------------------------------------------------------------*
*& ReportZGOOGLE_DEMO_UPD_CONDIT_FORMAT
*&---------------------------------------------------------------------*
*& - Update spreadsheet with  conditional formatting (Background colored just  for odd rows)
"to be used with ZGOOGLE_DEMO_ADD_SHEET
"set a custom color for A1-H1 and then set a rule for each odd rows with a different color
*&---------------------------------------------------------------------*
REPORT zgoogle_demo_format_color_even.



*
SELECTION-SCREEN: BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-001.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (16) TEXT-002.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_url TYPE string OBLIGATORY LOWER CASE.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN:END OF BLOCK bl1 .

DATA:
  ls_request_batch  TYPE zgsheet_batch_update_req_s,
  lo_batch_req_obj  TYPE REF TO zcl_gsheet_batch_req,
  ls_range_object   TYPE zgsheet_grid_range_s,
  ls_border_object  TYPE zgsheet_border_s,
  lv_spreadsheet_id TYPE string.

lv_spreadsheet_id =  zcl_gsheet_utility=>extract_spreadsheet_id( ip_url = p_url ).

CREATE OBJECT lo_batch_req_obj TYPE zcl_gsheet_batch_req.

CLEAR ls_request_batch.
ls_request_batch-repeat_cell-range-sheet_id =  '0'.
ls_request_batch-repeat_cell-range-start_row_index = '0'.
ls_request_batch-repeat_cell-range-start_column_index = '0'.
ls_request_batch-repeat_cell-range-end_row_index = '1'.
ls_request_batch-repeat_cell-range-end_column_index = '8'.
ls_request_batch-repeat_cell-fields = 'USER_ENTERED_FORMAT'.
ls_request_batch-repeat_cell-cell-user_entered_format-background_color-red = '0.2'.
ls_request_batch-repeat_cell-cell-user_entered_format-background_color-blue = '0.8'.
ls_request_batch-repeat_cell-cell-user_entered_format-background_color-green = '1'.
ls_request_batch-repeat_cell-cell-user_entered_format-background_color-alpha = '1'.

lo_batch_req_obj->add_request(
  EXPORTING
    ip_batch_req           =   ls_request_batch  " Request structure for spreadsheet batchupdate
).

CLEAR ls_request_batch.


DATA ls_value_condition TYPE zgsheet_condition_value_s.
ls_request_batch-add_conditional_format_rule-rule-ranges-sheet_id = '0'.
ls_request_batch-add_conditional_format_rule-rule-ranges-start_column_index = 0.
ls_request_batch-add_conditional_format_rule-rule-ranges-end_column_index = 8.
ls_request_batch-add_conditional_format_rule-rule-ranges-start_row_index = 1.
ls_request_batch-add_conditional_format_rule-rule-boolean_rule-condition-type = 'CUSTOM_FORMULA'.
ls_value_condition-user_entered_value = '=ISODD(ROW())'.
APPEND ls_value_condition TO ls_request_batch-add_conditional_format_rule-rule-boolean_rule-condition-values.
ls_request_batch-add_conditional_format_rule-rule-boolean_rule-format-background_color-red = '1.05'.
ls_request_batch-add_conditional_format_rule-rule-boolean_rule-format-background_color-green = '1'.
ls_request_batch-add_conditional_format_rule-rule-boolean_rule-format-background_color-blue = '0.5'.
ls_request_batch-add_conditional_format_rule-index = 0.

lo_batch_req_obj->add_request( ip_batch_req = ls_request_batch  ).
CLEAR ls_request_batch.

lo_batch_req_obj->send_request(
  EXPORTING
    ip_spreadsheet_id =  lv_spreadsheet_id

).
