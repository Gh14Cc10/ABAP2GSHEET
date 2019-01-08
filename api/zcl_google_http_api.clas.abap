CLASS zcl_google_http_api DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-DATA gc_spreadsheet_url_prefix TYPE string VALUE 'https://docs.google.com/spreadsheets/d/' ##NO_TEXT.

    CLASS-METHODS get_response_string
      IMPORTING
        !response              TYPE REF TO if_http_response
      RETURNING
        VALUE(p_response_data) TYPE string .
    CLASS-METHODS extract_spreadsheet_id
      IMPORTING
        !ip_url              TYPE string
      RETURNING
        VALUE(ep_identifier) TYPE string .
    CLASS-METHODS send_delete_request
      IMPORTING
        !target          TYPE string
        !method          TYPE string
        !param_kind      TYPE string
        !lt_param        TYPE tihttpnvp
      EXPORTING
        !response_string TYPE string
        !response        TYPE REF TO if_http_response .
    CLASS-METHODS display_response
      IMPORTING
        VALUE(response)        TYPE REF TO if_http_response
      RETURNING
        VALUE(p_response_data) TYPE string .
    CLASS-METHODS send_patch_request
      IMPORTING
        VALUE(ip_target)          TYPE string
        VALUE(ip_param_kind)      TYPE string
        VALUE(tp_param)           TYPE tihttpnvp OPTIONAL
        VALUE(ip_json_request)    TYPE string
        VALUE(it_multiparts)      TYPE zgsheet_post_multipart_tt OPTIONAL
      EXPORTING
        VALUE(ep_response_string) TYPE string .
    CLASS-METHODS send_post_request
      IMPORTING
        VALUE(ip_target)          TYPE string
        VALUE(ip_param_kind)      TYPE string
        VALUE(tp_param)           TYPE tihttpnvp OPTIONAL
        VALUE(ip_json_request)    TYPE string
        VALUE(it_multiparts)      TYPE zgsheet_post_multipart_tt OPTIONAL
      EXPORTING
        VALUE(ep_response_string) TYPE string .
    CLASS-METHODS send_get_request
      IMPORTING
        VALUE(target)          TYPE string
        VALUE(method)          TYPE string OPTIONAL
        VALUE(param_kind)      TYPE string
        VALUE(lt_param)        TYPE tihttpnvp
      EXPORTING
        VALUE(response_string) TYPE string
        VALUE(response)        TYPE REF TO if_http_response .
    CLASS-METHODS extract_response
      EXPORTING
        VALUE(response) TYPE REF TO if_http_response .
    CLASS-METHODS encode_json2abap
      IMPORTING
        VALUE(ip_json)      TYPE string
      CHANGING
        VALUE(cp_abap_data) TYPE any .
    CLASS-METHODS decode_abap2json
      EXPORTING
        VALUE(ep_json)      TYPE string
      CHANGING
        VALUE(cp_abap_data) TYPE any .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GOOGLE_HTTP_API IMPLEMENTATION.


  METHOD decode_abap2json.



    ep_json = /ui2/cl_json=>serialize(
       data = cp_abap_data
       compress = abap_true
       pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).


  ENDMETHOD.


  METHOD display_response.
    DATA:lt_fields     TYPE tihttpnvp,
         l_status_code TYPE i.

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


  ENDMETHOD.


  METHOD encode_json2abap.


    /ui2/cl_json=>deserialize(

    EXPORTING json = ip_json


    pretty_name = /ui2/cl_json=>pretty_mode-camel_case

    CHANGING
        data = cp_abap_data

    ).

  ENDMETHOD.


  METHOD extract_response.
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


  ENDMETHOD.


  METHOD extract_spreadsheet_id.

    ep_identifier = ip_url.
    REPLACE  gc_spreadsheet_url_prefix IN ep_identifier WITH ''.
    REPLACE ALL OCCURRENCES OF REGEX '/.*' IN  ep_identifier WITH ''.




  ENDMETHOD.


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


  METHOD send_delete_request.



    DATA:
      ls_param TYPE ihttpnvp,
      length   TYPE i.

    DATA: lo_http_client  TYPE REF TO if_http_client,
          lo_oa2c_client  TYPE REF TO if_oauth2_client,
          l_status_code   TYPE i,
          l_response_data TYPE string,
          lt_fields       TYPE tihttpnvp,
          lx_oa2c         TYPE REF TO cx_oa2c,
          lt_binary_data  TYPE  solix_tab,
          ls_binary_data  LIKE LINE OF lt_binary_data.


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
            i_profile        = zcl_google_constants=>google_profile
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

    response = lo_http_client->response.


