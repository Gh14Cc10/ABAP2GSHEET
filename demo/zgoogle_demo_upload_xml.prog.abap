*&---------------------------------------------------------------------*
*& Report ZGOOGLE_DEMO_UPLOAD_XML.
*&---------------------------------------------------------------------*
*& xml generation and upload to google drive
*&---------------------------------------------------------------------*
REPORT zgoogle_demo_upload_xml.


*&---------------------------------------------------------------------*


TABLES : vbak, vbap, kna1.

DATA : BEGIN OF i_orders OCCURS 100,
         order_num     TYPE string,
         date          TYPE string,
         customer_code TYPE string,
         customer_name TYPE string.
DATA : END OF i_orders.

DATA : BEGIN OF i_items  OCCURS 100,
         order_num TYPE string,
         matnr     TYPE string,
         quantity  TYPE string,
         amount    TYPE string.
DATA : END OF i_items.

*select-options: l_date for sy-datum DEFAULT sy-datum.
*select-options: l_order for vbak-vbeln.
*PARAMETERS : fname type LOCALFILE DEFAULT 'c:\'.

PERFORM select_orders.
PERFORM make_xml.

*&---------------------------------------------------------------------*
*&      Form  select_orders
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM select_orders.
  SELECT * FROM vbak  UP TO 20 ROWS.
*  select * from vbak where vbeln in l_order and
*                           erdat in l_date.
    WRITE :/ ' Order '.
    WRITE :/ '-------------------------'.
    SELECT SINGLE * FROM kna1 WHERE kunnr = vbak-kunnr.
    i_orders-order_num = vbak-vbeln.
    i_orders-date = vbak-erdat.
    i_orders-customer_code = vbak-kunnr.
    i_orders-customer_name = kna1-name1.
    APPEND i_orders.
    WRITE :/ 'Order Number : ', vbak-vbeln.
    WRITE :/ 'Order Date   : ', vbak-erdat.
    WRITE :/ 'Customer Code: ', vbak-kunnr.
    WRITE :/ 'Customer Name: ', kna1-name1.
    SKIP 1.
    WRITE :/ 'Items  '.
    WRITE :/ '------------------------------------------'.
    SELECT * FROM vbap WHERE vbeln = vbak-vbeln.
      i_items-order_num = vbap-vbeln.
      i_items-matnr = vbap-matnr.
      i_items-quantity = vbap-kwmeng.
      i_items-amount = vbap-netpr.
      APPEND i_items.
      WRITE:/ vbap-matnr,
              vbap-kwmeng,
              vbap-netpr.
    ENDSELECT.
    SKIP 1.
  ENDSELECT.


ENDFORM.                    "select_orders


*&---------------------------------------------------------------------*
*&      Form  make_xml
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM make_xml.
  DATA: lo_ixml TYPE REF TO if_ixml.
  DATA: lo_document TYPE REF TO if_ixml_document.
  DATA: m_xmldoc TYPE REF TO cl_xml_document.
  DATA: orders  TYPE REF TO if_ixml_element.
  DATA: order TYPE REF TO if_ixml_element.
  DATA: items TYPE REF TO if_ixml_element.
  DATA: item TYPE REF TO if_ixml_element.

  lo_ixml = cl_ixml=>create( ).

  lo_document = lo_ixml->create_document( ).

  orders  = lo_document->create_simple_element(
                                      name    = 'Orders'
                                      parent  = lo_document ).
  LOOP AT i_orders.
    order = lo_document->create_simple_element(
                                        name    = 'Order'
                                        parent  = orders ).

    lo_document->create_simple_element( name    = 'order_num'
                                        parent  = order
                                        value   = i_orders-order_num ).
    lo_document->create_simple_element( name    = 'date'
                                        parent  = order
                                        value   = i_orders-date ).
    lo_document->create_simple_element( name    = 'customer_code'
                                        parent  = order
                                        value   = i_orders-customer_code ).
    lo_document->create_simple_element( name    = 'customer_name'
                                        parent  = order
                                        value   = i_orders-customer_name ).

    items = lo_document->create_simple_element(
                                        name    = 'Items'
                                        parent  = order ).
    LOOP AT i_items WHERE order_num = i_orders-order_num.
      item = lo_document->create_simple_element(
                                          name    = 'Item'
                                          parent  = items ).
      lo_document->create_simple_element( name    = 'matnr'
                                          parent  = item
                                          value = i_items-matnr ).
      lo_document->create_simple_element( name    = 'quantity'
                                          parent  = item
                                          value   = i_items-quantity ).
      lo_document->create_simple_element( name    = 'amount'
                                          parent  = item
                                          value = i_items-amount ).
    ENDLOOP.

  ENDLOOP.
  CREATE OBJECT m_xmldoc.
  m_xmldoc->create_with_dom( document = lo_document ).
*  m_xmldoc->export_to_file( fname ).
  DATA stream TYPE xstring.

  DATA:
    ld_i_r_xml_doc TYPE REF TO if_ixml_document,
    ld_r_xml       TYPE xstring.



  CALL METHOD cl_rsl_tlogo=>get_xml_from_doc(
    EXPORTING
      i_r_xml_doc = lo_document
    RECEIVING
      r_xml       = ld_r_xml ).






******* Send to google Drive

  CALL METHOD zcl_gdrive_file_api=>upload(
    EXPORTING
      ip_file_xstring       = ld_r_xml
      ip_filename           = 'AbapGeneratedXml'
      ip_original_mime_type = 'application/xml'
                              ).

ENDFORM.
