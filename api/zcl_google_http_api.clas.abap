class ZCL_GOOGLE_HTTP_API definition
  public
  create public .

public section.

  class-data GC_SPREADSHEET_URL_PREFIX type STRING value 'https://docs.google.com/spreadsheets/d/' ##NO_TEXT.

  class-methods GET_RESPONSE_STRING
    importing
      !RESPONSE type ref to IF_HTTP_RESPONSE
    returning
      value(P_RESPONSE_DATA) type STRING .
  class-methods EXTRACT_SPREADSHEET_ID
    importing
      !IP_URL type STRING
    returning
      value(EP_IDENTIFIER) type STRING .
  class-methods SEND_DELETE_REQUEST
    importing
      !TARGET type STRING
      !METHOD type STRING
      !PARAM_KIND type STRING
      !LT_PARAM type TIHTTPNVP
    exporting
      !RESPONSE_STRING type STRING
      !RESPONSE type ref to IF_HTTP_RESPONSE .
  class-methods DISPLAY_RESPONSE
    importing
      value(RESPONSE) type ref to IF_HTTP_RESPONSE
    returning
      value(P_RESPONSE_DATA) type STRING .
  class-methods SEND_PATCH_REQUEST
    importing
      value(IP_TARGET) type STRING
      value(IP_PARAM_KIND) type STRING
      value(TP_PARAM) type TIHTTPNVP optional
      value(IP_JSON_REQUEST) type STRING
      value(IT_MULTIPARTS) type ZGSHEET_POST_MULTIPART_TT optional
    exporting
      value(EP_RESPONSE_STRING) type STRING .
  class-methods SEND_POST_REQUEST
    importing
      value(IP_TARGET) type STRING
      value(IP_PARAM_KIND) type STRING
      value(TP_PARAM) type TIHTTPNVP optional
      value(IP_JSON_REQUEST) type STRING
      value(IT_MULTIPARTS) type ZGSHEET_POST_MULTIPART_TT optional
    exporting
      value(EP_RESPONSE_STRING) type STRING .
  class-methods SEND_GET_REQUEST
    importing
      value(TARGET) type STRING
      value(METHOD) type STRING optional
      value(PARAM_KIND) type STRING
      value(LT_PARAM) type TIHTTPNVP
    exporting
      value(RESPONSE_STRING) type STRING
      value(RESPONSE) type ref to IF_HTTP_RESPONSE .
  class-methods EXTRACT_RESPONSE
    exporting
      value(RESPONSE) type ref to IF_HTTP_RESPONSE .
  class-methods ENCODE_JSON2ABAP
    importing
      value(IP_JSON) type STRING
    changing
      value(CP_ABAP_DATA) type ANY .
  class-methods DECODE_ABAP2JSON
    exporting
      value(EP_JSON) type STRING
    changing
      value(CP_ABAP_DATA) type ANY .
protected section.
private section.
ENDCLASS.



CLASS ZCL_GOOGLE_HTTP_API IMPLEMENTATION.


  method DECODE_ABAP2JSON.



ep_json = /ui2/cl_json=>serialize(
   data = CP_ABAP_DATA
   compress = abap_true
   pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).


  endmethod.


  method DISPLAY_RESPONSE.
    DATA:lt_fields       TYPE tihttpnvp,
         l_status_code   TYPE i.

    FIELD-SYMBOLS: <ls_field> LIKE LINE OF lt_fields.


    CALL METHOD response->get_status
      IMPORTING
        code = l_status_code.
    WRITE / |{ l_status_code }|.

    WRITE /.
    IF l_status_code = 200.
      CALL METHOD response->get_cdata
        RECEIVING
          data = p_response_data.




      DATA(l_content_type) = response->get_content_type( ).
      IF l_content_type CP `text/html*`.
