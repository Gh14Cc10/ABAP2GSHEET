*&---------------------------------------------------------------------*
*& ReportZGOOGLE_DEMO_UPD_CONDIT_FORMAT
*&---------------------------------------------------------------------*
*& - Update spreadsheet with  conditional formatting and using a gradient color
*&---------------------------------------------------------------------*
"to be used with ZGOOGLE_DEMO_ADD_SHEET
"row 2 paint the max with green and the min with red
"row 5 paint the max with blu and the min with yellow

REPORT zgoogle_demo_condition_formatt.



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

ls_request_batch-add_conditional_format_rule-rule-ranges-sheet_id = '0'.
ls_request_batch-add_conditional_format_rule-rule-ranges-start_row_index = 1.
ls_request_batch-add_conditional_format_rule-rule-ranges-end_row_index = 2.

ls_request_batch-add_conditional_format_rule-rule-gradient_rule-minpoint-color-green = '0.2'.
ls_request_batch-add_conditional_format_rule-rule-gradient_rule-minpoint-color-red = '0.8'.
ls_request_batch-add_conditional_format_rule-rule-gradient_rule-minpoint-type = 'MIN'.

ls_request_batch-add_conditional_format_rule-rule-gradient_rule-maxpoint-color-green = '0.9'.
ls_request_batch-add_conditional_format_rule-rule-gradient_rule-maxpoint-type = 'MAX'.

ls_request_batch-add_conditional_format_rule-index = 0.

lo_batch_req_obj->add_request( ip_batch_req = ls_request_batch  ).

CLEAR ls_request_batch.
ls_request_batch-add_conditional_format_rule-rule-ranges-sheet_id = '0'.
ls_request_batch-add_conditional_format_rule-rule-ranges-start_row_index = 3.
ls_request_batch-add_conditional_format_rule-rule-ranges-end_row_index = 4.

ls_request_batch-add_conditional_format_rule-rule-gradient_rule-minpoint-color-green = '0.8'.
ls_request_batch-add_conditional_format_rule-rule-gradient_rule-minpoint-color-red = '0.8'.
ls_request_batch-add_conditional_format_rule-rule-gradient_rule-minpoint-type = 'NUMBER'.
ls_request_batch-add_conditional_format_rule-rule-gradient_rule-minpoint-value = '0'.

ls_request_batch-add_conditional_format_rule-rule-gradient_rule-maxpoint-color-blue = '0.9'.
ls_request_batch-add_conditional_format_rule-rule-gradient_rule-maxpoint-color-green = '0.5'.
ls_request_batch-add_conditional_format_rule-rule-gradient_rule-maxpoint-color-red = '0.5'.
ls_request_batch-add_conditional_format_rule-rule-gradient_rule-maxpoint-type = 'NUMBER'.
ls_request_batch-add_conditional_format_rule-rule-gradient_rule-maxpoint-value = '256'.
ls_request_batch-add_conditional_format_rule-index = 1.


lo_batch_req_obj->add_request( ip_batch_req = ls_request_batch  ).
CLEAR ls_request_batch.

lo_batch_req_obj->send_request(
  EXPORTING
    ip_spreadsheet_id =  lv_spreadsheet_id

).
