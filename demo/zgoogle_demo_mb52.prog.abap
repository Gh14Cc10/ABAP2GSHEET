*&---------------------------------------------------------------------*
*& Report ZGOOGLE_DEMO_LIVE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZGOOGLE_DEMO_LIVE_MB52_FIXED.
SELECTION-SCREEN: BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-002.





selection-screen begin of line.
selection-screen comment (17) text-004.
selection-screen END OF LINE.

selection-screen begin of line.
PARAMETERS: p_title type string OBLIGATORY LOWER CASE.
selection-screen END OF LINE.

selection-screen begin of line.
selection-screen comment (16) text-005.
selection-screen END OF LINE.

selection-screen begin of line.
PARAMETERS: p_vari type c length 16 OBLIGATORY LOWER CASE DEFAULT 'GSHEET_VAR'.
selection-screen END OF LINE.



SELECTION-SCREEN:END OF BLOCK bl1 .

DATA lr_alv_data  TYPE REF TO data.



DATA: lv_batch_req_obj   type ref to ZCL_GSHEET_BATCH_REQ,
      lv_spreadsheet_obj type ref to ZCL_GSPREADSHEET,
      ls_spreadsheet     type ZGSPREADSHEET_S.

* Values grid
DATA: lt_values      type ZGSHEET_ARRAY_STRING_TT,
      lt_value       LIKE LINE OF lt_values,
      lv_value_range TYPE ZGSHEET_VALUE_RANGES_S.



DATA: LV_COLUMN_N      type INT3,
      ls_request_batch type ZGSHEET_BATCH_UPDATE_REQ_S.


DATA:
  lt_keyfields  type abap_keydescr_tab,
  ls_column     type abap_keydescr.

FIELD-SYMBOLS <Ft_alv_data>   TYPE ANY TABLE.
FIELD-SYMBOLS <FS_line>   TYPE ANY.
FIELD-SYMBOLS <FS_field>   TYPE ANY.



cl_salv_bs_runtime_info=>set(
  EXPORTING display  = abap_false
            metadata = abap_true
            data     = abap_true ).


* Submit Report
SUBMIT RM07MLBS
  USING SELECTION-SET p_vari
  AND RETURN.

TRY.

    cl_salv_bs_runtime_info=>GET_DATA_REF(
      importing
        R_DATA                     = lr_alv_data
    ).

    ASSIGN lr_alv_data->* TO <ft_alv_data>.

  CATCH cx_salv_bs_sc_runtime_info.
    MESSAGE `Unable to retrieve ALV data` TYPE 'E'.
ENDTRY.
cl_salv_bs_runtime_info=>clear_all( ).




*--------





CREATE OBJECT lv_batch_req_obj type ZCL_GSHEET_BATCH_REQ.

*Local spreadsheet
ls_spreadsheet-PROPERTIES-TITLE = p_title.



*Creation on google drive
ZCL_GSPREADSHEET_API=>CREATE_NEW_SPREADSHEET(
  exporting
    IP_SPREADSHEET_S =     ls_spreadsheet  " Google sheet object structure
  importing
    EP_SPREADSHEET   =     lv_spreadsheet_obj " Google sheet object structure
).
CLEAR ls_spreadsheet.
ls_spreadsheet = LV_SPREADSHEET_OBJ->GET_ABAP_OBJ( ).







* Writing header

APPEND 'Material ID' TO LT_VALUE.
APPEND 'Plant ID' TO LT_VALUE.
APPEND 'Storage location ID' TO LT_VALUE.
APPEND 'Base Unit of Measure' TO LT_VALUE.
APPEND 'Unrestricted Stock' TO LT_VALUE.
APPEND 'Currency' TO LT_VALUE.
APPEND 'Unrestricted Value' TO LT_VALUE.
APPEND 'Transit Stock' TO LT_VALUE.
APPEND 'Transit Value' TO LT_VALUE.
APPEND 'Quality Inspection Stock' TO LT_VALUE.
APPEND 'Quality Inspection Value' TO LT_VALUE.
APPEND 'Restricted Stock' TO LT_VALUE.
APPEND 'Restricted Value' TO LT_VALUE.
APPEND 'Blocked Stock' TO LT_VALUE.
APPEND 'Blocked Value' TO LT_VALUE.
APPEND 'Returns Stock' TO LT_VALUE.
APPEND 'Returns Value' TO LT_VALUE.
APPEND 'Material' TO LT_VALUE.
APPEND 'Plant' TO LT_VALUE.
APPEND 'Material type' TO LT_VALUE.
APPEND 'Material Group' TO LT_VALUE.
APPEND 'Storage Location' TO LT_VALUE.
APPEND  lt_value TO lt_values.
DESCRIBE TABLE lt_value LINES LV_COLUMN_N.
CLEAR lt_value.