*     cl_demo_output=>display_html( html = p_response_data ).
      ELSEIF l_content_type CP `text/xml*`.
        cl_demo_output=>display_xml( xml = p_response_data ).
      ELSEIF l_content_type CP `application/json*`.
        cl_demo_output=>display_json( json = p_response_data ).
      ENDIF.
    ELSE.
      CALL METHOD response->get_header_fields
        CHANGING
          fields = lt_fields.

      LOOP AT lt_fields ASSIGNING <ls_field>.
        WRITE: / <ls_field>-name, 25 <ls_field>-value.
      ENDLOOP.

    ENDIF.


  endmethod.


  method ENCODE_JSON2ABAP.


    /ui2/cl_json=>deserialize(

    EXPORTING json = IP_JSON


    pretty_name = /ui2/cl_json=>pretty_mode-camel_case

    CHANGING
        data = CP_ABAP_DATA

    ).

  endmethod.


  method EXTRACT_RESPONSE.
*DATA: lv_json_STRING type STRING,
*      lv_spreadhsheetId type string,
*      lv_responseData type  ZJSON_KEY_VALUE_T,
*      lv_xstring_line type xstring.
*
*   CALL METHOD response->GET_DATA
*     exporting
*       OFFSET             = 0    " Offset into binary data
*       LENGTH             = -1    " Length of binary data
*       VIRUS_SCAN_PROFILE = '/SIHTTP/HTTP_UPLOAD'    " Virus Scan Profile
*       VSCAN_SCAN_ALWAYS  = IF_HTTP_ENTITY=>CO_CONTENT_CHECK_PROFILE    " Virus Scan Always (A = Always, N = Never, space = Internal)
*     receiving
*       DATA               =  lv_xstring_line.   " Binary data
*
*
* CALL FUNCTION 'HR_KR_XSTRING_TO_STRING'
* EXPORTING
* in_xstring =  lv_xstring_line
* IMPORTING
* out_string = lv_json_string.
*
*
*DATA: JSON_DOCUMENT TYPE REF TO  ZCL_JSON_DOCUMENT,
*      lv_results type string_table.
*
*
*   ZCL_JSON_DOCUMENT=>CREATE_WITH_JSON(
*     exporting
*       JSON          = lv_json_STRING
**       DATE_FORMAT   =
*     receiving
*       JSON_DOCUMENT = json_document
*   ).
* json_document->set_json( lv_json_STRING ).
*
*json_document->DUMPS(
*  exporting
*    JSON           = lv_json_STRING
**    CURRENT_INTEND =
*  importing
*    RESULT         = lv_results
*).
* lv_spreadhsheetId  = json_document->GET_VALUE( KEY =  'SreadhSheetID').


  endmethod.


  method EXTRACT_SPREADSHEET_ID.

     ep_identifier = ip_url.
    REPLACE  GC_SPREADSHEET_URL_PREFIX IN ep_identifier WITH ''.
    REPLACE all OCCURRENCES OF REGEX '/.*' IN  ep_identifier WITH ''.




  endmethod.


  METHOD get_response_string.

    DATA:lt_fields     TYPE tihttpnvp,
         l_status_code TYPE i.

    FIELD-SYMBOLS: <ls_field> LIKE LINE OF lt_fields.


    CALL METHOD response->get_status
      IMPORTING
        code = l_status_code.

    IF l_status_code = 200.
      CALL METHOD response->get_cdata
        RECEIVING
          data = p_response_data.
      ENDIF.
    ENDMETHOD.


  method SEND_DELETE_REQUEST.



    DATA:
      ls_param   TYPE ihttpnvp,
       length  TYPE i.

DATA: lo_http_client  TYPE REF TO if_http_client,
     lo_oa2c_client  TYPE REF TO if_oauth2_client,
     l_status_code   TYPE i,
     l_response_data TYPE string,
     lt_fields       TYPE tihttpnvp,
     lx_oa2c         TYPE REF TO cx_oa2c,
     lt_binary_data                  TYPE  solix_tab,
     ls_binary_data like LINE OF lt_binary_data.


FIELD-SYMBOLS: <ls_field> LIKE LINE OF lt_fields.

**********************************************************************
* Create HTTP client
**********************************************************************
CALL METHOD cl_http_client=>create_by_url
 EXPORTING
   url                = target
   ssl_id             = 'ANONYM'
 IMPORTING
   client             = lo_http_client
 EXCEPTIONS
   argument_not_found = 1
   plugin_not_active  = 2
   internal_error     = 3
   OTHERS             = 4.
