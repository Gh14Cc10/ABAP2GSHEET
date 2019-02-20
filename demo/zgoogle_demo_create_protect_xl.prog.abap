*&---------------------------------------------------------------------*
*& Report ZGOOGLE_DEMO1
*&---------------------------------------------------------------------*
*& - Create a new spreadsheet
*& - Protect a range with limiting the user that rights to edit it
*& - Share to an user
*&---------------------------------------------------------------------*
REPORT zgoogle_demo_create_protect_xl.



DATA: lo_batch_req_obj   TYPE REF TO zcl_gsheet_batch_req,
      lo_spreadsheet_obj TYPE REF TO zcl_gspreadsheet,
      ls_spreadsheet     TYPE zgspreadsheet_s,
      ls_batch_request   TYPE zgsheet_batch_update_req_s.

CREATE OBJECT lo_batch_req_obj TYPE zcl_gsheet_batch_req.

*Local spreadsheet
ls_spreadsheet-properties-title = 'NewSpreadsheetTest'.



*Creaton on google drive
zcl_gspreadsheet_api=>create_new_spreadsheet(
  EXPORTING
    ip_spreadsheet_s =     ls_spreadsheet  " Google sheet object structure
  IMPORTING
    ep_spreadsheet   =     lo_spreadsheet_obj " Google sheet object structure
).






* Massive update of newly created spreadsheeet
ls_spreadsheet = lo_spreadsheet_obj->get_abap_obj( ).
ls_batch_request-repeat_cell-range-sheet_id =  ''.
ls_batch_request-repeat_cell-range-start_column_index = 1.
ls_batch_request-repeat_cell-range-end_column_index = 10.
ls_batch_request-repeat_cell-range-start_row_index  = 0.
ls_batch_request-repeat_cell-range-end_row_index =  2.
ls_batch_request-repeat_cell-fields = '*'.
ls_batch_request-repeat_cell-cell-user_entered_value-number_value = 28.

lo_batch_req_obj->add_request( ip_batch_req = ls_batch_request ).

CLEAR ls_batch_request.
* Protect range of cell
ls_batch_request-add_protected_range-protected_range-range-sheet_id = '0'.
ls_batch_request-add_protected_range-protected_range-range-start_row_index = '1'.
ls_batch_request-add_protected_range-protected_range-range-end_row_index = '20'.
ls_batch_request-add_protected_range-protected_range-range-end_column_index = '7'.
ls_batch_request-add_protected_range-protected_range-range-start_column_index = '6'.
ls_batch_request-add_protected_range-protected_range-description ='no touch area'. ##NO_TEXT
ls_batch_request-add_protected_range-protected_range-warning_only = 'false'. ##NO_TEXT
ls_batch_request-add_protected_range-protected_range-requesting_user_can_edit = 'false'.

DATA lv_user  TYPE string.
lv_user  = 'micael.teweldemedhin@techedgegroup.com'.
APPEND lv_user  TO ls_batch_request-add_protected_range-protected_range-editors-users.
lv_user  = 'alessandro.iannacci@techedgegroup.com'.
APPEND lv_user  TO ls_batch_request-add_protected_range-protected_range-editors-users.

ls_batch_request-add_protected_range-protected_range-editors-domain_users_can_edit = 'false'.

lo_batch_req_obj->add_request( ip_batch_req = ls_batch_request ).

lo_batch_req_obj->send_request(
  EXPORTING
    ip_spreadsheet_id = ls_spreadsheet-spreadsheet_id
*     IP_SHEET_ID       = '0'
).

***Share the new excel
DATA: ls_permission TYPE zgdrive_permission_s.




ls_permission-role = 'writer'.
ls_permission-type = 'user'.
ls_permission-email_address = 'tewe88@gmail.com'.

*Creating new permission and share
zcl_gdrive_permission_api=>create(
  EXPORTING
    ip_spreadsheet_id =  ls_spreadsheet-spreadsheet_id" Spreadsheet where to apply the permission
    ip_permission     =  ls_permission   " A permisssione for a google drive file
).
