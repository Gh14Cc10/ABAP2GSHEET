CLASS zcl_gspreadsheet_values_api DEFINITION
  PUBLIC
  INHERITING FROM zcl_google_http_api
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS gc_endpoint_url TYPE string VALUE 'https://sheets.googleapis.com/v4/spreadsheets/{spreadsheetId}/values' ##NO_TEXT.

    CLASS-METHODS append
      IMPORTING
        VALUE(ip_spreadsheet_id) TYPE string
        VALUE(ip_range)          TYPE string
        VALUE(ip_value_range)    TYPE zgsheet_value_ranges_s
      EXPORTING
        VALUE(ep_value_updated)  TYPE string .
    CLASS-METHODS get
      IMPORTING
        VALUE(ip_spreadsheet_id) TYPE string
        VALUE(ip_range)          TYPE string
      RETURNING
        VALUE(ep_value_range)    TYPE zgsheet_value_ranges_s .
    CLASS-METHODS batch_update
      IMPORTING
        VALUE(ip_spreadsheet_id) TYPE string
        VALUE(ip_sheet_id)       TYPE string
        VALUE(ip_batch_req)      TYPE zgsheet_batch_update_val_req_s .
    CLASS-METHODS batch_get
      IMPORTING
        VALUE(pa_spreadsheet_id) TYPE string
        VALUE(pa_range)          TYPE string
      RETURNING
        VALUE(pa_value_range)    TYPE zgsheet_batch_value_get_resp_s .
    CLASS-METHODS batch_clear
      IMPORTING
        VALUE(pa_spreadsheet_id) TYPE string
        VALUE(pa_range)          TYPE zgsheet_batch_val_clear_req_s
      RETURNING
        VALUE(pa_value_range)    TYPE zgsheet_batch_val_clear_resp_s .
    CLASS-METHODS batch_append
      IMPORTING
        VALUE(ip_value_range)    TYPE zgsheet_value_ranges_s
        VALUE(ip_spreadsheet_id) TYPE string
        VALUE(ip_range_string)   TYPE string .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GSPREADSHEET_VALUES_API IMPLEMENTATION.


  METHOD append.





    DATA:
      lt_param           TYPE tihttpnvp,
      ls_param           TYPE ihttpnvp,
      lv_get_response    TYPE REF TO if_http_response,
      lv_target          TYPE string VALUE  gc_endpoint_url,
*'https://sheets.googleapis.com/v4/spreadsheets/$1/values/$2',
* lv_target type string value 'https://sheets.googleapis.com/v4/spreadsheets/19rDV0SsDV0M600Y_znwHChsMxTkiKm7kaJeTNddaUFk/values/A1',
      lv_req_json        TYPE string,

      lv_response_string TYPE string.

    ls_param-name = 'valueInputOption'.
    ls_param-value = 'USER_ENTERED'.
    APPEND ls_param TO lt_param.
    CLEAR ls_param.



    REPLACE '{spreadsheetId}' WITH ip_spreadsheet_id INTO lv_target.
    CONCATENATE lv_target '/' ip_range ':append'   INTO lv_target.

    zcl_google_http_api=>decode_abap2json(
    IMPORTING
   ep_json      =  lv_req_json
    CHANGING
    cp_abap_data = ip_value_range
    ).

    zcl_google_http_api=>send_post_request(
      EXPORTING
        ip_target          = lv_target
        ip_param_kind      = 'H'
        tp_param           =      lt_param" HTTP Framework (iHTTP) Table Name/Value Pairs
        ip_json_request    = lv_req_json
      IMPORTING
        ep_response_string =  lv_response_string
    ).