IF sy-subrc <> 0.
 MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.

* Turn off logon popup. Detect authentication errors.
lo_http_client->propertytype_logon_popup = 0.

CALL METHOD lo_http_client->request->set_method
 EXPORTING
   method = 'DELETE'.


LOOP AT lt_param INTO ls_param.

 CALL METHOD lo_http_client->request->set_form_field
   EXPORTING
     name  = ls_param-name
     value = ls_param-value.
ENDLOOP.



**********************************************************************
* Set OAuth 2.0 Token
**********************************************************************
TRY.

   CALL METHOD cl_oauth2_client=>create
     EXPORTING
       i_profile        = ZCL_GOOGLE_CONSTANTS=>GOOGLE_PROFILE
     RECEIVING
       ro_oauth2_client = lo_oa2c_client.

 CATCH cx_oa2c INTO lx_oa2c.
   WRITE: `Error calling CREATE.`.
   WRITE: / lx_oa2c->get_text( ).
   RETURN.
ENDTRY.

TRY.

   CALL METHOD lo_oa2c_client->set_token
     EXPORTING
       io_http_client = lo_http_client
       i_param_kind   = param_kind.

 CATCH cx_oa2c INTO lx_oa2c.
   TRY.
       CALL METHOD lo_oa2c_client->execute_refresh_flow.
     CATCH cx_oa2c INTO lx_oa2c.
       WRITE: `Error calling EXECUTE_REFRESH_FLOW.`.
       WRITE: / lx_oa2c->get_text( ).
       RETURN.
   ENDTRY.
   TRY.
       CALL METHOD lo_oa2c_client->set_token
         EXPORTING
           io_http_client = lo_http_client
           i_param_kind   = param_kind.
     CATCH cx_oa2c INTO lx_oa2c.
       WRITE: `Error calling SET_TOKEN.`.
       WRITE: / lx_oa2c->get_text( ).
       RETURN.
   ENDTRY.
ENDTRY.



**********************************************************************
* Send / Receive Request
**********************************************************************
CLEAR lt_fields.
CALL METHOD lo_http_client->request->get_header_fields
     CHANGING
       fields = lt_fields.
CLEAR lt_fields.
 CALL METHOD lo_http_client->send
   EXCEPTIONS
     http_communication_failure = 1
     http_invalid_state         = 2
     http_processing_failed     = 3
     http_invalid_timeout       = 4
     OTHERS                     = 5.
 IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
 ENDIF.

 CALL METHOD lo_http_client->receive
   EXCEPTIONS
     http_communication_failure = 1
     http_invalid_state         = 2
     http_processing_failed     = 3
     OTHERS                     = 4.
 IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
 ENDIF.

RESPONSE = lo_http_client->response.


**********************************************************************
* Display result
**********************************************************************
RESPONSE_STRING = DISPLAY_RESPONSE( RESPONSE =  lo_http_client->response ).


**********************************************************************
* Close
**********************************************************************
CALL METHOD lo_http_client->close
 EXCEPTIONS
   http_invalid_state = 1
   OTHERS             = 2.
IF sy-subrc <> 0.
 MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.

  endmethod.


method SEND_GET_REQUEST.

*&---------------------------------------------------------------------*
*& Report ZGOOGLE_DOWNLOAD_XLS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


DATA:
      ls_param   TYPE ihttpnvp,
       length  TYPE i.

DATA: lo_http_client  TYPE REF TO if_http_client,
     lo_oa2c_client  TYPE REF TO if_oauth2_client,
     l_status_code   TYPE i,
     l_response_data TYPE string,
     lt_fields       TYPE tihttpnvp,
     lx_oa2c         TYPE REF TO cx_oa2c,
     lt_binary_data                  TYPE  solix_tab,
     ls_binary_data like LINE OF lt_binary_data.


FIELD-SYMBOLS: <ls_field> LIKE LINE OF lt_fields.

**********************************************************************
* Create HTTP client
**********************************************************************
CALL METHOD cl_http_client=>create_by_url
 EXPORTING
   url                = target
   ssl_id             = 'ANONYM'
 IMPORTING
   client             = lo_http_client
 EXCEPTIONS
   argument_not_found = 1
   plugin_not_active  = 2
   internal_error     = 3
   OTHERS             = 4.
