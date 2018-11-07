*&---------------------------------------------------------------------*
*& Report ZGOOGLE_DEMO_LIVE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZGOOGLE_DEMO_MB51.

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



*
DATA: lt_values      type ZGSHEET_ARRAY_STRING_TT,
      lt_value       LIKE LINE OF lt_values,
      lv_value_range TYPE ZGSHEET_VALUE_RANGES_S.



DATA: LV_COLUMN_N      type INT3,
      ls_request_batch type ZGSHEET_BATCH_UPDATE_REQ_S.

DATA: lv_batch_req_obj   type ref to ZCL_GSHEET_BATCH_REQ,
      lv_spreadsheet_obj type ref to ZCL_GSPREADSHEET,
      ls_spreadsheet     type ZGSPREADSHEET_S.

FIELD-SYMBOLS <Ft_alv_data>   TYPE ANY TABLE.
FIELD-SYMBOLS <FS_line>   TYPE ANY.
FIELD-SYMBOLS <FS_field>   TYPE ANY.




cl_salv_bs_runtime_info=>set(
  EXPORTING display  = abap_false
            metadata = abap_true
            data     = abap_true ).


* Submit Report
SUBMIT RM07DOCS
  USING SELECTION-SET p_vari
  AND RETURN.
*Reading ALV from memory
TRY.

    cl_salv_bs_runtime_info=>GET_DATA_REF(
      importing
        R_DATA                     = lr_alv_data
    ).

    ASSIGN lr_alv_data->* TO <ft_alv_data>.

    DATA:
      lo_tabledescr type ref to cl_abap_tabledescr,
      lt_keyfields  type abap_keydescr_tab,
      ls_column     type abap_keydescr,
      lv_col_name   type c length 30.


    .
  CATCH cx_salv_bs_sc_runtime_info.
    MESSAGE `Unable to retrieve ALV data` TYPE 'E'.
ENDTRY.
*Clear memory
cl_salv_bs_runtime_info=>clear_all( ).




*--------



CREATE OBJECT lv_batch_req_obj type ZCL_GSHEET_BATCH_REQ.

*Set spreadsheet title
ls_spreadsheet-PROPERTIES-TITLE = p_title.



*Google spreadsheet creation on google drive
ZCL_GSPREADSHEET_API=>CREATE_NEW_SPREADSHEET(
  exporting
    IP_SPREADSHEET_S =     ls_spreadsheet  " Google sheet object structure
  importing
    EP_SPREADSHEET   =     lv_spreadsheet_obj " Google sheet object structure
).
CLEAR ls_spreadsheet.
*Retrieve the spreadsheet created
ls_spreadsheet = LV_SPREADSHEET_OBJ->GET_ABAP_OBJ( ).







*Label for the header line

APPEND 'Plant ID' TO lt_value.
APPEND 'Plant' TO lt_value.
APPEND 'Storage location' TO lt_value.
APPEND 'Material ID' TO lt_value.
APPEND 'Material' TO lt_value.
APPEND 'Reason for Movement' TO lt_value.
APPEND 'Movement indicator' TO lt_value.
APPEND 'Trans./Event Type' TO lt_value.
APPEND 'Movement Type' TO lt_value.
APPEND 'Quantity' TO lt_value.
APPEND 'Base Unit of Measure' TO lt_value.
APPEND 'Debit/Credit ind' TO lt_value.
APPEND 'Material Document' TO lt_value.
APPEND 'Item' TO lt_value.
APPEND 'Posting Date' TO lt_value.
APPEND 'Year' TO lt_value.
APPEND 'User' TO lt_value.
APPEND 'Reference' TO lt_value.
APPEND 'Vendor' TO lt_value.
APPEND 'Purchase order' TO lt_value.
APPEND 'PO Item' TO lt_value.
APPEND 'Amount' TO lt_value.
APPEND 'Currency' TO lt_value.
APPEND 'Company' TO lt_value.


APPEND  lt_value TO lt_values.

*Count number of coulumn
DESCRIBE TABLE lt_value LINES LV_COLUMN_N.
CLEAR lt_value.


*Set the header size
ls_request_batch-REPEAT_CELL-RANGE-START_COLUMN_INDEX = '0'.
ls_request_batch-REPEAT_CELL-RANGE-END_ROW_INDEX = '1'.
ls_request_batch-REPEAT_CELL-RANGE-END_COLUMN_INDEX = LV_COLUMN_N.
ls_request_batch-REPEAT_CELL-FIELDS = 'USER_ENTERED_FORMAT'.
ls_request_batch-REPEAT_CELL-CELL-USER_ENTERED_FORMAT-BACKGROUND_COLOR-RED = '0.2'.
ls_request_batch-REPEAT_CELL-CELL-USER_ENTERED_FORMAT-BACKGROUND_COLOR-BLUE = '0.8'.
ls_request_batch-REPEAT_CELL-CELL-USER_ENTERED_FORMAT-BACKGROUND_COLOR-GREEN = '1'.
ls_request_batch-REPEAT_CELL-CELL-USER_ENTERED_FORMAT-BACKGROUND_COLOR-ALPHA = '1'.
LV_BATCH_REQ_OBJ->ADD_REQUEST(
  exporting
    IP_BATCH_REQ           =   ls_request_batch  " Request structure for spreadsheet batchupdate
).
LV_BATCH_REQ_OBJ->SEND_REQUEST( IP_SPREADSHEET_ID = ls_spreadsheet-SPREADSHEET_ID ).
CLEAR ls_request_batch.



** Writing values

*First cell where to start the table
lv_value_range-RANGE = 'A1'.

APPEND 'WERKS' TO LT_KEYFIELDS.
APPEND 'NAME1' TO LT_KEYFIELDS.
APPEND 'LGORT' TO LT_KEYFIELDS.
APPEND 'MATNR' TO LT_KEYFIELDS.
APPEND 'MAKTX' TO LT_KEYFIELDS.
APPEND 'GRUND' TO LT_KEYFIELDS.
APPEND 'KZBEW' TO LT_KEYFIELDS.
APPEND 'VGART' TO LT_KEYFIELDS.
APPEND 'BTEXT' TO LT_KEYFIELDS.
APPEND 'MENGE' TO LT_KEYFIELDS.
APPEND 'MEINS' TO LT_KEYFIELDS.
APPEND 'SHKZG' TO LT_KEYFIELDS.
APPEND 'MBLNR' TO LT_KEYFIELDS.
APPEND 'ZEILE' TO LT_KEYFIELDS.
APPEND 'BUDAT' TO LT_KEYFIELDS.
APPEND 'MJAHR' TO LT_KEYFIELDS.
APPEND 'USNAM' TO LT_KEYFIELDS.
APPEND 'XBLNR' TO LT_KEYFIELDS.
APPEND 'LIFNR' TO LT_KEYFIELDS.
APPEND 'EBELN' TO LT_KEYFIELDS.
APPEND 'EBELP' TO LT_KEYFIELDS.
APPEND 'DMBTR' TO LT_KEYFIELDS.
APPEND 'WAERS' TO LT_KEYFIELDS.
APPEND 'BUKRS' TO LT_KEYFIELDS.


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
    IP_SPREADSHEET_ID =   ls_spreadsheet-SPREADSHEET_ID
    IP_RANGE          =  'A1'
    IP_VALUE_RANGE    =    lv_Value_Range " Values within a range of the spreadsheet structure

).
WRITE text-006.
WRITE ls_spreadsheet-SPREADSHEET_URL.
