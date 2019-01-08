*&---------------------------------------------------------------------*
*& Report ZGOOGLE_DEMO_CREATE_XLS
*&---------------------------------------------------------------------*
*& - Create a new spreadsheet
*&---------------------------------------------------------------------*
REPORT zgoogle_demo_create_xls.


DATA: lo_spreadsheet_obj TYPE REF TO zcl_gspreadsheet,
      lo_batch_req_obj   TYPE REF TO zcl_gsheet_batch_req,
*      Request object
      lo_request_obj     TYPE REF TO zcl_gsheet_batch_value_req,
*Request structure
      ls_request         TYPE zgsheet_batch_update_val_req_s,

*Values structure
      lt_values          TYPE TABLE OF zgsheet_string_tt,
      ls_value           LIKE LINE OF lt_values,
*Range structure
      ls_value_range     TYPE zgsheet_value_ranges_s,
*      ls_value_string    LIKE LINE OF lt_values,
      ls_spreadsheet     TYPE zgspreadsheet_s.

*Local spreadsheet
ls_spreadsheet-properties-title = 'Material master filtered'.

*Creaton on google drive
zcl_gspreadsheet_api=>create_new_spreadsheet(
  EXPORTING
    ip_spreadsheet_s =     ls_spreadsheet  " Google sheet object structure
  IMPORTING
    ep_spreadsheet   =     lo_spreadsheet_obj " Google sheet object structure
).

ls_spreadsheet = lo_spreadsheet_obj->get_abap_obj( ).



CREATE OBJECT lo_request_obj TYPE zcl_gsheet_batch_value_req.

APPEND 'Hello World' TO ls_value.
APPEND   ls_value TO  lt_values.

*range
ls_value_range-range = 'A1'.
ls_value_range-values = lt_values .
APPEND ls_value_range  TO ls_request-data.

ls_request-value_input_option = 'USER_ENTERED'.

lo_request_obj->add_request( ip_request = ls_request  ).
lo_request_obj->send_request(
  EXPORTING
    ip_spreadsheet_id =  ls_spreadsheet-spreadsheet_id
    ip_sheet_id       = '0'
).

WRITE ls_spreadsheet-spreadsheet_url.