IF sy-subrc <> 0.
 MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.

* Turn off logon popup. Detect authentication errors.
lo_http_client->propertytype_logon_popup = 0.

CALL METHOD lo_http_client->request->set_method
 EXPORTING
   method = 'GET'.


LOOP AT lt_param INTO ls_param.

 CALL METHOD lo_http_client->request->set_form_field
   EXPORTING
     name  = ls_param-name
     value = ls_param-value.
ENDLOOP.



**********************************************************************
* Set OAuth 2.0 Token
**********************************************************************
TRY.

   CALL METHOD cl_oauth2_client=>create
     EXPORTING
       i_profile        = ZCL_GOOGLE_CONSTANTS=>GOOGLE_PROFILE
     RECEIVING
       ro_oauth2_client = lo_oa2c_client.

 CATCH cx_oa2c INTO lx_oa2c.
   WRITE: `Error calling CREATE.`.
   WRITE: / lx_oa2c->get_text( ).
   RETURN.
ENDTRY.

TRY.

   CALL METHOD lo_oa2c_client->set_token
     EXPORTING
       io_http_client = lo_http_client
       i_param_kind   = param_kind.

 CATCH cx_oa2c INTO lx_oa2c.
   TRY.
       CALL METHOD lo_oa2c_client->execute_refresh_flow.
     CATCH cx_oa2c INTO lx_oa2c.
       WRITE: `Error calling EXECUTE_REFRESH_FLOW.`.
       WRITE: / lx_oa2c->get_text( ).
       RETURN.
   ENDTRY.
   TRY.
       CALL METHOD lo_oa2c_client->set_token
         EXPORTING
           io_http_client = lo_http_client
           i_param_kind   = param_kind.
     CATCH cx_oa2c INTO lx_oa2c.
       WRITE: `Error calling SET_TOKEN.`.
       WRITE: / lx_oa2c->get_text( ).
       RETURN.
   ENDTRY.
ENDTRY.



**********************************************************************
* Send / Receive Request
**********************************************************************
CLEAR lt_fields.
CALL METHOD lo_http_client->request->get_header_fields
     CHANGING
       fields = lt_fields.
CLEAR lt_fields.
 CALL METHOD lo_http_client->send
   EXCEPTIONS
     http_communication_failure = 1
     http_invalid_state         = 2
     http_processing_failed     = 3
     http_invalid_timeout       = 4
     OTHERS                     = 5.
 IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
 ENDIF.

 CALL METHOD lo_http_client->receive
   EXCEPTIONS
     http_communication_failure = 1
     http_invalid_state         = 2
     http_processing_failed     = 3
     OTHERS                     = 4.
 IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
 ENDIF.

RESPONSE = lo_http_client->response.


**********************************************************************
* Display result
**********************************************************************
*RESPONSE_STRING = DISPLAY_RESPONSE( RESPONSE =  lo_http_client->response ).

**********************************************************************
* Response result
**********************************************************************
RESPONSE_STRING = get_response_string( RESPONSE =  lo_http_client->response ).
**********************************************************************
* Close
**********************************************************************
CALL METHOD lo_http_client->close
 EXCEPTIONS
   http_invalid_state = 1
   OTHERS             = 2.
IF sy-subrc <> 0.
 MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.
  endmethod.


method SEND_PATCH_REQUEST.
**&---------------------------------------------------------------------*
**& Method SEND_POST_REQUEST
**&---------------------------------------------------------------------*
**&
**&---------------------------------------------------------------------*


  DATA:

    ls_param TYPE ihttpnvp,
    length   TYPE i,
    out      TYPE xstring.
  CONSTANTS method TYPE string VALUE 'PATCH'.

  DATA: lo_http_client  TYPE REF TO if_http_client,

        lo_oa2c_client  TYPE REF TO if_oauth2_client,
        l_status_code   TYPE i,
        l_response_data TYPE string,
        lt_fields       TYPE tihttpnvp,
        lx_oa2c         TYPE REF TO cx_oa2c.

  DATA lt_binary_data                  TYPE  solix_tab.




  FIELD-SYMBOLS: <ls_field> LIKE LINE OF lt_fields.