**********************************************************************
* Display result
**********************************************************************
    response_string = display_response( response =  lo_http_client->response ).


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

  ENDMETHOD.


  METHOD send_get_request.

*&---------------------------------------------------------------------*
*& Report ZGOOGLE_DOWNLOAD_XLS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


    DATA:
      ls_param TYPE ihttpnvp,
      length   TYPE i.

    DATA: lo_http_client  TYPE REF TO if_http_client,
          lo_oa2c_client  TYPE REF TO if_oauth2_client,
          l_status_code   TYPE i,
          l_response_data TYPE string,
          lt_fields       TYPE tihttpnvp,
          lx_oa2c         TYPE REF TO cx_oa2c,
          lt_binary_data  TYPE  solix_tab,
          ls_binary_data  LIKE LINE OF lt_binary_data.


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
            i_profile        = zcl_google_constants=>google_profile
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

    response = lo_http_client->response.


**********************************************************************
* Display result
**********************************************************************
*RESPONSE_STRING = DISPLAY_RESPONSE( RESPONSE =  lo_http_client->response ).

**********************************************************************
* Response result
**********************************************************************
    response_string = get_response_string( response =  lo_http_client->response ).
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
  ENDMETHOD.


  METHOD send_patch_request.
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
        text   = ip_json_request
      IMPORTING
        buffer = out.

******************
*Multipart request
    DATA: ls_header_field TYPE ihttpnvp,
          ls_multipart    TYPE zgsheet_post_multipart_s.
    DATA lv_part TYPE REF TO if_http_entity.

    IF it_multiparts IS NOT INITIAL.

      lo_http_client->request->set_content_type( content_type = 'multipart/form-data' ).
      LOOP AT it_multiparts INTO ls_multipart.
        lv_part = lo_http_client->request->if_http_entity~add_multipart(
*    SUPPRESS_CONTENT_LENGTH = ABAP_FALSE
    ).

        lv_part->set_content_type( content_type = ls_multipart-content_type ).
        LOOP AT ls_multipart-header_fields INTO ls_header_field.
          CALL METHOD lv_part->set_header_field
            EXPORTING
              name  = ls_header_field-name " Name of the header field
              value = ls_header_field-value. " HTTP header field value
          IF ls_multipart-cdata IS NOT INITIAL.
            lv_part->set_cdata( ls_multipart-cdata ).
          ENDIF.

        ENDLOOP.


        IF ls_multipart-data IS NOT INITIAL.

          lv_part->set_data(
        EXPORTING
          data               =   ls_multipart-data"data    " Binary data
*    OFFSET             = 0    " Offset into binary data
*    LENGTH             = lv_len   " Length of binary data
*    VSCAN_SCAN_ALWAYS  = IF_HTTP_ENTITY=>CO_CONTENT_CHECK_PROFILE    " Virus Scan Always (A = Always, N = Never, space = Internal)
*    VIRUS_SCAN_PROFILE = '/SIHTTP/HTTP_DOWNLOAD'    " Virus Scan Profile

      ).

        ENDIF.

        CLEAR lv_part.
      ENDLOOP.

    ELSE.
      lo_http_client->request->set_content_type( content_type = 'application/json' ).




    ENDIF.

************


