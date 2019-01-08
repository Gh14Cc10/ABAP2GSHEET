*&---------------------------------------------------------------------*
*& Report ZGOOGLE_BATCH_UPD_VALUE
*&---------------------------------------------------------------------*
*& Usage of Spreadsheet values batch update
*&---------------------------------------------------------------------*
REPORT zgoogle_batch_upd_value.

"to be used with ZGOOGLE_DEMO_ADD_SHEET

SELECTION-SCREEN: BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-001.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (16) TEXT-002.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_url TYPE string OBLIGATORY LOWER CASE.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (16) TEXT-003.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_range1 TYPE string OBLIGATORY LOWER CASE DEFAULT 'A1'.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (16) TEXT-004.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_range2 TYPE string OBLIGATORY LOWER CASE DEFAULT 'B2'.
SELECTION-SCREEN END OF LINE.



SELECTION-SCREEN:END OF BLOCK bl1 .
DATA:

*Request object
  lo_request_obj    TYPE REF TO zcl_gsheet_batch_value_req,
*Request structure
  ls_request        TYPE zgsheet_batch_update_val_req_s,

*Values structure
  lt_values         TYPE TABLE OF zgsheet_string_tt,
  ls_value          LIKE LINE OF lt_values,
*Range structure
  ls_value_range    TYPE zgsheet_value_ranges_s,
  ls_value_string   LIKE LINE OF lt_values,

  lv_spreadsheet_id TYPE string.
lv_spreadsheet_id = zcl_gsheet_utility=>extract_spreadsheet_id( ip_url = p_url ).

CREATE OBJECT lo_request_obj TYPE zcl_gsheet_batch_value_req.


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
ls_value_range-range = p_range1.
ls_value_range-values = lt_values .
APPEND ls_value_range  TO ls_request-data.
CLEAR ls_value.
*range2
ls_value_range-range = p_range2.
ls_value_range-values = lt_values .
APPEND ls_value_range  TO ls_request-data.
CLEAR ls_value.

ls_request-value_input_option = 'USER_ENTERED'.

lo_request_obj->add_request( ip_request = ls_request  ).
lo_request_obj->send_request(
  EXPORTING
    ip_spreadsheet_id =  lv_spreadsheet_id
    ip_sheet_id       = '0'
).