**********************************************************************
* Create HTTP client
**********************************************************************
  CALL METHOD cl_http_client=>create_by_url
    EXPORTING
      url                = ip_target
      ssl_id             = 'ANONYM'
    IMPORTING
      client             = lo_http_client
    EXCEPTIONS
      argument_not_found = 1
      plugin_not_active  = 2
      internal_error     = 3
      OTHERS             = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.





* Turn off logon popup. Detect authentication errors.
  lo_http_client->propertytype_logon_popup = 0.

  CALL METHOD lo_http_client->request->set_method
    EXPORTING
      method = method.




  CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
    EXPORTING
      TEXT   = ip_json_request
    IMPORTING
      BUFFER = out.

******************
*Multipart request
  DATA: ls_header_field type IHTTPNVP,
        ls_multipart    type ZGSHEET_POST_MULTIPART_S.
  DATA lv_part TYPE ref to if_http_entity.

  IF IT_MULTIPARTS IS NOT INITIAL.

    lo_http_client->request->SET_CONTENT_TYPE( CONTENT_TYPE = 'multipart/form-data' ).
    LOOP AT IT_MULTIPARTS INTO ls_multipart.
      lv_part = lo_http_client->request->if_http_entity~ADD_MULTIPART(
*    SUPPRESS_CONTENT_LENGTH = ABAP_FALSE
  ).

      lv_part->SET_CONTENT_TYPE( CONTENT_TYPE = ls_multipart-CONTENT_TYPE ).
      LOOP AT ls_multipart-HEADER_FIELDS INTO ls_header_field.
        call METHOD lv_part->SET_HEADER_FIELD
          exporting
            NAME  = ls_header_field-NAME " Name of the header field
            VALUE = ls_header_field-value. " HTTP header field value
        IF ls_multipart-CDATA IS NOT INITIAL.
          lv_part->set_CDATA( ls_multipart-CDATA ).
        ENDIF.

      ENDLOOP.


      IF ls_multipart-DATA is not INITIAL.

        lv_part->SET_DATA(
      exporting
        DATA               =   ls_multipart-DATA"data    " Binary data
*    OFFSET             = 0    " Offset into binary data
*    LENGTH             = lv_len   " Length of binary data
*    VSCAN_SCAN_ALWAYS  = IF_HTTP_ENTITY=>CO_CONTENT_CHECK_PROFILE    " Virus Scan Always (A = Always, N = Never, space = Internal)
*    VIRUS_SCAN_PROFILE = '/SIHTTP/HTTP_DOWNLOAD'    " Virus Scan Profile

    ).

      ENDIF.

      CLEAR lv_part.
    ENDLOOP.

  ELSE.
    lo_http_client->request->SET_CONTENT_TYPE( CONTENT_TYPE = 'application/json' ).




  ENDIF.

************


*body
  lo_http_client->request->SET_DATA(
    exporting
      DATA               = out  " Binary data
*    OFFSET             = 0    " Offset into binary data
*    LENGTH             = lv_len   " Length of binary data
*    VSCAN_SCAN_ALWAYS  = IF_HTTP_ENTITY=>CO_CONTENT_CHECK_PROFILE    " Virus Scan Always (A = Always, N = Never, space = Internal)
*    VIRUS_SCAN_PROFILE = '/SIHTTP/HTTP_DOWNLOAD'    " Virus Scan Profile
  ).

* Query parameters

  LOOP AT tp_param INTO ls_param.
    CALL METHOD lo_http_client->request->set_form_field
      EXPORTING
        name  = ls_param-name
        value = ls_param-value.
  ENDLOOP.



