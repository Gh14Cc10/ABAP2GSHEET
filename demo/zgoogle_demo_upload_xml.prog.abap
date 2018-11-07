*&---------------------------------------------------------------------*
*& Report ZGOOGLE_DEMO_UPLOAD_XML.
*&---------------------------------------------------------------------*
*& xml generation and upload to google drive
*&---------------------------------------------------------------------*
REPORT ZGOOGLE_DEMO_UPLOAD_XML.


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
  select * from vbak  up to 20 ROWS.
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



CALL METHOD CL_RSL_TLOGO=>GET_XML_FROM_DOC(
EXPORTING
I_R_XML_DOC = lo_document
RECEIVING
R_XML = ld_R_XML ).






******* Send to google Drive

CALL METHOD ZCL_GDRIVE_FILE_API=>UPLOAD(
EXPORTING:
ip_file_xstring = ld_R_XML
ip_filename = 'AbapGeneratedXml'
IP_ORIGINAL_MIME_TYPE = 'application/xml'
).

ENDFORM.