*body
    lo_http_client->request->set_data(
      EXPORTING
        data               = out  " Binary data
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
            i_profile        = zcl_google_constants=>google_profile
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

      ep_response_string = l_response_data.

      CALL METHOD lo_http_client->response->get_data
*     exporting
*       OFFSET             = 0    " Offset into binary data
*       LENGTH             = -1    " Length of binary data
*       VIRUS_SCAN_PROFILE = '/SIHTTP/HTTP_UPLOAD'    " Virus Scan Profile
*       VSCAN_SCAN_ALWAYS  = IF_HTTP_ENTITY=>CO_CONTENT_CHECK_PROFILE    " Virus Scan Always (A = Always, N = Never, space = Internal)
        RECEIVING
          data = out.   " Binary data







      CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
        EXPORTING
          buffer        = out
*         APPEND_TO_TABLE       = ' '
        IMPORTING
          output_length = length
        TABLES
          binary_tab    = lt_binary_data.



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
      WRITE ip_json_request.
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
  ENDMETHOD.


  METHOD send_post_request.
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
        text   = ip_json_request
      IMPORTING
        buffer = out.

******************
*Multipart request
    DATA: ls_header_field TYPE ihttpnvp,
          ls_multipart    TYPE zgsheet_post_multipart_s.
    DATA lv_part TYPE REF TO if_http_entity.

    IF it_multiparts IS NOT INITIAL.

      lo_http_client->request->set_content_type( content_type = 'multipart/form-data' ).
      LOOP AT it_multiparts INTO ls_multipart.
        lv_part = lo_http_client->request->if_http_entity~add_multipart(
*    SUPPRESS_CONTENT_LENGTH = ABAP_FALSE
    ).

        lv_part->set_content_type( content_type = ls_multipart-content_type ).
        LOOP AT ls_multipart-header_fields INTO ls_header_field.
          CALL METHOD lv_part->set_header_field
            EXPORTING
              name  = ls_header_field-name " Name of the header field
              value = ls_header_field-value. " HTTP header field value
          IF ls_multipart-cdata IS NOT INITIAL.
            lv_part->set_cdata( ls_multipart-cdata ).
          ENDIF.

        ENDLOOP.


        IF ls_multipart-data IS NOT INITIAL.

          lv_part->set_data(
        EXPORTING
          data               =   ls_multipart-data"data    " Binary data
*    OFFSET             = 0    " Offset into binary data
*    LENGTH             = lv_len   " Length of binary data
*    VSCAN_SCAN_ALWAYS  = IF_HTTP_ENTITY=>CO_CONTENT_CHECK_PROFILE    " Virus Scan Always (A = Always, N = Never, space = Internal)
*    VIRUS_SCAN_PROFILE = '/SIHTTP/HTTP_DOWNLOAD'    " Virus Scan Profile

      ).

        ENDIF.

        CLEAR lv_part.
      ENDLOOP.

    ELSE.
      lo_http_client->request->set_content_type( content_type = 'application/json' ).




    ENDIF.

************


*body
    lo_http_client->request->set_data(
      EXPORTING
        data               = out  " Binary data
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
            i_profile        = zcl_google_constants=>google_profile
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

      ep_response_string = l_response_data.

      CALL METHOD lo_http_client->response->get_data
*     exporting
*       OFFSET             = 0    " Offset into binary data
*       LENGTH             = -1    " Length of binary data
*       VIRUS_SCAN_PROFILE = '/SIHTTP/HTTP_UPLOAD'    " Virus Scan Profile
*       VSCAN_SCAN_ALWAYS  = IF_HTTP_ENTITY=>CO_CONTENT_CHECK_PROFILE    " Virus Scan Always (A = Always, N = Never, space = Internal)
        RECEIVING
          data = out.   " Binary data







      CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
        EXPORTING
          buffer        = out
*         APPEND_TO_TABLE       = ' '
        IMPORTING
          output_length = length
        TABLES
          binary_tab    = lt_binary_data.



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
      WRITE ip_json_request.
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
  ENDMETHOD.
ENDCLASS.
