*&---------------------------------------------------------------------*
*& Report ZGOOGLE_RUN_POST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZGOOGLE_SHARE_FRAMEWORK.

DATA: GOBJECT            TYPE REF TO  ZCL_GOOGLE_HTTP_API,
      lt_param           TYPE tihttpnvp,
      ls_param           TYPE ihttpnvp,
      lv_get_response    type ref to IF_HTTP_RESPONSE,
      lv_json_req TYPE string.
CREATE OBJECT GOBJECT TYPE ZCL_GOOGLE_HTTP_API.
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

GOBJECT->SEND_POST_REQUEST(
  exporting

    IP_TARGET     = 'https://www.googleapis.com/drive/v3/files/1T8ApYlNVZdW7LlXLdeBIFqwn5Rf4fB0hfi63TU15jak/permissions'
    IP_PARAM_KIND = 'H'
*    ip_profile = 'Z_GOOGLE_CL_PROFILE'
    tP_PARAM   =   lt_param    " HTTP Framework (iHTTP) Table Name/Value Pairs
    IP_JSON_REQUEST = lv_json_req
*  importing
*    DATA       =
).