**********************************************************************
* Set OAuth 2.0 Token
**********************************************************************
  TRY.

      CALL METHOD cl_oauth2_client=>create
        EXPORTING
          i_profile        = ZCL_GOOGLE_CONSTANTS=>GOOGLE_PROFILE
        RECEIVING
          ro_oauth2_client = lo_oa2c_client.

    CATCH cx_oa2c INTO lx_oa2c.
      WRITE: `Error calling CREATE.`.
      WRITE: / lx_oa2c->get_text( ).
      RETURN.
  ENDTRY.

  TRY.

      CALL METHOD lo_oa2c_client->set_token
        EXPORTING
          io_http_client = lo_http_client
          i_param_kind   = ip_param_kind.

    CATCH cx_oa2c INTO lx_oa2c.
      TRY.
          CALL METHOD lo_oa2c_client->execute_refresh_flow.
        CATCH cx_oa2c INTO lx_oa2c.
          WRITE: `Error calling EXECUTE_REFRESH_FLOW.`.
          WRITE: / lx_oa2c->get_text( ).
          RETURN.
      ENDTRY.
      TRY.
          CALL METHOD lo_oa2c_client->set_token
            EXPORTING
              io_http_client = lo_http_client
              i_param_kind   = ip_param_kind.
        CATCH cx_oa2c INTO lx_oa2c.
          WRITE: `Error calling SET_TOKEN.`.
          WRITE: / lx_oa2c->get_text( ).
          RETURN.
      ENDTRY.
  ENDTRY.



**********************************************************************
* Send / Receive Request
**********************************************************************
  CLEAR lt_fields.
  CALL METHOD lo_http_client->request->get_header_fields
    CHANGING
      fields = lt_fields.
  CLEAR lt_fields.
  CALL METHOD lo_http_client->send
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3
      http_invalid_timeout       = 4
      OTHERS                     = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CALL METHOD lo_http_client->receive
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3
      OTHERS                     = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.



**********************************************************************
* Display result
**********************************************************************
  CALL METHOD lo_http_client->response->get_status
    IMPORTING
      code = l_status_code.
  WRITE / |{ l_status_code }|.

  WRITE /.

  IF l_status_code = 200.
    CALL METHOD lo_http_client->response->get_cdata
      RECEIVING
        data = l_response_data.

    EP_RESPONSE_STRING = l_response_data.

    CALL METHOD lo_http_client->response->GET_DATA
*     exporting
*       OFFSET             = 0    " Offset into binary data
*       LENGTH             = -1    " Length of binary data
*       VIRUS_SCAN_PROFILE = '/SIHTTP/HTTP_UPLOAD'    " Virus Scan Profile
*       VSCAN_SCAN_ALWAYS  = IF_HTTP_ENTITY=>CO_CONTENT_CHECK_PROFILE    " Virus Scan Always (A = Always, N = Never, space = Internal)
      receiving
        DATA = out.   " Binary data







    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        BUFFER        = out
*       APPEND_TO_TABLE       = ' '
      IMPORTING
        OUTPUT_LENGTH = length
      TABLES
        BINARY_TAB    = lt_binary_data.



    DATA(l_content_type) = lo_http_client->response->get_content_type( ).
    IF l_content_type CP `text/html*`.
*     cl_demo_output=>display_html( html = l_response_data ).
    ELSEIF l_content_type CP `text/xml*`.
      cl_demo_output=>display_xml( xml = l_response_data ).
    ELSEIF l_content_type CP `application/json*`.
      cl_demo_output=>display_json( json = l_response_data ).
    ENDIF.
  ELSE.
    CALL METHOD lo_http_client->response->get_header_fields
      CHANGING
        fields = lt_fields.

    LOOP AT lt_fields ASSIGNING <ls_field>.
      WRITE: / <ls_field>-name, 25 <ls_field>-value.
    ENDLOOP.
    WRITE 's'.
    WRITE IP_JSON_REQUEST.
  ENDIF.



**********************************************************************
* Close
**********************************************************************
  CALL METHOD lo_http_client->close
    EXCEPTIONS
      http_invalid_state = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
endmethod.


