*&---------------------------------------------------------------------*
*& Report ZGOOGLE_DEMO_LIVE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZGOOGLE_DEMO_LIVE_DYNAMIC.



FIELD-SYMBOLS <Ft_alv_data>   TYPE ANY TABLE.




DATA: lt_selscreen TYPE TABLE OF rsparams,
      lr_alv_data   TYPE REF TO data,
      lo_desc TYPE REF TO CL_ABAP_DATADESCR.

DATA: lo_value_range type ref to ZCL_GSHEET_VALUE_RANGE.

CREATE OBJECT lo_value_range.






cl_salv_bs_runtime_info=>set(
  EXPORTING display  = abap_false
            metadata = abap_true
            data     = abap_true ).


* Submit Report
SUBMIT RM07DOCS
*    WITH RFLAT_L = '
  USING SELECTION-SET 'GSHEET_VAR'
*    WITH SELECTION-TABLE lt_selscreen
  AND RETURN.

TRY.

    cl_salv_bs_runtime_info=>GET_DATA_REF(
      importing
        R_DATA                     = lr_alv_data
*          R_DATA_LINE                =      lr_pay_data
          R_DATA_DESCR               =    lo_desc " Runtime Type Services
*          R_DATA_LINE_DESCR          =     " Runtime Type Services
    ).

    ASSIGN lr_alv_data->* TO <ft_alv_data>.

    DATA:
          lo_tabledescr type ref to cl_abap_tabledescr,
          lt_keyfields  type abap_keydescr_tab,
          ls_column     type abap_keydescr,
          lv_col_name   type c length 30.

    lo_tabledescr ?= LO_DESC .
    lt_keyfields = lo_tabledescr->key .

.
  CATCH cx_salv_bs_sc_runtime_info.
    MESSAGE `Unable to retrieve ALV data` TYPE 'E'.
ENDTRY.
cl_salv_bs_runtime_info=>clear_all( ).




*--------

DATA: lv_batch_req_obj   type ref to ZCL_GSHEET_BATCH_REQ,
      lv_spreadsheet_obj type ref to ZCL_GSPREADSHEET,
      ls_spreadsheet     type ZGSPREADSHEET_S.

CREATE OBJECT lv_batch_req_obj type ZCL_GSHEET_BATCH_REQ.

*Local spreadsheet
ls_spreadsheet-PROPERTIES-TITLE = text-001.



*Creation on google drive
ZCL_GSPREADSHEET_API=>CREATE_NEW_SPREADSHEET(
  exporting
    IP_SPREADSHEET_S =     ls_spreadsheet  " Google sheet object structure
  importing
    EP_SPREADSHEET   =     lv_spreadsheet_obj " Google sheet object structure
).
CLEAR ls_spreadsheet.
ls_spreadsheet = LV_SPREADSHEET_OBJ->GET_ABAP_OBJ( ).




*

*      lv_value_range TYPE ZGSHEET_VALUE_RANGES_S.
*


DATA: LV_COLUMN_N      type INT3,
      ls_TPARA         TYPE  TPARA,
      ls_dd04L         type DD04L,
      ls_request_batch type ZGSHEET_BATCH_UPDATE_REQ_S.

FIELD-SYMBOLS <FS_line>   TYPE ANY.
FIELD-SYMBOLS <FS_field>   TYPE ANY.



* Create spreadsheet header taking label field from Dictionary labels
LOOP AT  LT_KEYFIELDS INTO LS_COLUMN.
  lv_col_name = LS_COLUMN-NAME.
  CALL FUNCTION 'DD_DTEL_GET'
    EXPORTING
*
      LANGU      = SY-LANGU

      ROLL_NAME  = lv_col_name
    IMPORTING

      DD04L_WA_A = ls_dd04L

      TPARA_WA   = ls_TPARA

    .
  IF SY-SUBRC <> 0 OR LS_TPARA-PARTEXT IS INITIAL.
* Implement suitable error handling here
*    APPEND   lv_col_name TO lt_value.

      lo_value_range->APPEND_CELL_VALUE( IP_VALUE =  lv_col_name  ).
  ELSE.
*    APPEND   LS_TPARA-PARTEXT TO lt_value.
    lo_value_range->APPEND_CELL_VALUE( IP_VALUE =  LS_TPARA-PARTEXT ).
  ENDIF.
ENDLOOP.
* Writing header
 lo_value_range->MOVE_NEXT_ROW( ).
*APPEND  lt_value TO lt_values.
*DESCRIBE TABLE lt_value LINES LV_COLUMN_N.
**CLEAR lt_value.
LV_COLUMN_N =  lo_value_range->GET_COLUMN_NUMBEr( ).


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
*lv_value_range-RANGE = 'A1'.



DATA: lv_type type string.
LOOP AT <Ft_alv_data> ASSIGNING <FS_LINE>.
  LOOP AT  LT_KEYFIELDS INTO LS_COLUMN.
    ASSIGN COMPONENT LS_COLUMN-NAME OF STRUCTURE <FS_LINE> TO  <FS_FIELD>.
    CLEAR lv_type.
    DESCRIBE FIELD <FS_field> TYPE lv_type.
*        SKip internal table
    IF SY-SUBRC EQ 0.
      IF lv_type  NE 'h' .
*        APPEND  <FS_FIELD>  TO lt_value.
         lo_value_range->APPEND_CELL_VALUE( IP_VALUE = <FS_FIELD> ).

      ENDIF.
    ENDIF.

  ENDLOOP.
   lo_value_range->MOVE_NEXT_ROW( ).
*  APPEND  lt_value TO lt_values.
*  CLEAR lt_value.
ENDLOOP.
*lo_value_range->GS_VALUE_RANGE-VALUES = LO_VALUE_RANGE->GT_VALUES.

*lv_value_range-VALUES = lt_values.
ZCL_GSPREADSHEET_VALUES_API=>APPEND(
  exporting
    IP_SPREADSHEET_ID =   ls_spreadsheet-SPREADSHEET_ID "'13R2I5IKMYRVgdjTe1bMAeVkS1Fs4AZlsM97_TKup_H4'
    IP_RANGE          =  'A1'
    IP_VALUE_RANGE    =   lo_value_range->GS_VALUE_RANGE  " Values within a range of the spreadsheet structure

).
