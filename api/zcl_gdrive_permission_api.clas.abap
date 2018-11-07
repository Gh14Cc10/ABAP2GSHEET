class ZCL_GDRIVE_PERMISSION_API definition
  public
  inheriting from ZCL_GOOGLE_HTTP_API
  final
  create public .

public section.

  constants GC_ENDPOINT_URL type STRING value 'https://www.googleapis.com/drive/v3/files/fileId/permissions' ##NO_TEXT.

  class-methods CREATE
    importing
      value(IP_SPREADSHEET_ID) type STRING
      value(IP_PERMISSION) type ZGDRIVE_PERMISSION_S .
  class-methods DELETE .
  class-methods GET_ALL .
protected section.
private section.
ENDCLASS.



CLASS ZCL_GDRIVE_PERMISSION_API IMPLEMENTATION.


method CREATE.



DATA: lt_param        TYPE tihttpnvp,
      ls_param        TYPE ihttpnvp,
      lv_response type string,
      lv_target        type string value GC_ENDPOINT_URL,
      lv_json_req     TYPE string.
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


ZCL_GOOGLE_HTTP_API=>DECODE_ABAP2JSON(
  importing
    EP_JSON      =  lv_json_req
  changing
    CP_ABAP_DATA = IP_PERMISSION
).

REPLACE 'fileId'  WITH IP_SPREADSHEET_ID INTO lv_target .


ZCL_GOOGLE_HTTP_API=>SEND_POST_REQUEST(
  exporting
    IP_TARGET          = lv_target
    IP_PARAM_KIND      = 'H'
    TP_PARAM           =  lt_param " HTTP Framework (iHTTP) Table Name/Value Pairs
    IP_JSON_REQUEST    = lv_json_req
  importing
    EP_RESPONSE_STRING = LV_RESPONSE
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
  endmethod.


  method DELETE.


  endmethod.


  method GET_ALL.
  endmethod.
ENDCLASS.
