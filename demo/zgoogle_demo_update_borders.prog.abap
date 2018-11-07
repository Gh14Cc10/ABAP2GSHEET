*&---------------------------------------------------------------------*
*& Report ZGDEMO_UPDATE_FORMAT
*&---------------------------------------------------------------------*
*& - Update border format for a big range of cells
*&---------------------------------------------------------------------*
REPORT ZGOOGLE_DEMO_UPDATE_BORDERS.

"to be used with ZGOOGLE_DEMO_ADD_SHEET

*
SELECTION-SCREEN: BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-001.

selection-screen begin of line.
selection-screen comment (16) text-002.
selection-screen END OF LINE.

selection-screen begin of line.
PARAMETERS: p_url type string OBLIGATORY LOWER CASE.
selection-screen END OF LINE.



SELECTION-SCREEN:END OF BLOCK bl1 .
DATA:
*      lt_requests type ZGSHEET_BATCH_UPDATE_REQS_TT,
*      ls_request_s type zgsheet_batch_update_reqs_s,

      ls_request_batch type ZGSHEET_BATCH_UPDATE_REQ_S,

      lo_batch_req_obj type ref to ZCL_GSHEET_BATCH_REQ,
      ls_range_object type ZGSHEET_GRID_RANGE_S,
      ls_border_object type ZGSHEET_BORDER_S,
      lv_spreadsheet_id type string.
lv_spreadsheet_id =  ZCL_GSHEET_UTILITY=>EXTRACT_SPREADSHEET_ID( ip_url = p_url ).

CREATE OBJECT lo_batch_req_obj type ZCL_GSHEET_BATCH_REQ.
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
ls_range_object-SHEET_ID = '0'.
ls_range_object-START_ROW_INDEX = 0.
ls_range_object-END_ROW_INDEX = 10.
ls_range_object-START_COLUMN_INDEX = 0.
ls_range_object-END_COLUMN_INDEX = 6.
ls_request_batch-UPDATE_BORDERS-RANGE = ls_range_object.

ls_border_object-STYLE = 'SOLID'.
ls_border_object-COLOR-BLUE = '1'.
ls_border_object-COLOR-RED = '0.5'.
ls_border_object-COLOR-GREEN = '0.2'.
ls_border_object-COLOR-ALPHA = '1'.
ls_request_batch-UPDATE_BORDERS-TOP = ls_border_object.

CLEAR ls_border_object.

ls_border_object-STYLE = 'SOLID'.
ls_border_object-COLOR-BLUE = '0'.
ls_request_batch-UPDATE_BORDERS-bottom = ls_border_object.
CLEAR ls_border_object.


ls_border_object-STYLE = 'SOLID'.
ls_border_object-COLOR-BLUE = '0'.
ls_request_batch-UPDATE_BORDERS-INNER_HORIZONTAL = ls_border_object.
CLEAR ls_border_object.


lo_batch_req_obj->ADD_REQUEST( IP_BATCH_REQ = ls_request_batch  ).
CLEAR ls_request_batch.
*ls_request_batch-DELETE_SHEET-SHEET_ID = 66289711.
*ADD_SHEET-PROPERTIES-TITLE = 'New sheet'.

*lv_batch_req_obj->ADD_REQUEST( IP_BATCH_REQ = ls_request_batch  ).
lo_batch_req_obj->SEND_REQUEST(
  exporting
    IP_SPREADSHEET_ID =  lv_spreadsheet_id
*    IP_SHEET_ID       = '0'
).
