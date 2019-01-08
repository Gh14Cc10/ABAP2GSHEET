*&---------------------------------------------------------------------*
*& Report ZGDEMO_UPDATE_FORMAT
*&---------------------------------------------------------------------*
*& - Update border format for a big range of cells
*&---------------------------------------------------------------------*
REPORT zgoogle_demo_update_borders.

"to be used with ZGOOGLE_DEMO_ADD_SHEET

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
*      lt_requests type ZGSHEET_BATCH_UPDATE_REQS_TT,
*      ls_request_s type zgsheet_batch_update_reqs_s,

  ls_request_batch  TYPE zgsheet_batch_update_req_s,

  lo_batch_req_obj  TYPE REF TO zcl_gsheet_batch_req,
  ls_range_object   TYPE zgsheet_grid_range_s,
  ls_border_object  TYPE zgsheet_border_s,
  lv_spreadsheet_id TYPE string.
lv_spreadsheet_id =  zcl_gsheet_utility=>extract_spreadsheet_id( ip_url = p_url ).

CREATE OBJECT lo_batch_req_obj TYPE zcl_gsheet_batch_req.
** Original json request

*{
*  "requests": [
*    {
*      "updateBorders": {
*        "range": {
*          "sheetId": sheetId,
*          "startRowIndex": 0,
*          "endRowIndex": 10,
*          "startColumnIndex": 0,
*          "endColumnIndex": 6
*        },
*        "top": {
*          "style": "DASHED",
*          "width": 1,
*          "color": {
*            "blue": 1.0
*          },
*        },
*        "bottom": {
*          "style": "DASHED",
*          "width": 1,
*          "color": {
*            "blue": 1.0
*          },
*        },
*        "innerHorizontal": {
*          "style": "DASHED",
*          "width": 1,
*          "color": {
*            "blue": 1.0
*          },
*        },
*      }
*    }
*  ]
*}
ls_range_object-sheet_id = '0'.
ls_range_object-start_row_index = 0.
ls_range_object-end_row_index = 10.
ls_range_object-start_column_index = 0.
ls_range_object-end_column_index = 6.
ls_request_batch-update_borders-range = ls_range_object.

ls_border_object-style = 'SOLID'.
ls_border_object-color-blue = '1'.
ls_border_object-color-red = '0.5'.
ls_border_object-color-green = '0.2'.
ls_border_object-color-alpha = '1'.
ls_request_batch-update_borders-top = ls_border_object.

CLEAR ls_border_object.

ls_border_object-style = 'SOLID'.
ls_border_object-color-blue = '0'.
ls_request_batch-update_borders-bottom = ls_border_object.
CLEAR ls_border_object.


ls_border_object-style = 'SOLID'.
ls_border_object-color-blue = '0'.
ls_request_batch-update_borders-inner_horizontal = ls_border_object.
CLEAR ls_border_object.


lo_batch_req_obj->add_request( ip_batch_req = ls_request_batch  ).
CLEAR ls_request_batch.
*ls_request_batch-DELETE_SHEET-SHEET_ID = 66289711.
*ADD_SHEET-PROPERTIES-TITLE = 'New sheet'.

*lv_batch_req_obj->ADD_REQUEST( IP_BATCH_REQ = ls_request_batch  ).
lo_batch_req_obj->send_request(
  EXPORTING
    ip_spreadsheet_id =  lv_spreadsheet_id
*    IP_SHEET_ID       = '0'
).
