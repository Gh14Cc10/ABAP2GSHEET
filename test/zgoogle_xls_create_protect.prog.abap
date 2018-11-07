*&---------------------------------------------------------------------*
*& Report ZGOOGLE_XLS_CREATE_PROTECT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZGOOGLE_XLS_CREATE_PROTECT.


DATA: profile    TYPE oa2c_profile,
   target     TYPE string,
   target2     TYPE string,
   method     TYPE string,
   method2    TYPE string,
   param_kind TYPE string,
   lt_param   TYPE tihttpnvp,
   ls_param   TYPE ihttpnvp,
   length  TYPE i.
DATA out TYPE xstring.


DATA: lo_http_client  TYPE REF TO if_http_client,
      lo_http_client_get TYPE REF TO if_http_client,
     lo_oa2c_client  TYPE REF TO if_oauth2_client,
     l_status_code   TYPE i,
     l_response_data TYPE string,
     lt_fields       TYPE tihttpnvp,
     lx_oa2c         TYPE REF TO cx_oa2c.

DATA lt_binary_data                  TYPE  solix_tab.
DATA lt_binary_data2                  TYPE  solix_tab.
DATA lt_final_data                 TYPE STANDARD TABLE OF c WITH NON-UNIQUE DEFAULT KEY.

DATA ls_binary_data like LINE OF lt_binary_data.
DATA data TYPE xstring.

FIELD-SYMBOLS: <ls_field> LIKE LINE OF lt_fields.
AT SELECTION-SCREEN.


START-OF-SELECTION.

profile = 'Z_GOOGLE_CL_PROFILE'.

method  = `POST`.
param_kind = 'H'. " (H o F)
target = 'https://sheets.googleapis.com/v4/spreadsheets'.

* 'https://sheets.googleapis.com/v4/spreadsheets/1gE7n-xZnnB_8MHyZHpipNEpq_BNGHqkCit1ZJAvxDkE:batchUpdate'.
*target = 'http://requestbin.net/r/pmnvkbpm'." HTTP/1.1'.

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




**********************************************************************
* Create  second HTTP client
**********************************************************************

profile = 'Z_GOOGLE_CL_PROFILE'.

method2  = `POST`.
param_kind = 'H'. " (H o F)
target2 = 'https://sheets.googleapis.com/v4/spreadsheets/1gE7n-xZnnB_8MHyZHpipNEpq_BNGHqkCit1ZJAvxDkE'.

CALL METHOD cl_http_client=>create_by_url
 EXPORTING
   url                = target2
   ssl_id             = 'ANONYM'
 IMPORTING
   client             = lo_http_client_get
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
lo_http_client_get->propertytype_logon_popup = 0.

CALL METHOD lo_http_client_get->request->set_method
 EXPORTING
   method = method2.

lo_http_client_get->request->SET_CONTENT_TYPE( CONTENT_TYPE = 'application/json' ).


**********************************************************************
* Set OAuth 2.0 Token
**********************************************************************
TRY.

   CALL METHOD cl_oauth2_client=>create
     EXPORTING
       i_profile        = profile
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
       io_http_client = lo_http_client_get
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
           io_http_client = lo_http_client_get
           i_param_kind   = param_kind.
     CATCH cx_oa2c INTO lx_oa2c.
       WRITE: `Error calling SET_TOKEN.`.
       WRITE: / lx_oa2c->get_text( ).
       RETURN.
   ENDTRY.
ENDTRY.

DATA: lv_request_creation type string.
lv_request_creation =  '{"namedRanges":[{"name":"ExcelCreationApiTest"}],"properties":{"title":"ExcelAbapCreated"}}'.
*lv_req2 =  '"warningOnly":false,"requestingUserCanEdit":false,"editors":{"users":["micael.teweldemedhin@techedgegroup.com","alessandro.iannacci@techedgegroup.com"],"domainUsersCanEdit":false}}}}]}'.




  CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
  EXPORTING
    TEXT           =   lv_request_creation
 IMPORTING
   BUFFER         = out.




*body
lo_http_client_get->request->SET_DATA(
  exporting
    DATA               = out  " Binary data
*    OFFSET             = 0    " Offset into binary data
*    LENGTH             = lv_len   " Length of binary data
*    VSCAN_SCAN_ALWAYS  = IF_HTTP_ENTITY=>CO_CONTENT_CHECK_PROFILE    " Virus Scan Always (A = Always, N = Never, space = Internal)
*    VIRUS_SCAN_PROFILE = '/SIHTTP/HTTP_DOWNLOAD'    " Virus Scan Profile
).