ls_request_batch-REPEAT_CELL-RANGE-START_COLUMN_INDEX = '0'.
ls_request_batch-REPEAT_CELL-RANGE-END_ROW_INDEX = '1'.
ls_request_batch-REPEAT_CELL-RANGE-END_COLUMN_INDEX = LV_COLUMN_N.
ls_request_batch-REPEAT_CELL-FIELDS = 'USER_ENTERED_FORMAT'.
ls_request_batch-REPEAT_CELL-CELL-USER_ENTERED_FORMAT-BACKGROUND_COLOR-RED = '0.75'.
ls_request_batch-REPEAT_CELL-CELL-USER_ENTERED_FORMAT-BACKGROUND_COLOR-BLUE = '075'.
ls_request_batch-REPEAT_CELL-CELL-USER_ENTERED_FORMAT-BACKGROUND_COLOR-GREEN = '0.75'.
ls_request_batch-REPEAT_CELL-CELL-USER_ENTERED_FORMAT-BACKGROUND_COLOR-ALPHA = '1'.
LV_BATCH_REQ_OBJ->ADD_REQUEST(
  exporting
    IP_BATCH_REQ           =   ls_request_batch  " Request structure for spreadsheet batchupdate
).
CLEAR ls_request_batch.
ls_request_batch-UPDATE_DIMENSION_PROPERTIES-FIELDS = 'pixelSize'.
ls_request_batch-UPDATE_DIMENSION_PROPERTIES-PROPERTIES-PIXEL_SIZE = '60'.
ls_request_batch-UPDATE_DIMENSION_PROPERTIES-RANGE-SHEET_ID = '0'.
ls_request_batch-UPDATE_DIMENSION_PROPERTIES-RANGE-DIMENSION = 'ROWS'.
ls_request_batch-UPDATE_DIMENSION_PROPERTIES-range-START_INDEX = '0'.
ls_request_batch-UPDATE_DIMENSION_PROPERTIES-range-END_INDEX = '1'.

LV_BATCH_REQ_OBJ->ADD_REQUEST(
  exporting
    IP_BATCH_REQ           =   ls_request_batch  " Request structure for spreadsheet batchupdate
).

LV_BATCH_REQ_OBJ->SEND_REQUEST( IP_SPREADSHEET_ID = ls_spreadsheet-SPREADSHEET_ID ).
CLEAR ls_request_batch.



** Writing values

*First cell where to start the table
lv_value_range-RANGE = 'A1'.

APPEND 'MATNR' TO LT_KEYFIELDS.
APPEND 'WERKS' TO LT_KEYFIELDS.
APPEND 'LGORT' TO LT_KEYFIELDS.

APPEND 'MEINS' TO LT_KEYFIELDS.
APPEND 'LABST' TO LT_KEYFIELDS.
APPEND 'WAERS' TO LT_KEYFIELDS.

APPEND 'WLABS' TO LT_KEYFIELDS.
APPEND 'UMLME' TO LT_KEYFIELDS.
APPEND 'WUMLM' TO LT_KEYFIELDS.

APPEND 'INSME' TO LT_KEYFIELDS.
APPEND 'WINSM' TO LT_KEYFIELDS.
APPEND 'EINME' TO LT_KEYFIELDS.

APPEND 'WEINM' TO LT_KEYFIELDS.
APPEND 'SPEME' TO LT_KEYFIELDS.
APPEND 'WSPEM' TO LT_KEYFIELDS.
APPEND 'RETME' TO LT_KEYFIELDS.
APPEND 'WRETM' TO LT_KEYFIELDS.
APPEND 'MAKTX' TO LT_KEYFIELDS.
APPEND 'NAME1' TO LT_KEYFIELDS.
APPEND 'MTART' TO LT_KEYFIELDS.
APPEND 'MATKL' TO LT_KEYFIELDS.
APPEND 'LGOBE' TO LT_KEYFIELDS.



LOOP AT <Ft_alv_data> ASSIGNING <FS_LINE>.
  LOOP AT  LT_KEYFIELDS INTO LS_COLUMN.
    ASSIGN COMPONENT LS_COLUMN-NAME OF STRUCTURE <FS_LINE> TO  <FS_FIELD>.



    IF SY-SUBRC EQ 0.

      APPEND  <FS_FIELD>  TO lt_value.

    ENDIF.

  ENDLOOP.

  APPEND  lt_value TO lt_values.
  CLEAR lt_value.
ENDLOOP.



lv_value_range-VALUES = lt_values.
ZCL_GSPREADSHEET_VALUES_API=>APPEND(
  exporting
    IP_SPREADSHEET_ID =   ls_spreadsheet-SPREADSHEET_ID "'13R2I5IKMYRVgdjTe1bMAeVkS1Fs4AZlsM97_TKup_H4'
    IP_RANGE          =  'A1'
    IP_VALUE_RANGE    =    lv_Value_Range " Values within a range of the spreadsheet structure

).

WRITE text-006.
WRITE ls_spreadsheet-SPREADSHEET_URL.
