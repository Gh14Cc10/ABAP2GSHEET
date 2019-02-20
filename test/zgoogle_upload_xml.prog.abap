*&---------------------------------------------------------------------*
*& Report ZGOOGLE_DEMO_XML
*&---------------------------------------------------------------------*
*& Generate an xml from VBAK and upload to  google drive account
*&---------------------------------------------------------------------*
REPORT ZGOOGLE_UPLOAD_XML.

*&---------------------------------------------------------------------*


tables : vbak, vbap, kna1.

data : begin of i_orders OCCURS 100,
  order_num type string,
  date type string,
  customer_code type string,
  customer_name type string.
data : end of i_orders.

data : begin of i_items  occurs 100,
         order_num type string,
         matnr type string,
         quantity type string,
         amount type string.
data : end of i_items.

*select-options: l_date for sy-datum DEFAULT sy-datum.
*select-options: l_order for vbak-vbeln.
*PARAMETERS : fname type LOCALFILE DEFAULT 'c:\'.

PERFORM select_orders.
perform make_xml.

*&---------------------------------------------------------------------*
*&      Form  select_orders
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form select_orders.
  select * from vbak  up to 20 ROWS WHERE VBELN < 100.
*  select * from vbak where vbeln in l_order and
*                           erdat in l_date.
    write :/ ' Order '.
    write :/ '-------------------------'.
    select single * from kna1 where kunnr = vbak-kunnr.
    i_orders-order_num = vbak-vbeln.
    i_orders-date = vbak-erdat.
    i_orders-customer_code = vbak-kunnr.
    i_orders-customer_name = kna1-name1.
    append i_orders.
    write :/ 'Order Number : ', vbak-vbeln.
    write :/ 'Order Date   : ', vbak-erdat.
    write :/ 'Customer Code: ', vbak-kunnr.
    write :/ 'Customer Name: ', kna1-name1.
    skip 1.
    write :/ 'Items  '.
    write :/ '------------------------------------------'.
    select * from vbap where vbeln = vbak-vbeln.
      i_items-order_num = vbap-vbeln.
      i_items-matnr = vbap-matnr.
      i_items-quantity = vbap-kwMENG.
      i_items-amount = vbap-netpr.
      append i_items.
      write:/ vbap-matnr,
              vbap-kwMENG,
              vbap-netpr.
    endselect.
    skip 1.
  endselect.


endform.                    "select_orders


*&---------------------------------------------------------------------*
*&      Form  make_xml
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form make_xml.
  DATA: lo_ixml TYPE REF TO if_ixml.
  DATA: lo_document TYPE REF TO if_ixml_document.
  data: m_xmldoc type ref to CL_XML_DOCUMENT.
  DATA: Orders  TYPE REF TO if_ixml_element.
  DATA: Order TYPE REF TO if_ixml_element.
  DATA: Items TYPE REF TO if_ixml_element.
  DATA: Item TYPE REF TO if_ixml_element.

  lo_ixml = cl_ixml=>create( ).

  lo_document = lo_ixml->create_document( ).

  Orders  = lo_document->create_simple_element(
                                      name    = 'Orders'
                                      parent  = lo_document ).
  LOOP AT i_orders.
    Order = lo_document->create_simple_element(
                                        name    = 'Order'
                                        parent  = Orders ).

    lo_document->create_simple_element( name    = 'order_num'
                                        parent  = Order
                                        value   = i_orders-order_num ).
    lo_document->create_simple_element( name    = 'date'
                                        parent  = Order
                                        value   = i_orders-date ).
    lo_document->create_simple_element( name    = 'customer_code'
                                        parent  = Order
                                        value   = i_orders-customer_code ).
    lo_document->create_simple_element( name    = 'customer_name'
                                        parent  = Order
                                        value   = i_orders-customer_name ).

    Items = lo_document->create_simple_element(
                                        name    = 'Items'
                                        parent  = Order ).
    loop at i_items where order_num = i_orders-order_num.
      Item = lo_document->create_simple_element(
                                          name    = 'Item'
                                          parent  = Items ).
      lo_document->create_simple_element( name    = 'matnr'
                                          parent  = Item
                                          value = i_items-matnr ).
      lo_document->create_simple_element( name    = 'quantity'
                                          parent  = Item
                                          value   = i_items-quantity ).
      lo_document->create_simple_element( name    = 'amount'
                                          parent  = Item
                                          value = i_items-amount ).
    endloop.

  ENDLOOP.
  create object m_xmldoc.
  m_xmldoc->create_with_dom( document = lo_document ).
*  m_xmldoc->export_to_file( fname ).
  DATA stream type xstring.

DATA:
ld_I_R_XML_DOC TYPE REF TO IF_IXML_DOCUMENT ,
ld_R_XML TYPE XSTRING.

" ld_I_R_XML_DOC = "

CALL METHOD CL_RSL_TLOGO=>GET_XML_FROM_DOC(
EXPORTING
I_R_XML_DOC = lo_document
RECEIVING
R_XML = ld_R_XML ).










"Eseguendo il multipart, in una sezione si mandano i metadati, nell'altra il binario
"Funziona con l'upload V3, converte e rinomina

DATA :   filename TYPE string,
        data    TYPE xstring.

  DATA  : length   TYPE i.
  Data: lt_binary_data                  TYPE STANDARD TABLE OF x255 WITH NON-UNIQUE DEFAULT KEY.



  filename = 'C:\Desktop\Celle_Unite_colori_filtro.xlsx'.
*  CALL FUNCTION 'GUI_UPLOAD'
*    EXPORTING
*      filename   = filename
*      filetype   = 'BIN'
*    IMPORTING
*      filelength = length
*    TABLES
*      data_tab   = lt_binary_data
*    EXCEPTIONS
*      OTHERS     = 99.
*
*   CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
*      EXPORTING
*        input_length = length
*      IMPORTING
*        buffer       = data
*      TABLES
*        binary_tab   = lt_binary_data.

**********************************************************************

DATA: profile    TYPE oa2c_profile,
   target     TYPE string,
   method     TYPE string,
   param_kind TYPE string,
   lt_param   TYPE tihttpnvp,
   ls_param   TYPE ihttpnvp.




profile = 'Z_GOOGLE_CL_PROFILE'.

method  = `POST`.
param_kind = 'H'."'F'.
*target = 'https://www.googleapis.com/upload/drive/v2/files?uploadType=media'.
*target = 'https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart'." HTTP/1.1'.
target = 'http://requestbin.net/r/w2we4rw2'." HTTP/1.1'.



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
    INPUT         = ld_R_XML
 IMPORTING
   OUTPUT        = lv_data
          .


DATA lv_len TYPE i.
DATA lv_len2 TYPE i.
DATA lv_lenc TYPE string.
lv_len = xstrlen( data ).
lv_len2 = strlen( lv_data ).
lv_lenc = lv_len.





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

part->set_CDATA( '{ name: ''asdasd'', mimeType: ''application/xl'' }' ).

part = lo_http_client->request->if_http_entity~ADD_MULTIPART(
*    SUPPRESS_CONTENT_LENGTH = ABAP_FALSE
).

CALL METHOD PART->SET_header_FIELD
EXPORTING
NAME ='content-disposition'
VALUE ='form-data; name="file"; filename="ciaociao.xml"'.
part->SET_CONTENT_TYPE( CONTENT_TYPE = 'application/x' ).




part->SET_DATA(
  exporting
    DATA               = ld_R_XML"data    " Binary data
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








endform.                    "make_xml