**********************************************************************
* Send / Receive Request (Just the creation)
**********************************************************************
CLEAR lt_fields.
CALL METHOD lo_http_client_get->request->get_header_fields
     CHANGING
       fields = lt_fields.
CLEAR lt_fields.
 CALL METHOD lo_http_client_get->send
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

 CALL METHOD lo_http_client_get->receive
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
* Display result  (Just the GET)
**********************************************************************
 CALL METHOD lo_http_client_get->response->get_status
   IMPORTING
     code = l_status_code.
 WRITE / |{ l_status_code }|.

 WRITE /.

 IF l_status_code = 200.
   CALL METHOD lo_http_client_get->response->get_cdata
     RECEIVING
       data = l_response_data.



   CALL METHOD lo_http_client_get->response->GET_DATA
*     exporting
*       OFFSET             = 0    " Offset into binary data
*       LENGTH             = -1    " Length of binary data
*       VIRUS_SCAN_PROFILE = '/SIHTTP/HTTP_UPLOAD'    " Virus Scan Profile
*       VSCAN_SCAN_ALWAYS  = IF_HTTP_ENTITY=>CO_CONTENT_CHECK_PROFILE    " Virus Scan Always (A = Always, N = Never, space = Internal)
     receiving
       DATA               =  out   " Binary data
     .

*********** Reading the sheetId name SheetTest

 DATA: lv_json_STRING type STRING,
       lv_spreadhsheetId type string,
      responseData type  ZJSON_KEY_VALUE_T.




   CALL FUNCTION 'HR_KR_XSTRING_TO_STRING'
 EXPORTING
 in_xstring = out
 IMPORTING
 out_string = lv_json_string.


DATA JSON_DOCUMENT TYPE REF TO  ZCL_JSON_DOCUMENT.


   ZCL_JSON_DOCUMENT=>CREATE_WITH_JSON(
     exporting
       JSON          = lv_json_STRING
*       DATE_FORMAT   =
     receiving
       JSON_DOCUMENT = json_document
   ).
 json_document->set_json( lv_json_STRING ).


 lv_spreadhsheetId  = json_document->GET_VALUE( KEY =  'SreadhSheetID').




ENDIF.
**********************************************************************

* Turn off logon popup. Detect authentication errors.
lo_http_client->propertytype_logon_popup = 0.

CALL METHOD lo_http_client->request->set_method
 EXPORTING
   method = method.

lo_http_client->request->SET_CONTENT_TYPE( CONTENT_TYPE = 'application/json' ).



DATA: lv_request_protection type string.
lv_request_protection =  '{"namedRanges":[{"name":"ExcelCreationApiTest"}],"properties":{"title":"ExcelAbapCreated"}}'.
*lv_req2 =  '"warningOnly":false,"requestingUserCanEdit":false,"editors":{"users":["micael.teweldemedhin@techedgegroup.com","alessandro.iannacci@techedgegroup.com"],"domainUsersCanEdit":false}}}}]}'.



  CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
  EXPORTING
    TEXT           = lv_request_protection
 IMPORTING
   BUFFER         = out.




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
*LS_PARAM-name  = 'title'.
*LS_PARAM-value = 'asdasd' .
*APPEND LS_PARAM to lt_param.


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
       i_profile        = profile
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



   CALL METHOD lo_http_client->response->GET_DATA
*     exporting
*       OFFSET             = 0    " Offset into binary data
*       LENGTH             = -1    " Length of binary data
*       VIRUS_SCAN_PROFILE = '/SIHTTP/HTTP_UPLOAD'    " Virus Scan Profile
*       VSCAN_SCAN_ALWAYS  = IF_HTTP_ENTITY=>CO_CONTENT_CHECK_PROFILE    " Virus Scan Always (A = Always, N = Never, space = Internal)
     receiving
       DATA               =  out   " Binary data
     .







CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
  EXPORTING
    BUFFER                =  out
*   APPEND_TO_TABLE       = ' '
 IMPORTING
   OUTPUT_LENGTH         = length
  TABLES
    BINARY_TAB            = lt_binary_data.



*APPEND out TO  lt_binary_data.




*length = strlen( l_response_data ).
       cl_gui_frontend_services=>gui_download( EXPORTING
                                                      bin_filesize = length
                                                      filename     = 'c:\temp\test.xlsx'
                                                      filetype     = 'BIN'
                                             CHANGING data_tab     = lt_binary_data ).
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
