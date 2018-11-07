*&---------------------------------------------------------------------*
*& Report ZGOOGLE_BATCH_UPD_VALUE
*&---------------------------------------------------------------------*
*& Usage of Spreadsheet values batch update
*&---------------------------------------------------------------------*
REPORT ZGOOGLE_BATCH_UPD_VALUE.

"to be used with ZGOOGLE_DEMO_ADD_SHEET

SELECTION-SCREEN: BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-001.

selection-screen begin of line.
selection-screen comment (16) text-002.
selection-screen END OF LINE.

selection-screen begin of line.
PARAMETERS: p_url type string OBLIGATORY LOWER CASE.
selection-screen END OF LINE.

selection-screen begin of line.
selection-screen comment (16) text-003.
selection-screen END OF LINE.

selection-screen begin of line.
PARAMETERS: p_range1 type string OBLIGATORY LOWER CASE DEFAULT 'A1'.
selection-screen END OF LINE.

selection-screen begin of line.
selection-screen comment (16) text-004.
selection-screen END OF LINE.

selection-screen begin of line.
PARAMETERS: p_range2 type string OBLIGATORY LOWER CASE DEFAULT 'B2'.
selection-screen END OF LINE.



SELECTION-SCREEN:END OF BLOCK bl1 .
DATA:

*Request object
lo_request_obj    type ref to ZCL_GSHEET_BATCH_VALUE_REQ,
*Request structure
ls_request        type ZGSHEET_BATCH_UPDATE_VAL_REQ_S,

*Values structure
lt_values         TYPE TABLE OF ZGSHEET_STRING_TT,
ls_value          LIKE LINE OF lt_values,
*Range structure
ls_value_range    type ZGSHEET_VALUE_RANGES_S,
ls_value_string   LIKE LINE OF lt_values,

lv_spreadsheet_id type string.
lv_spreadsheet_id = ZCL_GSHEET_UTILITY=>EXTRACT_SPREADSHEET_ID( ip_url = p_url ).

CREATE OBJECT lo_request_obj type ZCL_GSHEET_BATCH_VALUE_REQ.


APPEND '1' TO ls_value.
APPEND   ls_value TO  lt_values.
CLEAR: ls_value_string,
        ls_value.


APPEND '2' TO ls_value.
APPEND   ls_value TO  lt_values.


CLEAR: ls_value_string,
        ls_value.

APPEND '3' TO ls_value.
APPEND   ls_value TO  lt_values.

*range1
ls_value_range-RANGE = p_range1.
ls_value_range-VALUES = lt_values .
APPEND ls_value_range  TO ls_request-DATA.
CLEAR ls_value.
*range2
ls_value_range-RANGE = p_range2.
ls_value_range-VALUES = lt_values .
APPEND ls_value_range  TO ls_request-DATA.
CLEAR ls_value.

ls_request-VALUE_INPUT_OPTION = 'USER_ENTERED'.

lo_request_obj->ADD_REQUEST( IP_REQUEST = ls_request  ).
lo_request_obj->SEND_REQUEST(
  exporting
    IP_SPREADSHEET_ID =  lv_spreadsheet_id
    IP_SHEET_ID       = '0'
).
