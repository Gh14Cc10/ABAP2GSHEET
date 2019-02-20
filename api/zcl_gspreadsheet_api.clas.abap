class ZCL_GSPREADSHEET_API definition
  public
  final
  create public .

public section.

  constants GC_ENDPOINT_URL type STRING value 'https://sheets.googleapis.com/v4/spreadsheets/{spreadsheetId}' ##NO_TEXT.
  data SPREADSHEET_ID type STRING .

  class-methods BATCH_UPDATE
    importing
      !IP_SPREADSHEET_ID type STRING
      value(IP_BATCH_REQS) type ZGSHEET_BATCH_UPDATE_REQS_S .
  class-methods CREATE_NEW_SPREADSHEET
    importing
      value(IP_SPREADSHEET_S) type ZGSPREADSHEET_S optional
    exporting
      !EP_SPREADSHEET type ref to ZCL_GSPREADSHEET .
  class-methods GET_SPREADSHEET
    importing
      !PA_SPREADSHEET_ID type STRING
      !IT_RANGE_TABLE type ZGSHEET_STRING_TT optional
    returning
      value(PA_SPREADSHEET) type ZGSPREADSHEET_S .
  class-methods GET_SPREADSHEET_FILTER .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GSPREADSHEET_API IMPLEMENTATION.


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
    cp_abap_data = ip_batch_reqs "#EC CI_VALPAR
    ).



    zcl_google_http_api=>send_post_request(
      EXPORTING
        ip_target          = lv_target
        ip_param_kind      = 'H'
*     PT_PARAM           =     " HTTP Framework (iHTTP) Table Name/Value Pairs
        ip_json_request    = lv_req_json
      IMPORTING
        ep_response_string =  lv_response_str "#EC CI_VALPAR
    ).






  ENDMETHOD. "#EC CI_VALPAR


  METHOD create_new_spreadsheet.
*input: file resource
*output: An instance of spreadsheet created
*
    DATA:
      lv_spreadsheet_obj TYPE REF TO  zcl_gspreadsheet,
      lt_param           TYPE tihttpnvp,
      ls_param           TYPE ihttpnvp,
*          GOBJECT            TYPE REF TO  ZCL_GOOGLE_HTTP_API,
      lv_target          TYPE string VALUE gc_endpoint_url,
      lv_json_req        TYPE string,
      lv_response_str    TYPE string.
    CREATE OBJECT: lv_spreadsheet_obj TYPE zcl_gspreadsheet.
*
    REPLACE '{spreadsheetId}' WITH '' INTO lv_target.


    zcl_google_http_api=>decode_abap2json(

      IMPORTING
        ep_json      = lv_json_req
      changing
        cp_abap_data = ip_spreadsheet_s

    ).

*    lv_json_req = '{"role":"writer","type":"user","emailAddress":"micael.teweldemedhin@techedgegroup.com"}'.
    zcl_google_http_api=>send_post_request(
      EXPORTING
        ip_target          =  lv_target
        ip_param_kind      = 'H'
        tp_param           =  lt_param   " HTTP Framework (iHTTP) Table Name/Value Pairs
        ip_json_request    = lv_json_req
      IMPORTING
        ep_response_string =   lv_response_str
    ).



    lv_spreadsheet_obj->set_json( p_gsheet_json =    lv_response_str   ).
*    ME->SET_ABAP_OBJ(P_GSHEET_ABAP =    LS_SPREADSHEET  )
    ep_spreadsheet =  lv_spreadsheet_obj. "#EC CI_VALPAR


  ENDMETHOD.


  METHOD get_spreadsheet.
*********
* Return a spreasdsheet values and data
*********



    DATA: gobject            TYPE REF TO zcl_google_http_api,
          lt_param           TYPE tihttpnvp,
          ls_param           TYPE ihttpnvp,
          lv_get_response    TYPE REF TO if_http_response,
          lv_target          TYPE string VALUE 'https://sheets.googleapis.com/v4/spreadsheets/&1',
          ls_range           TYPE string,
          lv_response_string TYPE string.
    CREATE OBJECT gobject TYPE zcl_google_http_api.

**Query parameters
    ls_param-name = 'includeGridData'.
    ls_param-value = 'true'.
    APPEND ls_param TO lt_param.



    LOOP AT it_range_table INTO ls_range.
      ls_param-name = 'ranges'.
      ls_param-value =  ls_range.
      APPEND ls_param TO lt_param.
      CLEAR ls_param.
    ENDLOOP.

*ls_param-name = 'ranges'.
*ls_param-value = 'B1'.
*APPEND ls_param TO lt_param.





    REPLACE '&1' WITH pa_spreadsheet_id INTO lv_target.


    gobject->send_get_request(
      EXPORTING

        target = lv_target
        param_kind =      'F'
        lt_param   =     lt_param" HTTP Framework (iHTTP) Table Name/Value Pairs
          IMPORTING
       response_string = lv_response_string
       response = lv_get_response
    ).






    zcl_google_http_api=>encode_json2abap(
      EXPORTING
        ip_json      = lv_response_string
      CHANGING
        cp_abap_data =  pa_spreadsheet
    ).




  ENDMETHOD.


  METHOD get_spreadsheet_filter.
  ENDMETHOD.
ENDCLASS.
