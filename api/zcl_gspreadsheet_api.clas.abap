class ZCL_GSPREADSHEET_API definition
  public
  final
  create public .

public section.

  constants GC_ENDPOINT_URL type STRING value 'https://sheets.googleapis.com/v4/spreadsheets/{spreadsheetId}' ##NO_TEXT.
  data SPREADSHEET_ID type STRING .

  class-methods BATCH_UPDATE
    importing
      value(IP_SPREADSHEET_ID) type STRING
      value(IP_BATCH_REQS) type ZGSHEET_BATCH_UPDATE_REQS_S .
  class-methods CREATE_NEW_SPREADSHEET
    importing
      value(IP_SPREADSHEET_S) type ZGSPREADSHEET_S optional
    exporting
      !EP_SPREADSHEET type ref to ZCL_GSPREADSHEET .
  class-methods GET_SPREADSHEET
    importing
      value(PA_SPREADSHEET_ID) type STRING
      !IT_RANGE_TABLE type ZGSHEET_STRING_TT optional
    returning
      value(PA_SPREADSHEET) type ZGSPREADSHEET_S .
  class-methods GET_SPREADSHEET_FILTER .
protected section.
private section.
ENDCLASS.



CLASS ZCL_GSPREADSHEET_API IMPLEMENTATION.


  method BATCH_UPDATE.



    DATA: lv_target       TYPE string VALUE GC_ENDPOINT_URL,
          lv_response_str TYPE string,
          lv_req_json     type string.
*    CREATE OBJECT lv_GHTTP TYPE ZCL_GOOGLE_HTTP_API.





    REPLACE '{spreadsheetId}' WITH IP_SPREADSHEET_ID  INTO lv_target.
    CONCATENATE lv_target ':batchUpdate' INTO lv_target.


    ZCL_GOOGLE_HTTP_API=>DECODE_ABAP2JSON(
    importing
   EP_JSON      =  lv_req_json
    changing
    CP_ABAP_DATA = IP_BATCH_REQS
    ).



    ZCL_GOOGLE_HTTP_API=>SEND_POST_REQUEST(
      exporting
        IP_TARGET          = lv_target
        IP_PARAM_KIND      = 'H'
*     PT_PARAM           =     " HTTP Framework (iHTTP) Table Name/Value Pairs
        IP_JSON_REQUEST    = LV_REQ_JSON
      importing
        EP_RESPONSE_STRING =  lv_response_str
    ).






  endmethod.


  method CREATE_NEW_SPREADSHEET.
*input: file resource
*output: An instance of spreadsheet created
*
    DATA:
      lv_spreadsheet_obj TYPE REF TO  ZCL_GSPREADSHEET,
      lt_param           TYPE tihttpnvp,
      ls_param           TYPE ihttpnvp,
*          GOBJECT            TYPE REF TO  ZCL_GOOGLE_HTTP_API,
      lv_target          TYPE string value GC_ENDPOINT_URL,
      lv_json_req        TYPE string,
      lv_response_str    TYPE string.
    CREATE OBJECT: lv_spreadsheet_obj TYPE ZCL_GSPREADSHEET.
*
    REPLACE '{spreadsheetId}' WITH '' INTO lv_target.


    ZCL_GOOGLE_HTTP_API=>DECODE_ABAP2JSON(
      importing
        EP_JSON      = lv_json_req
      changing
        CP_ABAP_DATA = IP_SPREADSHEET_S
    ).

*    lv_json_req = '{"role":"writer","type":"user","emailAddress":"micael.teweldemedhin@techedgegroup.com"}'.
    ZCL_GOOGLE_HTTP_API=>SEND_POST_REQUEST(
      exporting
        IP_TARGET          =  lv_target
        IP_PARAM_KIND      = 'H'
        TP_PARAM           =  lt_param   " HTTP Framework (iHTTP) Table Name/Value Pairs
        IP_JSON_REQUEST    = lv_json_req
      importing
        EP_RESPONSE_STRING =   lv_response_str
    ).



    lv_spreadsheet_obj->SET_JSON( P_GSHEET_JSON =    lv_response_str   ).
*    ME->SET_ABAP_OBJ(P_GSHEET_ABAP =    LS_SPREADSHEET  )
    EP_SPREADSHEET =  LV_SPREADSHEET_OBJ.


  endmethod.


method GET_SPREADSHEET.
*********
* Return a spreasdsheet values and data
*********



DATA: GOBJECT            TYPE REF TO ZCL_GOOGLE_HTTP_API,
      lt_param           TYPE tihttpnvp,
      ls_param           TYPE ihttpnvp,
      lv_get_response    type ref to IF_HTTP_RESPONSE,
      lv_target type string VALUE 'https://sheets.googleapis.com/v4/spreadsheets/&1',
      ls_range type string,
      lv_response_string TYPE string.
CREATE OBJECT GOBJECT TYPE ZCL_GOOGLE_HTTP_API.

**Query parameters
ls_param-name = 'includeGridData'.
ls_param-value = 'true'.
APPEND ls_param TO lt_param.



LOOP AT IT_RANGE_TABLE INTO ls_range.
 ls_param-name = 'ranges'.
ls_param-value =  ls_range.
APPEND ls_param TO lt_param.
CLEAR ls_param.
ENDLOOP.

*ls_param-name = 'ranges'.
*ls_param-value = 'B1'.
*APPEND ls_param TO lt_param.





REPLACE '&1' WITH PA_SPREADSHEET_ID INTO lv_target.


GOBJECT->SEND_GET_REQUEST(
  exporting

    TARGET = lv_target
    PARAM_KIND =      'F'
    LT_PARAM   =     lt_param" HTTP Framework (iHTTP) Table Name/Value Pairs
      importing
   response_string = lv_response_string
   RESPONSE = lv_get_response
).






ZCL_GOOGLE_HTTP_API=>ENCODE_JSON2ABAP(
  exporting
    IP_JSON      = lv_response_string
  changing
    CP_ABAP_DATA =  PA_SPREADSHEET
).




  endmethod.


  method GET_SPREADSHEET_FILTER.
  endmethod.
ENDCLASS.
