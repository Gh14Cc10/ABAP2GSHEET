*&---------------------------------------------------------------------*
*& Report ZGOOGLE_DEMO1
*&---------------------------------------------------------------------*
*& - Create a new spreadsheet
*& - Protect a range with limiting the user that rights to edit it
*& - Share to an user
*&---------------------------------------------------------------------*
REPORT ZGOOGLE_DEMO_CREATE_PROTECT_XL.



DATA: lo_batch_req_obj type ref to ZCL_GSHEET_BATCH_REQ,
      lo_spreadsheet_obj type ref to ZCL_GSPREADSHEET,
      ls_spreadsheet type ZGSPREADSHEET_S,
      ls_batch_request type ZGSHEET_BATCH_UPDATE_REQ_S.

CREATE OBJECT lo_batch_req_obj type ZCL_GSHEET_BATCH_REQ.

*Local spreadsheet
ls_spreadsheet-PROPERTIES-TITLE = 'NewSpreadsheetTest'.



*Creaton on google drive
ZCL_GSPREADSHEET_API=>CREATE_NEW_SPREADSHEET(
  exporting
    IP_SPREADSHEET_S =     ls_spreadsheet  " Google sheet object structure
  importing
    EP_SPREADSHEET   =     lo_spreadsheet_obj " Google sheet object structure
).






* Massive update of newly created spreadsheeet
ls_spreadsheet = LO_SPREADSHEET_OBJ->GET_ABAP_OBJ( ).
LS_BATCH_REQUEST-REPEAT_CELL-range-sheet_Id =  ''.
LS_BATCH_REQUEST-REPEAT_CELL-range-START_COLUMN_INDEX = 1.
LS_BATCH_REQUEST-REPEAT_CELL-range-END_COLUMN_INDEX = 10.
LS_BATCH_REQUEST-REPEAT_CELL-range-START_ROW_INDEX  = 0.
LS_BATCH_REQUEST-REPEAT_CELL-range-END_ROW_INDEX =  2.
LS_BATCH_REQUEST-REPEAT_CELL-FIELDS = '*'.
LS_BATCH_REQUEST-REPEAT_CELL-CELL-USER_ENTERED_VALUE-NUMBER_VALUE = 28.

 lo_batch_req_obj->ADD_REQUEST( IP_BATCH_REQ = LS_BATCH_REQUEST ).

CLEAR ls_batch_request.
* Protect range of cell
ls_batch_request-ADD_PROTECTED_RANGE-PROTECTED_RANGE-RANGE-SHEET_ID = '0'.
ls_batch_request-ADD_PROTECTED_RANGE-PROTECTED_RANGE-RANGE-START_ROW_INDEX = '1'.
ls_batch_request-ADD_PROTECTED_RANGE-PROTECTED_RANGE-RANGE-end_ROW_INDEX = '20'.
ls_batch_request-ADD_PROTECTED_RANGE-PROTECTED_RANGE-RANGE-END_COLUMN_INDEX = '7'.
ls_batch_request-ADD_PROTECTED_RANGE-PROTECTED_RANGE-RANGE-START_COLUMN_INDEX = '6'.
ls_batch_request-ADD_PROTECTED_RANGE-PROTECTED_RANGE-DESCRIPTION ='no touch area'.
ls_batch_request-ADD_PROTECTED_RANGE-PROTECTED_RANGE-WARNING_ONLY = 'false'.
ls_batch_request-ADD_PROTECTED_RANGE-PROTECTED_RANGE-REQUESTING_USER_CAN_EDIT = 'false'.

DATA lv_user  type string.
lv_user  = 'micael.teweldemedhin@techedgegroup.com'.
APPEND lv_user  to ls_batch_request-ADD_PROTECTED_RANGE-PROTECTED_RANGE-EDITORS-USERS.
lv_user  = 'alessandro.iannacci@techedgegroup.com'.
APPEND lv_user  to ls_batch_request-ADD_PROTECTED_RANGE-PROTECTED_RANGE-EDITORS-USERS.

ls_batch_request-ADD_PROTECTED_RANGE-PROTECTED_RANGE-EDITORS-DOMAIN_USERS_CAN_EDIT = 'false'.

lo_batch_req_obj->ADD_REQUEST( IP_BATCH_REQ = LS_BATCH_REQUEST ).

 LO_BATCH_REQ_OBJ->SEND_REQUEST(
   exporting
     IP_SPREADSHEET_ID = ls_spreadsheet-SPREADSHEET_ID
*     IP_SHEET_ID       = '0'
 ).

***Share the new excel
 DATA: ls_permission type zgdrive_permission_s.




LS_PERMISSION-ROLE = 'writer'.
LS_PERMISSION-type = 'user'.
LS_PERMISSION-email_address = 'tewe88@gmail.com'.

*Creating new permission and share
ZCL_GDRIVE_PERMISSION_API=>CREATE(
  exporting
    IP_SPREADSHEET_ID =  ls_spreadsheet-SPREADSHEET_ID" Spreadsheet where to apply the permission
    IP_PERMISSION     =  ls_permission   " A permisssione for a google drive file
).