*ZCL_GOOGLE_HTTP_API=>ENCODE_JSON2ABAP(
*  exporting
*    IP_JSON      = lv_response_string
*  changing
*    CP_ABAP_DATA =  EP_VALUE_RANGE
*).




  ENDMETHOD.


  METHOD batch_append.

    DATA:
      lt_param           TYPE tihttpnvp,
      ls_param           TYPE ihttpnvp,
      lv_get_response    TYPE REF TO if_http_response,
      lv_target          TYPE string VALUE  gc_endpoint_url,
      lv_req_json        TYPE string,
      lv_response_string TYPE string.





    REPLACE '{spreadsheetId}' WITH ip_spreadsheet_id INTO lv_target.
    CONCATENATE lv_target '/' ip_range_string ':append'   INTO lv_target.



    zcl_google_http_api=>decode_abap2json(
    IMPORTING
   ep_json      =  lv_req_json
    CHANGING
    cp_abap_data = ip_value_range
    ).

    zcl_google_http_api=>send_post_request(
      EXPORTING
        ip_target          = lv_target
        ip_param_kind      = 'H'
        tp_param           =      lt_param" HTTP Framework (iHTTP) Table Name/Value Pairs
        ip_json_request    = lv_req_json
      IMPORTING
        ep_response_string =  lv_response_string
    ).




    zcl_google_http_api=>encode_json2abap(
      EXPORTING
        ip_json      = lv_response_string
      CHANGING
        cp_abap_data =  ip_value_range
    ).
  ENDMETHOD.


  METHOD batch_clear.
    DATA:

      lv_get_response    TYPE REF TO if_http_response,
      lv_target          TYPE string VALUE  gc_endpoint_url,
      lv_req_json        TYPE string,
      lv_response_string TYPE string.





    REPLACE '{spreadsheetId}' WITH pa_spreadsheet_id INTO lv_target.
    CONCATENATE lv_target ':batchClear'   INTO lv_target.



    zcl_google_http_api=>decode_abap2json(
    IMPORTING
   ep_json      =  lv_req_json
    CHANGING
    cp_abap_data = pa_range
    ).

    zcl_google_http_api=>send_post_request(
      EXPORTING
        ip_target          = lv_target
        ip_param_kind      = 'H'
*     PT_PARAM           =     " HTTP Framework (iHTTP) Table Name/Value Pairs
        ip_json_request    = lv_req_json
      IMPORTING
        ep_response_string =  lv_response_string
    ).




    zcl_google_http_api=>encode_json2abap(
      EXPORTING
        ip_json      = lv_response_string
      CHANGING
        cp_abap_data =  pa_value_range
    ).
  ENDMETHOD.


  METHOD batch_get.

    DATA:
      lt_param           TYPE tihttpnvp,
      ls_param           TYPE ihttpnvp,
      lv_get_response    TYPE REF TO if_http_response,
      lv_target          TYPE string VALUE  gc_endpoint_url,
*'https://sheets.googleapis.com/v4/spreadsheets/$1/values/$2',
*    lv_target type string value 'https://sheets.googleapis.com/v4/spreadsheets/19rDV0SsDV0M600Y_znwHChsMxTkiKm7kaJeTNddaUFk/values/A1',

      lv_response_string TYPE string.

    ls_param-name = 'ranges'.
    ls_param-value = pa_range.
    APPEND ls_param TO lt_param.
    CLEAR ls_param.



    REPLACE '{spreadsheetId}' WITH pa_spreadsheet_id INTO lv_target.
    CONCATENATE lv_target ':batchGet'   INTO lv_target.

    zcl_google_http_api=>send_get_request(
      EXPORTING

        target = lv_target
        param_kind =      'H'
        lt_param   =     lt_param" HTTP Framework (iHTTP) Table Name/Value Pairs
          IMPORTING
       response_string = lv_response_string
       response = lv_get_response
    ).




    zcl_google_http_api=>encode_json2abap(
      EXPORTING
        ip_json      = lv_response_string
      CHANGING
        cp_abap_data =  pa_value_range
    ).



  ENDMETHOD.


  METHOD batch_update.



    DATA: lv_target       TYPE string VALUE gc_endpoint_url,
          lv_response_str TYPE string,
          lv_req_json     TYPE string.
*    CREATE OBJECT lv_GHTTP TYPE ZCL_GOOGLE_HTTP_API.


    REPLACE '{spreadsheetId}' WITH ip_spreadsheet_id  INTO lv_target.
    CONCATENATE lv_target ':batchUpdate' INTO lv_target.


    zcl_google_http_api=>decode_abap2json(
    IMPORTING
   ep_json      =  lv_req_json
    CHANGING
    cp_abap_data = ip_batch_req
    ).



    zcl_google_http_api=>send_post_request(
      EXPORTING
        ip_target          = lv_target
        ip_param_kind      = 'H'
*     PT_PARAM           =     " HTTP Framework (iHTTP) Table Name/Value Pairs
        ip_json_request    = lv_req_json
      IMPORTING
        ep_response_string =  lv_response_str
    ).






  ENDMETHOD.


  METHOD get.


    DATA:
      lt_param           TYPE tihttpnvp,
      ls_param           TYPE ihttpnvp,
      lv_get_response    TYPE REF TO if_http_response,
      lv_target          TYPE string VALUE  gc_endpoint_url,
*'https://sheets.googleapis.com/v4/spreadsheets/$1/values/$2',
* lv_target type string value 'https://sheets.googleapis.com/v4/spreadsheets/19rDV0SsDV0M600Y_znwHChsMxTkiKm7kaJeTNddaUFk/values/A1',

      lv_response_string TYPE string.

*ls_param-name = 'ranges'.
*ls_param-value = PA_RANGE.
*APPEND ls_param TO lt_param.
*CLEAR ls_param.



    REPLACE '{spreadsheetId}' WITH ip_spreadsheet_id INTO lv_target.
    CONCATENATE lv_target '/' ip_range   INTO lv_target.

    zcl_google_http_api=>send_get_request(
      EXPORTING

        target = lv_target
        param_kind =      'H'
        lt_param   =     lt_param" HTTP Framework (iHTTP) Table Name/Value Pairs
          IMPORTING
       response_string = lv_response_string
       response = lv_get_response
    ).




    zcl_google_http_api=>encode_json2abap(
      EXPORTING
        ip_json      = lv_response_string
      CHANGING
        cp_abap_data =  ep_value_range
    ).




  ENDMETHOD.
ENDCLASS.
