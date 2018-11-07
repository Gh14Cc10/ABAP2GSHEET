class ZCL_GSPREADSHEET_VALUES_API definition
  public
  inheriting from ZCL_GOOGLE_HTTP_API
  final
  create public .

public section.

  constants GC_ENDPOINT_URL type STRING value 'https://sheets.googleapis.com/v4/spreadsheets/{spreadsheetId}/values' ##NO_TEXT.

  class-methods APPEND
    importing
      value(IP_SPREADSHEET_ID) type STRING
      value(IP_RANGE) type STRING
      value(IP_VALUE_RANGE) type ZGSHEET_VALUE_RANGES_S
    exporting
      value(EP_VALUE_UPDATED) type STRING .
  class-methods GET
    importing
      value(IP_SPREADSHEET_ID) type STRING
      value(IP_RANGE) type STRING
    returning
      value(EP_VALUE_RANGE) type ZGSHEET_VALUE_RANGES_S .
  class-methods BATCH_UPDATE
    importing
      value(IP_SPREADSHEET_ID) type STRING
      value(IP_SHEET_ID) type STRING
      value(IP_BATCH_REQ) type ZGSHEET_BATCH_UPDATE_VAL_REQ_S .
  class-methods BATCH_GET
    importing
      value(PA_SPREADSHEET_ID) type STRING
      value(PA_RANGE) type STRING
    returning
      value(PA_VALUE_RANGE) type ZGSHEET_BATCH_VALUE_GET_RESP_S .
  class-methods BATCH_CLEAR
    importing
      value(PA_SPREADSHEET_ID) type STRING
      value(PA_RANGE) type ZGSHEET_BATCH_VAL_CLEAR_REQ_S
    returning
      value(PA_VALUE_RANGE) type ZGSHEET_BATCH_VAL_CLEAR_RESP_S .
  class-methods BATCH_APPEND
    importing
      value(IP_VALUE_RANGE) type ZGSHEET_VALUE_RANGES_S
      value(IP_SPREADSHEET_ID) type STRING
      value(IP_RANGE_STRING) type STRING .
protected section.
private section.
ENDCLASS.



CLASS ZCL_GSPREADSHEET_VALUES_API IMPLEMENTATION.


  method APPEND.





DATA:
  lt_param           TYPE tihttpnvp,
  ls_param           TYPE ihttpnvp,
  lv_get_response    type ref to IF_HTTP_RESPONSE,
  lv_target          type string VALUE  GC_ENDPOINT_URL,
*'https://sheets.googleapis.com/v4/spreadsheets/$1/values/$2',
* lv_target type string value 'https://sheets.googleapis.com/v4/spreadsheets/19rDV0SsDV0M600Y_znwHChsMxTkiKm7kaJeTNddaUFk/values/A1',
      lv_req_json        type string,

  lv_response_string TYPE string.

ls_param-name = 'valueInputOption'.
ls_param-value = 'USER_ENTERED'.
APPEND ls_param TO lt_param.
CLEAR ls_param.



REPLACE '{spreadsheetId}' WITH IP_SPREADSHEET_ID INTO lv_target.
CONCATENATE lv_target '/' IP_RANGE ':append'   INTO lv_target.

    ZCL_GOOGLE_HTTP_API=>DECODE_ABAP2JSON(
    importing
   EP_JSON      =  lv_req_json
    changing
    CP_ABAP_DATA = IP_VALUE_RANGE
    ).

    ZCL_GOOGLE_HTTP_API=>SEND_POST_REQUEST(
      exporting
        IP_TARGET          = lv_target
        IP_PARAM_KIND      = 'H'
        TP_PARAM           =      lt_param" HTTP Framework (iHTTP) Table Name/Value Pairs
        IP_JSON_REQUEST    = LV_REQ_JSON
      importing
        EP_RESPONSE_STRING =  lv_response_string
    ).