method SEND_POST_REQUEST.
**&---------------------------------------------------------------------*
**& Method SEND_POST_REQUEST
**&---------------------------------------------------------------------*
**&
**&---------------------------------------------------------------------*


  DATA:

    ls_param TYPE ihttpnvp,
    length   TYPE i,
    out      TYPE xstring.
  CONSTANTS method TYPE string VALUE 'POST'.

  DATA: lo_http_client  TYPE REF TO if_http_client,

        lo_oa2c_client  TYPE REF TO if_oauth2_client,
        l_status_code   TYPE i,
        l_response_data TYPE string,
        lt_fields       TYPE tihttpnvp,
        lx_oa2c         TYPE REF TO cx_oa2c.

  DATA lt_binary_data                  TYPE  solix_tab.




  FIELD-SYMBOLS: <ls_field> LIKE LINE OF lt_fields.


**********************************************************************
* Create HTTP client
**********************************************************************
  CALL METHOD cl_http_client=>create_by_url
    EXPORTING
      url                = ip_target
      ssl_id             = 'ANONYM'
    IMPORTING
      client             = lo_http_client
    EXCEPTIONS
      argument_not_found = 1
      plugin_not_active  = 2
      internal_error     = 3
      OTHERS             = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.





* Turn off logon popup. Detect authentication errors.
  lo_http_client->propertytype_logon_popup = 0.

  CALL METHOD lo_http_client->request->set_method
    EXPORTING
      method = method.




  CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
    EXPORTING
      TEXT   = ip_json_request
    IMPORTING
      BUFFER = out.

******************
*Multipart request
  DATA: ls_header_field type IHTTPNVP,
        ls_multipart    type ZGSHEET_POST_MULTIPART_S.
  DATA lv_part TYPE ref to if_http_entity.

  IF IT_MULTIPARTS IS NOT INITIAL.

    lo_http_client->request->SET_CONTENT_TYPE( CONTENT_TYPE = 'multipart/form-data' ).
    LOOP AT IT_MULTIPARTS INTO ls_multipart.
      lv_part = lo_http_client->request->if_http_entity~ADD_MULTIPART(
*    SUPPRESS_CONTENT_LENGTH = ABAP_FALSE
  ).

      lv_part->SET_CONTENT_TYPE( CONTENT_TYPE = ls_multipart-CONTENT_TYPE ).
      LOOP AT ls_multipart-HEADER_FIELDS INTO ls_header_field.
        call METHOD lv_part->SET_HEADER_FIELD
          exporting
            NAME  = ls_header_field-NAME " Name of the header field
            VALUE = ls_header_field-value. " HTTP header field value
        IF ls_multipart-CDATA IS NOT INITIAL.
          lv_part->set_CDATA( ls_multipart-CDATA ).
        ENDIF.

      ENDLOOP.


      IF ls_multipart-DATA is not INITIAL.

        lv_part->SET_DATA(
      exporting
        DATA               =   ls_multipart-DATA"data    " Binary data
*    OFFSET             = 0    " Offset into binary data
*    LENGTH             = lv_len   " Length of binary data
*    VSCAN_SCAN_ALWAYS  = IF_HTTP_ENTITY=>CO_CONTENT_CHECK_PROFILE    " Virus Scan Always (A = Always, N = Never, space = Internal)
*    VIRUS_SCAN_PROFILE = '/SIHTTP/HTTP_DOWNLOAD'    " Virus Scan Profile

    ).

      ENDIF.

      CLEAR lv_part.
    ENDLOOP.

  ELSE.
    lo_http_client->request->SET_CONTENT_TYPE( CONTENT_TYPE = 'application/json' ).




  ENDIF.

************


*body
  lo_http_client->request->SET_DATA(
    exporting
      DATA               = out  " Binary data
*    OFFSET             = 0    " Offset into binary data
*    LENGTH             = lv_len   " Length of binary data
*    VSCAN_SCAN_ALWAYS  = IF_HTTP_ENTITY=>CO_CONTENT_CHECK_PROFILE    " Virus Scan Always (A = Always, N = Never, space = Internal)
*    VIRUS_SCAN_PROFILE = '/SIHTTP/HTTP_DOWNLOAD'    " Virus Scan Profile
  ).

* Query parameters

  LOOP AT tp_param INTO ls_param.
    CALL METHOD lo_http_client->request->set_form_field
      EXPORTING
        name  = ls_param-name
        value = ls_param-value.
  ENDLOOP.



