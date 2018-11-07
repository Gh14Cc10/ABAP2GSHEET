*&---------------------------------------------------------------------*
*& Report ZGOOGLE_DEMO_LIVE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZGOOGLE_DEMO_LIVE_MB52.

*SELECT * FROM MSEG INTO L_MSEG.
*
*ENDSELECT.


FIELD-SYMBOLS <lt_pay_data>   TYPE ANY TABLE.




DATA lt_selscreen TYPE TABLE OF rsparams.
DATA lr_pay_data              TYPE REF TO data.
DATA  sel_tab  type rsparams.






cl_salv_bs_runtime_info=>set(
  EXPORTING display  = abap_true
            metadata = abap_true
            data     = abap_true ).


* Submit Wage Type Reporter
SUBMIT RM07MLBS
*    WITH RFLAT_L = '
  USING SELECTION-SET 'GSHEET_VAR'
*    WITH SELECTION-TABLE lt_selscreen
  AND RETURN.

TRY.

    cl_salv_bs_runtime_info=>GET_DATA_REF(
      importing
        R_DATA                     = lr_pay_data
*          R_DATA_LINE                =      lr_pay_data
*          R_DATA_DESCR               =     " Runtime Type Services
*          R_DATA_LINE_DESCR          =     " Runtime Type Services
    ).
*        catch CX_SALV_BS_SC_RUNTIME_INFO.    "
*        IMPORTING r_data = lr_pay_data ).
    ASSIGN lr_pay_data->* TO <lt_pay_data>.




  CATCH cx_salv_bs_sc_runtime_info.
    MESSAGE `Unable to retrieve ALV data` TYPE 'E'.
ENDTRY.
cl_salv_bs_runtime_info=>clear_all( ).




*--------

DATA: lv_batch_req_obj   type ref to ZCL_GSHEET_BATCH_REQ,
      lv_spreadsheet_obj type ref to ZCL_GSPREADSHEET,
      ls_spreadsheet     type ZGSPREADSHEET_S,
      ls_batch_request   type ZGSHEET_BATCH_UPDATE_REQ_S.

CREATE OBJECT lv_batch_req_obj type ZCL_GSHEET_BATCH_REQ.

*Local spreadsheet
ls_spreadsheet-PROPERTIES-TITLE = 'MB52'.



*Creation on google drive
ZCL_GSPREADSHEET_API=>CREATE_NEW_SPREADSHEET(
  exporting
    IP_SPREADSHEET_S =     ls_spreadsheet  " Google sheet object structure
  importing
    EP_SPREADSHEET   =     lv_spreadsheet_obj " Google sheet object structure
).
CLEAR ls_spreadsheet.
ls_spreadsheet = LV_SPREADSHEET_OBJ->GET_ABAP_OBJ( ).


DATA: lt_values      type ZGSHEET_ARRAY_STRING_TT,
      lt_value       LIKE LINE OF lt_values,
      lv_value_range TYPE ZGSHEET_VALUE_RANGES_S.
lv_value_range-RANGE = 'A1'.


FIELD-SYMBOLS <lS_line>   TYPE ANY.
FIELD-SYMBOLS <lS_field>   TYPE ANY.
*


APPEND 'Material' TO lt_value.
APPEND 'Plnt ' TO lt_value.
APPEND 'SLoc ' TO lt_value.
APPEND 'SL ' TO lt_value.
APPEND 'BUn' TO lt_value.
APPEND 'Unrestricted Crcy' TO lt_value.
APPEND 'Value Unrestricted' TO lt_value.
APPEND 'Transit/Transf.' TO lt_value.
APPEND 'Val. in Trans./Tfr' TO lt_value.
APPEND 'Quality Inspection ' TO lt_value.
APPEND 'Value in QualInsp.' TO lt_value.
APPEND 'Restricted-Use' TO lt_value.
APPEND 'Value Restricted' TO lt_value.
APPEND 'Blocked Value' To lt_value.
APPEND 'BlockedStock' TO lt_value.
APPEND 'Returns Value' TO lt_value.
APPEND 'Rets Blocked' TO lt_value.
APPEND  lt_value TO lt_values.
CLEAR lt_value.
*
DATA LV_VALUE TYPE STRING.

*READ TABLE <LT_PAY_DATA>  ASSIGNING <LS_FIELD> INDEX 1.
*<LS_FIELD>-NAME.

LOOP AT <lt_pay_data> ASSIGNING <LS_LINE>.
  TRY.
      WHILE SY-SUBRC EQ 0.
        ASSIGN COMPONENT sy-INDEX OF STRUCTURE <LS_LINE> TO  <LS_FIELD>.
        DATA: typ type string.
*   LV_VALUE = <LS_FIELD>.
        CLEAR typ.
        DESCRIBE FIELD <lS_field> TYPE typ.

*        SKip internal table
        IF SY-SUBRC EQ 0 AND typ  NE 'h' .

          APPEND  <LS_FIELD>  TO lt_value.
        ELSE.
          APPEND  ''  TO lt_value.
        ENDIF.



*   APPEND <LS_FIELD> TO lt_value.
      ENDWHILE.
      APPEND  lt_value TO lt_values.

    CATCH cx_salv_bs_sc_runtime_info.
      APPEND  lt_value TO lt_values.
      CLEAR lt_value.
  ENDTRY.
*  LOOP AT <lS_line> ASSIGNING  <LS_FIELD>.
**    WRITE '3'.
*   ENDLOOP.
*  APPEND 'valoereAppeso1' TO lt_value.

*APPEND <LS_LINE>-RCLNT TO lt_value.
*APPEND <LS_LINE>-RLDNR TO lt_value.
*APPEND <LS_LINE>-RBUKRS TO lt_value.
*APPEND <LS_LINE>-GJAHR TO lt_value.
*APPEND <LS_LINE>-BELNR TO lt_value.
*APPEND LS_ACDOCA_LINE-DOCLN TO lt_value.
*APPEND LS_ACDOCA_LINE-RYEAR TO lt_value.
*APPEND LS_ACDOCA_LINE-DOCNR_LD TO lt_value.
*APPEND  lt_value TO lt_values.
*CLEAR lt_value.
ENDLOOP.


lv_value_range-VALUES = lt_values.
ZCL_GSPREADSHEET_VALUES_API=>APPEND(
  exporting
    IP_SPREADSHEET_ID =   ls_spreadsheet-SPREADSHEET_ID "'13R2I5IKMYRVgdjTe1bMAeVkS1Fs4AZlsM97_TKup_H4'
    IP_RANGE          =  'A1'
    IP_VALUE_RANGE    =    lv_Value_Range " Values within a range of the spreadsheet structure
*  importing
*    EP_VALUE_UPDATED  =
).