*ZCL_GOOGLE_HTTP_API=>ENCODE_JSON2ABAP(
*  exporting
*    IP_JSON      = lv_response_string
*  changing
*    CP_ABAP_DATA =  EP_VALUE_RANGE
*).




  endmethod.


  method BATCH_APPEND.

    DATA:
      lt_param           TYPE tihttpnvp,
      ls_param           TYPE ihttpnvp,
      lv_get_response    type ref to IF_HTTP_RESPONSE,
      lv_target          type string VALUE  GC_ENDPOINT_URL,
      lv_req_json        type string,
      lv_response_string TYPE string.





    REPLACE '{spreadsheetId}' WITH IP_SPREADSHEET_ID INTO lv_target.
    CONCATENATE lv_target '/' IP_RANGE_STRING ':append'   INTO lv_target.



    ZCL_GOOGLE_HTTP_API=>DECODE_ABAP2JSON(
    importing
   EP_JSON      =  lv_req_json
    changing
    CP_ABAP_DATA = IP_VALUE_RANGE
    ).

    ZCL_GOOGLE_HTTP_API=>SEND_POST_REQUEST(
      exporting
        IP_TARGET          = lv_target
        IP_PARAM_KIND      = 'H'
        TP_PARAM           =      lt_param" HTTP Framework (iHTTP) Table Name/Value Pairs
        IP_JSON_REQUEST    = LV_REQ_JSON
      importing
        EP_RESPONSE_STRING =  lv_response_string
    ).




    ZCL_GOOGLE_HTTP_API=>ENCODE_JSON2ABAP(
      exporting
        IP_JSON      = lv_response_string
      changing
        CP_ABAP_DATA =  IP_VALUE_RANGE
    ).
  endmethod.


  method BATCH_CLEAR.
    DATA:

      lv_get_response    type ref to IF_HTTP_RESPONSE,
      lv_target          type string VALUE  GC_ENDPOINT_URL,
      lv_req_json        type string,
      lv_response_string TYPE string.





    REPLACE '{spreadsheetId}' WITH PA_SPREADSHEET_ID INTO lv_target.
    CONCATENATE lv_target ':batchClear'   INTO lv_target.



    ZCL_GOOGLE_HTTP_API=>DECODE_ABAP2JSON(
    importing
   EP_JSON      =  lv_req_json
    changing
    CP_ABAP_DATA = PA_RANGE
    ).

    ZCL_GOOGLE_HTTP_API=>SEND_POST_REQUEST(
      exporting
        IP_TARGET          = lv_target
        IP_PARAM_KIND      = 'H'
*     PT_PARAM           =     " HTTP Framework (iHTTP) Table Name/Value Pairs
        IP_JSON_REQUEST    = LV_REQ_JSON
      importing
        EP_RESPONSE_STRING =  lv_response_string
    ).




    ZCL_GOOGLE_HTTP_API=>ENCODE_JSON2ABAP(
      exporting
        IP_JSON      = lv_response_string
      changing
        CP_ABAP_DATA =  PA_VALUE_RANGE
    ).
  endmethod.


  method BATCH_GET.

DATA:
  lt_param           TYPE tihttpnvp,
  ls_param           TYPE ihttpnvp,
  lv_get_response    type ref to IF_HTTP_RESPONSE,
  lv_target          type string VALUE  GC_ENDPOINT_URL,
*'https://sheets.googleapis.com/v4/spreadsheets/$1/values/$2',
*    lv_target type string value 'https://sheets.googleapis.com/v4/spreadsheets/19rDV0SsDV0M600Y_znwHChsMxTkiKm7kaJeTNddaUFk/values/A1',

  lv_response_string TYPE string.

ls_param-name = 'ranges'.
ls_param-value = PA_RANGE.
APPEND ls_param TO lt_param.
CLEAR ls_param.



REPLACE '{spreadsheetId}' WITH PA_SPREADSHEET_ID INTO lv_target.
CONCATENATE lv_target ':batchGet'   INTO lv_target.

ZCL_GOOGLE_HTTP_API=>SEND_GET_REQUEST(
  exporting

    TARGET = lv_target
    PARAM_KIND =      'H'
    LT_PARAM   =     lt_param" HTTP Framework (iHTTP) Table Name/Value Pairs
      importing
   response_string = lv_response_string
   RESPONSE = lv_get_response
).




ZCL_GOOGLE_HTTP_API=>ENCODE_JSON2ABAP(
  exporting
    IP_JSON      = lv_response_string
  changing
    CP_ABAP_DATA =  PA_VALUE_RANGE
).



endmethod.


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
    CP_ABAP_DATA = IP_BATCH_REQ
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


  method GET.


DATA:
  lt_param           TYPE tihttpnvp,
  ls_param           TYPE ihttpnvp,
  lv_get_response    type ref to IF_HTTP_RESPONSE,
  lv_target          type string VALUE  GC_ENDPOINT_URL,
*'https://sheets.googleapis.com/v4/spreadsheets/$1/values/$2',
* lv_target type string value 'https://sheets.googleapis.com/v4/spreadsheets/19rDV0SsDV0M600Y_znwHChsMxTkiKm7kaJeTNddaUFk/values/A1',

  lv_response_string TYPE string.

*ls_param-name = 'ranges'.
*ls_param-value = PA_RANGE.
*APPEND ls_param TO lt_param.
*CLEAR ls_param.



REPLACE '{spreadsheetId}' WITH IP_SPREADSHEET_ID INTO lv_target.
CONCATENATE lv_target '/' IP_RANGE   INTO lv_target.

ZCL_GOOGLE_HTTP_API=>SEND_GET_REQUEST(
  exporting

    TARGET = lv_target
    PARAM_KIND =      'H'
    LT_PARAM   =     lt_param" HTTP Framework (iHTTP) Table Name/Value Pairs
      importing
   response_string = lv_response_string
   RESPONSE = lv_get_response
).




ZCL_GOOGLE_HTTP_API=>ENCODE_JSON2ABAP(
  exporting
    IP_JSON      = lv_response_string
  changing
    CP_ABAP_DATA =  EP_VALUE_RANGE
).




  endmethod.
ENDCLASS.
