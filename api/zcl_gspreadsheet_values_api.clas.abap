class ZCL_GSPREADSHEET_VALUES_API definition
  public
  inheriting from ZCL_GOOGLE_HTTP_API
  final
  create public .

public section.

  constants GC_ENDPOINT_URL type STRING value 'https://sheets.googleapis.com/v4/spreadsheets/{spreadsheetId}/values' ##NO_TEXT.

  class-methods APPEND
    importing
      !IP_SPREADSHEET_ID type STRING
      !IP_RANGE type STRING
      value(IP_VALUE_RANGE) type ZGSHEET_VALUE_RANGES_S .
  class-methods GET
    importing
      !IP_SPREADSHEET_ID type STRING
      !IP_RANGE type STRING
    returning
      value(EP_VALUE_RANGE) type ZGSHEET_VALUE_RANGES_S .
  class-methods BATCH_UPDATE
    importing
      !IP_SPREADSHEET_ID type STRING
      !IP_SHEET_ID type STRING
      value(IP_BATCH_REQ) type ZGSHEET_BATCH_UPDATE_VAL_REQ_S .
  class-methods BATCH_GET
    importing
      !PA_SPREADSHEET_ID type STRING
      !PA_RANGE type STRING
    returning
      value(PA_VALUE_RANGE) type ZGSHEET_BATCH_VALUE_GET_RESP_S .
  class-methods BATCH_CLEAR
    importing
      !PA_SPREADSHEET_ID type STRING
      value(PA_RANGE) type ZGSHEET_BATCH_VAL_CLEAR_REQ_S
    returning
      value(PA_VALUE_RANGE) type ZGSHEET_BATCH_VAL_CLEAR_RESP_S .
  class-methods BATCH_APPEND
    importing
      value(IP_VALUE_RANGE) type ZGSHEET_VALUE_RANGES_S
      !IP_SPREADSHEET_ID type STRING
      !IP_RANGE_STRING type STRING .
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




  ENDMETHOD.  "#EC CI_VALPAR


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

  ENDMETHOD.  "#EC CI_VALPAR


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

  ENDMETHOD.  "#EC CI_VALPAR


  METHOD batch_get.

    DATA:
      lt_param           TYPE tihttpnvp,
      ls_param           TYPE ihttpnvp,
      lo_get_response    TYPE REF TO if_http_response,
      lv_target          TYPE string VALUE  gc_endpoint_url,
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
       response = lo_get_response
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
        ip_json_request    = lv_req_json
      IMPORTING
        ep_response_string =  lv_response_str
    ).

  ENDMETHOD.  "#EC CI_VALPAR


  METHOD get.

    DATA:
      lt_param           TYPE tihttpnvp,
      ls_param           TYPE ihttpnvp,
      lo_get_response    TYPE REF TO if_http_response,
      lv_target          TYPE string VALUE  gc_endpoint_url,
      lv_response_string TYPE string.

    REPLACE '{spreadsheetId}' WITH ip_spreadsheet_id INTO lv_target.
    CONCATENATE lv_target '/' ip_range   INTO lv_target.

    zcl_google_http_api=>send_get_request(
      EXPORTING
        target = lv_target
        param_kind =      'H'
        lt_param   =     lt_param" HTTP Framework (iHTTP) Table Name/Value Pairs
          IMPORTING
       response_string = lv_response_string
       response = lo_get_response
    ).

    zcl_google_http_api=>encode_json2abap(
      EXPORTING
        ip_json      = lv_response_string
      CHANGING
        cp_abap_data =  ep_value_range
    ).

  ENDMETHOD.
ENDCLASS.
