REPORT ZGOOGLE_UPLOAD_XLS_2.

"Eseguendo il multipart, in una sezione si mandano i metadati, nell'altra il binario
"Funziona con l'upload V3, converte e rinomina

DATA :   filename TYPE string,
        data    TYPE xstring.

  DATA  : length   TYPE i.
  Data: lt_binary_data                  TYPE STANDARD TABLE OF x255 WITH NON-UNIQUE DEFAULT KEY.



  filename = 'C:\Desktop\Celle_Unite_colori_filtro.xlsx'.
  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename   = filename
      filetype   = 'BIN'
    IMPORTING
      filelength = length
    TABLES
      data_tab   = lt_binary_data
    EXCEPTIONS
      OTHERS     = 99.

   CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
      EXPORTING
        input_length = length
      IMPORTING
        buffer       = data
      TABLES
        binary_tab   = lt_binary_data.

**********************************************************************

DATA: profile    TYPE oa2c_profile,
   target     TYPE string,
   method     TYPE string,
   param_kind TYPE string,
   lt_param   TYPE tihttpnvp,
   ls_param   TYPE ihttpnvp.


AT SELECTION-SCREEN.


START-OF-SELECTION.

profile = 'Z_GOOGLE_CL_PROFILE'.

method  = `POST`.
param_kind = 'H'."'F'.
*target = 'https://www.googleapis.com/upload/drive/v2/files?uploadType=media'.
target = 'https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart&convert=true'." HTTP/1.1'.
*target = 'http://requestbin.net/r/vznwqfvz'." HTTP/1.1'.



DATA: lo_http_client  TYPE REF TO if_http_client,
     lo_oa2c_client  TYPE REF TO if_oauth2_client,
     l_status_code   TYPE i,
     l_response_data TYPE string,
     lt_fields       TYPE tihttpnvp,
     lx_oa2c         TYPE REF TO cx_oa2c.

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
   method = method.



DATA lv_data TYPE string.

CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
  EXPORTING
    INPUT         = data
 IMPORTING
   OUTPUT        = lv_data
          .


DATA lv_len TYPE i.
DATA lv_len2 TYPE i.
DATA lv_lenc TYPE string.
lv_len = xstrlen( data ).
lv_len2 = strlen( lv_data ).
lv_lenc = lv_len.
*
*CALL METHOD lo_http_client->request->SET_HEADER_FIELD
*  exporting
*    NAME  =  'title'   " Name of the header field
*    VALUE =  'we' .   " HTTP header field value
*    CALL METHOD lo_http_client->request->SET_HEADER_FIELD
*  exporting
*    NAME  =  'Content-Length'   " Name of the header field
*    VALUE =  lv_lenc.


*LS_PARAM-name  = 'title'.
*LS_PARAM-value = 'asdasd' .
*APPEND LS_PARAM to lt_param.
*LS_PARAM-name  = 'mimeType'.
*LS_PARAM-value =  'application/vnd.google-apps.spreadsheet'.
*APPEND LS_PARAM to lt_param.
*LS_PARAM-name  = 'originalFilename'.
*LS_PARAM-value =  'pippo.xlsx'.
*APPEND LS_PARAM to lt_param.
*LS_PARAM-name  = 'name'.
*LS_PARAM-value =  'pippo.xlsx'.
*APPEND LS_PARAM to lt_param.
*ls_param-NAME = 'Permissions'.
*ls_param-VALUE = '[ { "domain":"techedgegroup.com" } ]'.
*APPEND LS_PARAM TO lt_param.
LOOP AT lt_param INTO ls_param.
 CALL METHOD lo_http_client->request->set_form_field
   EXPORTING
     name  = ls_param-name
     value = ls_param-value.
ENDLOOP.




*lo_http_client->request->set_cdata( '{ title: asdasd, name: asdasd }' ).

*lo_http_client->request->SET_CONTENT_TYPE( CONTENT_TYPE = 'application/vnd.ms-excel' ).
lo_http_client->request->SET_CONTENT_TYPE( CONTENT_TYPE = 'multipart/form-data' ).

DATA part TYPE ref to if_http_entity.
part = lo_http_client->request->if_http_entity~ADD_MULTIPART(
*    SUPPRESS_CONTENT_LENGTH = ABAP_FALSE
).

CALL METHOD PART->SET_header_FIELD
EXPORTING
NAME ='Content-Disposition'
VALUE ='form-data; name="metadata"'.

part->SET_CONTENT_TYPE( CONTENT_TYPE = 'application/json' ).

*lo_http_client->request->SET_CONTENT_TYPE( CONTENT_TYPE = 'application/json' ).
*lo_http_client->request->SET_CONTENT_TYPE( CONTENT_TYPE = 'application/vnd.google-apps.spreadsheet' ).

*
*lo_http_client->request->SET_CDATA(
*  exporting
*    DATA   = lv_data    " Character data
**    OFFSET = 0    " Offset into character data
*    LENGTH = lv_len2    " Length of character data
*).

part->set_CDATA( '{ name: ''asdasd'', mimeType: ''application/vnd.google-apps.spreadsheet'' }' ).

part = lo_http_client->request->if_http_entity~ADD_MULTIPART(
*    SUPPRESS_CONTENT_LENGTH = ABAP_FALSE
).

CALL METHOD PART->SET_header_FIELD
EXPORTING
NAME ='content-disposition'
VALUE ='form-data; name="file"; filename="ciaociao.xlsx"'.
part->SET_CONTENT_TYPE( CONTENT_TYPE = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' ).




part->SET_DATA(
  exporting
    DATA               = data    " Binary data
*    OFFSET             = 0    " Offset into binary data
*    LENGTH             = lv_len   " Length of binary data
*    VSCAN_SCAN_ALWAYS  = IF_HTTP_ENTITY=>CO_CONTENT_CHECK_PROFILE    " Virus Scan Always (A = Always, N = Never, space = Internal)
*    VIRUS_SCAN_PROFILE = '/SIHTTP/HTTP_DOWNLOAD'    " Virus Scan Profile
).






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

   DATA(l_content_type) = lo_http_client->response->get_content_type( ).
   IF l_content_type CP `text/html*`.
     cl_demo_output=>display_html( html = l_response_data ).
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




************************************************************************************************************************************************************













***

* CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
*      EXPORTING
*        input_length = length
*      IMPORTING
*        buffer       = data
*      TABLES
*        binary_tab   = lt_binary_data.
*
*
**  CONCATENATE filename '2' INTO filename.
*
*    REPLACE ALL OCCURRENCES OF '.xlsx' IN    filename WITH '_report.xlsx'.
** Get trailing blank
*    cl_gui_frontend_services=>gui_download( EXPORTING  bin_filesize  = length
*                                                      filename     = filename
*                                                      filetype     = 'BIN'
*                                             CHANGING data_tab     = lt_binary_data ).
*                    "download_frontendZ