**********************************************************************
* Set OAuth 2.0 Token
**********************************************************************
  TRY.

      CALL METHOD cl_oauth2_client=>create
        EXPORTING
          i_profile        = ZCL_GOOGLE_CONSTANTS=>GOOGLE_PROFILE
        RECEIVING
          ro_oauth2_client = lo_oa2c_client.

    CATCH cx_oa2c INTO lx_oa2c.
      WRITE: `Error calling CREATE.`.
      WRITE: / lx_oa2c->get_text( ).
      RETURN.
  ENDTRY.

  TRY.

      CALL METHOD lo_oa2c_client->set_token
        EXPORTING
          io_http_client = lo_http_client
          i_param_kind   = ip_param_kind.

    CATCH cx_oa2c INTO lx_oa2c.
      TRY.
          CALL METHOD lo_oa2c_client->execute_refresh_flow.
        CATCH cx_oa2c INTO lx_oa2c.
          WRITE: `Error calling EXECUTE_REFRESH_FLOW.`.
          WRITE: / lx_oa2c->get_text( ).
          RETURN.
      ENDTRY.
      TRY.
          CALL METHOD lo_oa2c_client->set_token
            EXPORTING
              io_http_client = lo_http_client
              i_param_kind   = ip_param_kind.
        CATCH cx_oa2c INTO lx_oa2c.
          WRITE: `Error calling SET_TOKEN.`.
          WRITE: / lx_oa2c->get_text( ).
          RETURN.
      ENDTRY.
  ENDTRY.



**********************************************************************
* Send / Receive Request
**********************************************************************
  CLEAR lt_fields.
  CALL METHOD lo_http_client->request->get_header_fields
    CHANGING
      fields = lt_fields.
  CLEAR lt_fields.
  CALL METHOD lo_http_client->send
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3
      http_invalid_timeout       = 4
      OTHERS                     = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CALL METHOD lo_http_client->receive
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3
      OTHERS                     = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.



**********************************************************************
* Display result
**********************************************************************
  CALL METHOD lo_http_client->response->get_status
    IMPORTING
      code = l_status_code.
*  WRITE / |{ l_status_code }|.

  WRITE /.

  IF l_status_code = 200.
    CALL METHOD lo_http_client->response->get_cdata
      RECEIVING
        data = l_response_data.

    EP_RESPONSE_STRING = l_response_data.

    CALL METHOD lo_http_client->response->GET_DATA
*     exporting
*       OFFSET             = 0    " Offset into binary data
*       LENGTH             = -1    " Length of binary data
*       VIRUS_SCAN_PROFILE = '/SIHTTP/HTTP_UPLOAD'    " Virus Scan Profile
*       VSCAN_SCAN_ALWAYS  = IF_HTTP_ENTITY=>CO_CONTENT_CHECK_PROFILE    " Virus Scan Always (A = Always, N = Never, space = Internal)
      receiving
        DATA = out.   " Binary data







    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        BUFFER        = out
*       APPEND_TO_TABLE       = ' '
      IMPORTING
        OUTPUT_LENGTH = length
      TABLES
        BINARY_TAB    = lt_binary_data.



    DATA(l_content_type) = lo_http_client->response->get_content_type( ).
    IF l_content_type CP `text/html*`.
*     cl_demo_output=>display_html( html = l_response_data ).
    ELSEIF l_content_type CP `text/xml*`.
*      cl_demo_output=>display_xml( xml = l_response_data ).
    ELSEIF l_content_type CP `application/json*`.
*      cl_demo_output=>display_json( json = l_response_data ).
    ENDIF.
  ELSE.
    CALL METHOD lo_http_client->response->get_header_fields
      CHANGING
        fields = lt_fields.

    LOOP AT lt_fields ASSIGNING <ls_field>.
      WRITE: / <ls_field>-name, 25 <ls_field>-value.
    ENDLOOP.
    WRITE 's'.
    WRITE IP_JSON_REQUEST.
  ENDIF.



**********************************************************************
* Close
**********************************************************************
  CALL METHOD lo_http_client->close
    EXCEPTIONS
      http_invalid_state = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
endmethod.
ENDCLASS.
