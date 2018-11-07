*&---------------------------------------------------------------------*
*& Report ZGOOGLE_DEMO_LIVE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZGOOGLE_DEMO_LIVE_ANY.


SELECTION-SCREEN: BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-002.

selection-screen begin of line.
selection-screen comment (16) text-003.
selection-screen END OF LINE.

selection-screen begin of line.
PARAMETERS: p_report type c length 16 OBLIGATORY LOWER CASE.
selection-screen END OF LINE.

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
PARAMETERS: p_vari type c length 16 OBLIGATORY LOWER CASE.
selection-screen END OF LINE.



SELECTION-SCREEN:END OF BLOCK bl1 .


FIELD-SYMBOLS <Ft_alv_data>   TYPE ANY TABLE.




DATA: lt_selscreen TYPE TABLE OF rsparams,
     lr_pay_data  TYPE REF TO data,
     lo_desc TYPE REF TO CL_ABAP_DATADESCR.


cl_salv_bs_runtime_info=>set(
  EXPORTING display  = abap_false
            metadata = abap_true
            data     = abap_true ).


* Submit Report
SUBMIT (p_report)
*    WITH RFLAT_L = '
  USING SELECTION-SET p_vari
*    WITH SELECTION-TABLE lt_selscreen
  AND RETURN.

TRY.

    cl_salv_bs_runtime_info=>GET_DATA_REF(
      importing
        R_DATA                     = lr_pay_data
*          R_DATA_LINE                =      lr_pay_data
          R_DATA_DESCR               =    lo_desc " Runtime Type Services
*          R_DATA_LINE_DESCR          =     " Runtime Type Services
    ).

    ASSIGN lr_pay_data->* TO <ft_alv_data>.

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




*
DATA: lt_values      type ZGSHEET_ARRAY_STRING_TT,
      lt_value       LIKE LINE OF lt_values,
      lv_value_range TYPE ZGSHEET_VALUE_RANGES_S.



DATA: LV_COLUMN_N      type INT3,
      ls_TPARA         TYPE  TPARA,
      ls_dd04L         type DD04L,
      ls_request_batch type ZGSHEET_BATCH_UPDATE_REQ_S.

FIELD-SYMBOLS <FS_line>   TYPE ANY.
FIELD-SYMBOLS <FS_field>   TYPE ANY.




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
    APPEND   lv_col_name TO lt_value.
  ELSE.
    APPEND   LS_TPARA-PARTEXT TO lt_value.
  ENDIF.



ENDLOOP.
* Writing header

APPEND  lt_value TO lt_values.
DESCRIBE TABLE lt_value LINES LV_COLUMN_N.
CLEAR lt_value.



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



DATA: typ type string.
LOOP AT <Ft_alv_data> ASSIGNING <FS_LINE>.




  LOOP AT  LT_KEYFIELDS INTO LS_COLUMN.

    ASSIGN COMPONENT LS_COLUMN-NAME OF STRUCTURE <FS_LINE> TO  <FS_FIELD>.


    CLEAR typ.
    DESCRIBE FIELD <FS_field> TYPE typ.




*        SKip internal table
    IF SY-SUBRC EQ 0.
      IF typ  NE 'h' .

        APPEND  <FS_FIELD>  TO lt_value.
      ELSE.
*            APPEND  ''  TO lt_value.
      ENDIF.
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
