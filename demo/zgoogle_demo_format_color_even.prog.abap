*&---------------------------------------------------------------------*
*& ReportZGOOGLE_DEMO_UPD_CONDIT_FORMAT
*&---------------------------------------------------------------------*
*& - Update spreadsheet with  conditional formatting (Background colored just  for odd rows)
*&---------------------------------------------------------------------*
REPORT ZGOOGLE_DEMO_FORMAT_COLOR_EVEN.

"to be used with ZGOOGLE_DEMO_ADD_SHEET
"imposta un colore per A1-H1 personalizzato, e poi una regola che per tutte le righe pari mette un altro colore

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
*      "addConditionalFormatRule": {
*        "rule": {
*          "ranges": [
*            {
*              "sheetId": 0,
*              "startColumnIndex": 0,
*              "endColumnIndex": 8,
*      "startRowIndex":1,
*
*            },
*
*          ],
*          "booleanRule": {
*            "condition": {
*              "type": "CUSTOM_FORMULA",
*              "values": [
*                {
*                  "userEnteredValue": "=ISODD(ROW())"
*                }
*              ]
*            },
*            "format": {
*              "backgroundColor": {
*                "red": 1.05,
*                 "green": 1,
*                 "blue": 0.5,
*
*              }
*            }
*          }
*        },
*        "index": 0
*      }
*    }
*  ]
*}
CLEAR ls_request_batch.
ls_request_batch-REPEAT_CELL-range-sheet_Id =  '0'.
ls_request_batch-REPEAT_CELL-RANGE-START_ROW_INDEX = '0'.
ls_request_batch-REPEAT_CELL-RANGE-START_COLUMN_INDEX = '0'.
ls_request_batch-REPEAT_CELL-RANGE-END_ROW_INDEX = '1'.
ls_request_batch-REPEAT_CELL-RANGE-END_COLUMN_INDEX = '8'.
ls_request_batch-REPEAT_CELL-FIELDS = 'USER_ENTERED_FORMAT'.
ls_request_batch-REPEAT_CELL-CELL-USER_ENTERED_FORMAT-BACKGROUND_COLOR-RED = '0.2'.
ls_request_batch-REPEAT_CELL-CELL-USER_ENTERED_FORMAT-BACKGROUND_COLOR-BLUE = '0.8'.
ls_request_batch-REPEAT_CELL-CELL-USER_ENTERED_FORMAT-BACKGROUND_COLOR-GREEN = '1'.
ls_request_batch-REPEAT_CELL-CELL-USER_ENTERED_FORMAT-BACKGROUND_COLOR-ALPHA = '1'.
Lo_BATCH_REQ_OBJ->ADD_REQUEST(
  exporting
    IP_BATCH_REQ           =   ls_request_batch  " Request structure for spreadsheet batchupdate
).

CLEAR ls_request_batch.


DATA ls_value_condition type ZGSHEET_CONDITION_VALUE_S.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-RANGES-SHEET_ID = '0'.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-RANGES-START_COLUMN_INDEX = 0.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-RANGES-END_COLUMN_INDEX = 8.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-RANGES-START_ROW_INDEX = 1.

ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-BOOLEAN_RULE-CONDITION-type = 'CUSTOM_FORMULA'.

ls_value_condition-USER_ENTERED_VALUE = '=ISODD(ROW())'.

APPEND ls_value_condition TO
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-BOOLEAN_RULE-CONDITION-VALUES.

*ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-BOOLEAN_RULE-CONDITION-
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-BOOLEAN_RULE-FORMAT-background_Color-RED = '1.05'.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-BOOLEAN_RULE-FORMAT-background_Color-GREEN = '1'.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-BOOLEAN_RULE-FORMAT-background_Color-BLUE = '0.5'.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-INDEX = 0.

lo_batch_req_obj->ADD_REQUEST( IP_BATCH_REQ = ls_request_batch  ).
CLEAR ls_request_batch.

lo_batch_req_obj->SEND_REQUEST(
  exporting
    IP_SPREADSHEET_ID =  lv_spreadsheet_id

).
