CLASS zcl_gdrive_permission_api DEFINITION
  PUBLIC
  INHERITING FROM zcl_google_http_api
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS gc_endpoint_url TYPE string VALUE 'https://www.googleapis.com/drive/v3/files/fileId/permissions' ##NO_TEXT.

    CLASS-METHODS create
      IMPORTING
        VALUE(ip_spreadsheet_id) TYPE string
        VALUE(ip_permission)     TYPE zgdrive_permission_s .
    CLASS-METHODS delete .
    CLASS-METHODS get_all .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GDRIVE_PERMISSION_API IMPLEMENTATION.


  METHOD create.



    DATA: lt_param    TYPE tihttpnvp,
          ls_param    TYPE ihttpnvp,
          lv_response TYPE string,
          lv_target   TYPE string VALUE gc_endpoint_url,
          lv_json_req TYPE string.
*CREATE OBJECT GOBJECT TYPE ZCL_GOOGLE_HTTP_API.
*ls_param-name = 'mimeType'.
*ls_param-value = '1T8ApYlNVZdW7LlXLdeBIFqwn5Rf4fB0hfi63TU15jak'.
*
*
*
*APPEND ls_param TO lt_param.
*CLEAR ls_param.
*ls_param-name = 'mimeType'.
*ls_param-value = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'.
*APPEND ls_param TO lt_param.


    lv_json_req = '{"role":"writer","type":"user","emailAddress":"micael.teweldemedhin@techedgegroup.com"}'.


    zcl_google_http_api=>decode_abap2json(
      IMPORTING
        ep_json      =  lv_json_req
      CHANGING
        cp_abap_data = ip_permission
    ).

    REPLACE 'fileId'  WITH ip_spreadsheet_id INTO lv_target .


    zcl_google_http_api=>send_post_request(
      EXPORTING
        ip_target          = lv_target
        ip_param_kind      = 'H'
        tp_param           =  lt_param " HTTP Framework (iHTTP) Table Name/Value Pairs
        ip_json_request    = lv_json_req
      IMPORTING
        ep_response_string = lv_response
    ).

*SEND_POST_REQUEST(
*  exporting
*    PI_TARGET          = lv_target
*    PI_PARAM_KIND      =  'H'
*    PT_PARAM           =   lt_param  " HTTP Framework (iHTTP) Table Name/Value Pairs
*    PI_JSON_REQUEST    =  lv_json_req
*  importing
*    PE_RESPONSE_STRING =  LV_RESPONSE
*).
  ENDMETHOD.


  METHOD delete.


  ENDMETHOD.


  METHOD get_all.
  ENDMETHOD.
ENDCLASS.
