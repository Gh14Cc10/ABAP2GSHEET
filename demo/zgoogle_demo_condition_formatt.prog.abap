*&---------------------------------------------------------------------*
*& ReportZGOOGLE_DEMO_UPD_CONDIT_FORMAT
*&---------------------------------------------------------------------*
*& - Update spreadsheet with  conditional formatting and using a gradient color
*&---------------------------------------------------------------------*
REPORT ZGOOGLE_DEMO_CONDITION_FORMATT.

"to be used with ZGOOGLE_DEMO_ADD_SHEET
"riga 2 colora il max verde e il min rosso
"riga 4 colora il max blu e il min giallo

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
*              "sheetId": sheetId,
*              "startRowIndex": 9,
*              "endRowIndex": 10,
*            }
*          ],
*          "gradientRule": {
*            "minpoint": {
*              "color": {
*                "green": 0.2,
*                "red": 0.8
*              },
*              "type": "MIN"
*            },
*            "maxpoint": {
*              "color": {
*                "green": 0.9
*              },
*              "type": "MAX"
*            },
*          }
*        },
*        "index": 0
*      }
*    },
*    {
*      "addConditionalFormatRule": {
*        "rule": {
*          "ranges": [
*            {
*              "sheetId": sheetId,
*              "startRowIndex": 10,
*              "endRowIndex": 11,
*            }
*          ],
*          "gradientRule": {
*            "minpoint": {
*              "color": {
*                "green": 0.8,
*                "red": 0.8
*              },
*              "type": "NUMBER",
*              "value": "0"
*            },
*            "maxpoint": {
*              "color": {
*                "blue": 0.9,
*                "green": 0.5,
*                "red": 0.5
*              },
*              "type": "NUMBER",
*              "value": "256"
*            },
*          }
*        },
*        "index": 1
*      }
*    },
*  ]
*}

ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-RANGES-SHEET_ID = '0'.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-RANGES-START_ROW_INDEX = 1.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-RANGES-END_ROW_INDEX = 2.

ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-GRADIENT_RULE-MINPOINT-color-green = '0.2'.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-GRADIENT_RULE-MINPOINT-color-red = '0.8'.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-GRADIENT_RULE-MINPOINT-type = 'MIN'.


ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-GRADIENT_RULE-MAXPOINT-color-green = '0.9'.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-GRADIENT_RULE-MAXPOINT-type = 'MAX'.

ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-INDEX = 0.

lo_batch_req_obj->ADD_REQUEST( IP_BATCH_REQ = ls_request_batch  ).
CLEAR ls_request_batch.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-RANGES-SHEET_ID = '0'.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-RANGES-START_ROW_INDEX = 3.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-RANGES-END_ROW_INDEX = 4.

ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-GRADIENT_RULE-MINPOINT-color-green = '0.8'.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-GRADIENT_RULE-MINPOINT-color-red = '0.8'.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-GRADIENT_RULE-MINPOINT-type = 'NUMBER'.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-GRADIENT_RULE-MINPOINT-value = '0'.

ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-GRADIENT_RULE-MAXPOINT-color-blue = '0.9'.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-GRADIENT_RULE-MAXPOINT-color-green = '0.5'.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-GRADIENT_RULE-MAXPOINT-color-red = '0.5'.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-GRADIENT_RULE-MAXPOINT-type = 'NUMBER'.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-RULE-GRADIENT_RULE-MAXPOINT-value = '256'.
ls_request_batch-ADD_CONDITIONAL_FORMAT_RULE-INDEX = 1.


lo_batch_req_obj->ADD_REQUEST( IP_BATCH_REQ = ls_request_batch  ).
CLEAR ls_request_batch.

lo_batch_req_obj->SEND_REQUEST(
  exporting
    IP_SPREADSHEET_ID =  lv_spreadsheet_id

).
