*&---------------------------------------------------------------------*
*& Report ZGOOGLE_DEMO_DOC
*&---------------------------------------------------------------------*
*& - Read 8 columen and 500 rows from ACDOCA table
*& - Create a new spreadsheet called ACDODA
*& - Write the rows read into the spreadsheet created
*& - Update che cell format with a specific background color
*&---------------------------------------------------------------------*
REPORT ZGOOGLE_DEMO_ACDOCA_UPLOAD.
*DATA:
*  LT_ACDOCA      TYPE TABLE OF ACDOCA,
*  LS_ACDOCA_LINE LIKE LINE OF lt_ACDOCA.
*
*SELECT RCLNT
*RLDNR
*RBUKRS
*GJAHR
*BELNR
*DOCLN
*RYEAR
*DOCNR_LD FROM ACDOCA INTO TABLE LT_ACDOCA UP TO 500 ROWS.
*
*DATA: lo_batch_req_obj   type ref to ZCL_GSHEET_BATCH_REQ,
*      lo_spreadsheet_obj type ref to ZCL_GSPREADSHEET,
*      ls_spreadsheet     type ZGSPREADSHEET_S,
*      ls_batch_request   type ZGSHEET_BATCH_UPDATE_REQ_S.
*
*CREATE OBJECT lo_batch_req_obj type ZCL_GSHEET_BATCH_REQ.
*
**Local spreadsheet
*ls_spreadsheet-PROPERTIES-TITLE = 'Acdoca'.
*
*
*
**Creation on google drive
*ZCL_GSPREADSHEET_API=>CREATE_NEW_SPREADSHEET(
*  exporting
*    IP_SPREADSHEET_S =     ls_spreadsheet  " Google sheet object structure
*  importing
*    EP_SPREADSHEET   =     lo_spreadsheet_obj " Google sheet object structure
*).
*CLEAR ls_spreadsheet.
*ls_spreadsheet = LO_SPREADSHEET_OBJ->GET_ABAP_OBJ( ).
*
*
*DATA: lt_values      type ZGSHEET_ARRAY_STRING_TT,
*      lt_value       LIKE LINE OF lt_values,
*      ls_value_range TYPE ZGSHEET_VALUE_RANGES_S.
*ls_value_range-RANGE = 'A1'.
*
*
*APPEND 'RCLNT' TO lt_value.
*APPEND 'RLDNR' TO lt_value.
*APPEND 'RBUKRS' TO lt_value.
*APPEND 'GJAHR' TO lt_value.
*APPEND 'BELNR' TO lt_value.
*APPEND 'DOCLN' TO lt_value.
*APPEND 'RYEAR' TO lt_value.
*APPEND 'DOCNR_LD' TO lt_value.
*APPEND  lt_value TO lt_values.
*CLEAR lt_value.
*
*LOOP AT LT_ACDOCA INTO LS_ACDOCA_LINE.
**  APPEND 'valoereAppeso1' TO lt_value.
*APPEND LS_ACDOCA_LINE-RCLNT TO lt_value.
*APPEND LS_ACDOCA_LINE-RLDNR TO lt_value.
*APPEND LS_ACDOCA_LINE-RBUKRS TO lt_value.
*APPEND LS_ACDOCA_LINE-GJAHR TO lt_value.
*APPEND LS_ACDOCA_LINE-BELNR TO lt_value.
*APPEND LS_ACDOCA_LINE-DOCLN TO lt_value.
*APPEND LS_ACDOCA_LINE-RYEAR TO lt_value.
*APPEND LS_ACDOCA_LINE-DOCNR_LD TO lt_value.
*APPEND  lt_value TO lt_values.
*CLEAR lt_value.
*ENDLOOP.
*
*
*ls_value_range-VALUES = lt_values.
*ZCL_GSPREADSHEET_VALUES_API=>APPEND(
*  exporting
*    IP_SPREADSHEET_ID =   ls_spreadsheet-SPREADSHEET_ID "'13R2I5IKMYRVgdjTe1bMAeVkS1Fs4AZlsM97_TKup_H4'
*    IP_RANGE          =  'A1'
*    IP_VALUE_RANGE    =    ls_Value_Range " Values within a range of the spreadsheet structure
**  importing
**    EP_VALUE_UPDATED  =
*).
*
*DATA: lt_colors type ZGSHEET_COLOUR_T,
*
*      ls_color type ZGSHEET_COLOUR_S.
*
*ls_batch_request-UPDATE_SHEET_PROPERTIES-PROPERTIES-TITLE = 'First500Rows'.
*ls_color-RED = '1'.
*ls_color-GREEN = '0'.
*ls_color-BLUE = '0'.
*ls_color-ALPHA = '1'.
*APPEND ls_color TO lt_colors.
*
*ls_batch_request-UPDATE_SHEET_PROPERTIES-FIELDS = 'title'.
*LO_BATCH_REQ_OBJ->ADD_REQUEST(
*  exporting
*    IP_BATCH_REQ           =   ls_batch_request  " Request structure for spreadsheet batchupdate
*
*).
*CLEAR ls_batch_request.
*ls_batch_request-UPDATE_SHEET_PROPERTIES-PROPERTIES-TAB_COLOR = ls_color.
*ls_batch_request-UPDATE_SHEET_PROPERTIES-FIELDS = 'tab_color'.
*LO_BATCH_REQ_OBJ->ADD_REQUEST(
*  exporting
*    IP_BATCH_REQ           =   ls_batch_request  " Request structure for spreadsheet batchupdate
*).
*
*CLEAR ls_batch_request.
*
*
*
*
*LS_BATCH_REQUEST-REPEAT_CELL-range-sheet_Id =  '0'.
*ls_batch_request-REPEAT_CELL-RANGE-START_ROW_INDEX = '0'.
*ls_batch_request-REPEAT_CELL-RANGE-START_COLUMN_INDEX = '0'.
*ls_batch_request-REPEAT_CELL-RANGE-END_ROW_INDEX = '1'.
*ls_batch_request-REPEAT_CELL-RANGE-END_COLUMN_INDEX = '8'.
*LS_BATCH_REQUEST-REPEAT_CELL-FIELDS = 'USER_ENTERED_FORMAT'.
*ls_batch_request-REPEAT_CELL-CELL-USER_ENTERED_FORMAT-BACKGROUND_COLOR-RED = '1'.
*ls_batch_request-REPEAT_CELL-CELL-USER_ENTERED_FORMAT-BACKGROUND_COLOR-BLUE = '0.5'.
*ls_batch_request-REPEAT_CELL-CELL-USER_ENTERED_FORMAT-BACKGROUND_COLOR-GREEN = '0.2'.
*ls_batch_request-REPEAT_CELL-CELL-USER_ENTERED_FORMAT-BACKGROUND_COLOR-ALPHA = '1'.
*LO_BATCH_REQ_OBJ->ADD_REQUEST(
*  exporting
*    IP_BATCH_REQ           =   ls_batch_request  " Request structure for spreadsheet batchupdate
*).
*
*CLEAR ls_batch_request.
*LS_BATCH_REQUEST-REPEAT_CELL-range-sheet_Id =  '0'.
*ls_batch_request-REPEAT_CELL-RANGE-START_ROW_INDEX = '1'.
*ls_batch_request-REPEAT_CELL-RANGE-START_COLUMN_INDEX = '0'.
*ls_batch_request-REPEAT_CELL-RANGE-END_ROW_INDEX = '500'.
*ls_batch_request-REPEAT_CELL-RANGE-END_COLUMN_INDEX = '8'.
*LS_BATCH_REQUEST-REPEAT_CELL-FIELDS = 'USER_ENTERED_FORMAT'.
*ls_batch_request-REPEAT_CELL-CELL-USER_ENTERED_FORMAT-BACKGROUND_COLOR-RED = '0.20'.
*ls_batch_request-REPEAT_CELL-CELL-USER_ENTERED_FORMAT-BACKGROUND_COLOR-BLUE = '0.51'.
*ls_batch_request-REPEAT_CELL-CELL-USER_ENTERED_FORMAT-BACKGROUND_COLOR-GREEN = '0.20'.
*ls_batch_request-REPEAT_CELL-CELL-USER_ENTERED_FORMAT-BACKGROUND_COLOR-ALPHA = '1'.
*
*LO_BATCH_REQ_OBJ->ADD_REQUEST(
*  exporting
*    IP_BATCH_REQ           =   ls_batch_request  " Request structure for spreadsheet batchupdate
*).
*
*
*
*
*LO_BATCH_REQ_OBJ->SEND_REQUEST(
*  exporting
*    IP_SPREADSHEET_ID = ls_spreadsheet-SPREADSHEET_ID
**     IP_SHEET_ID       = '0'
*).
