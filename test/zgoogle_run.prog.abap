*&---------------------------------------------------------------------*
*& Report ZGOOGLE_RUN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZGOOGLE_RUN.


DATA: GOBJECT            TYPE REF TO  ZCL_GOOGLE_HTTP_API,
      lt_param           TYPE tihttpnvp,
      ls_param           TYPE ihttpnvp,
      lv_get_response    type ref to IF_HTTP_RESPONSE,
      lv_test type string,
      lv_response_string TYPE string.
CREATE OBJECT GOBJECT TYPE ZCL_GOOGLE_HTTP_API.
ls_param-name = 'mimeType'.
ls_param-value = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'.
ls_param-value = ''.
CONCATENATE ls_param-name ls_param-value INTO  lv_test SEPARATED BY ' ' RESPECTING BLANKS.

*APPEND ls_param TO lt_param.
GOBJECT->SEND_GET_REQUEST(
  exporting


    TARGET = 'https://sheets.googleapis.com/v4/spreadsheets/1T1GwpQDjC3K8033wkCBlWZOGhHUiji2PP8BwUuxa5ok'
    METHOD     =     'GET'
    PARAM_KIND =      'H'
    LT_PARAM   =     lt_param" HTTP Framework (iHTTP) Table Name/Value Pairs
      importing
   response_string = lv_response_string
   RESPONSE = lv_get_response
).



DATA: lv_json_STRING    type STRING,
      lv_spreadhsheetId type string,

      lv_xstring_line   type xstring.


* CALL FUNCTION 'HR_KR_XSTRING_TO_STRING'
* EXPORTING
* in_xstring =  lv_output_xstring
* IMPORTING
* out_string = lv_json_string.


DATA: JSON_DOCUMENT TYPE REF TO  ZCL_JSON_DOCUMENT,
      intend        type i,
      lv_results    type string_table,
      lt_results    type zjson_key_value,
      data_found    type ABAP_BOOL VALUE abap_true.


ZCL_JSON_DOCUMENT=>CREATE_WITH_JSON(
  exporting
    JSON          = lv_response_string
*       DATE_FORMAT   =
  receiving
    JSON_DOCUMENT = json_document
).

*json_document->set_json( lv_response_string ).
*lv_results = json_document->GET_TABLE_DATA( ).
*json_document->DUMPS(
**  exporting
**    JSON           =  lv_response_string
**    CURRENT_INTEND = intend
*  importing
*    RESULT         = lv_results
*).
*lt_results = JSON_DOCUMENT->GET_VALUE
JSON_DOCUMENT->get_data(
*            EXPORTING json =  lv_response_string
  IMPORTING data = lv_results
  ).



*DATA: lv_json TYPE /ui2/cl_json=>json,
*      lr_data TYPE REF TO data,
*            lv_val TYPE  string.
*
*FIELD-SYMBOLS: <data> TYPE data,
*               <struct> TYPE any,
*               <field> TYPE any.
*
*lv_json = `{"name":"Key1","properties":{"field1":"Value1","field2":"Value2"}}`.

DATA: lv_json TYPE /ui2/cl_json=>json,
      lr_data TYPE REF TO data.

FIELD-SYMBOLS:
  <data>   TYPE data,
  <struct> TYPE any,
  <field>  TYPE any.

lv_json = `{"name":"Key1","properties":{"field1":"Value1","field2":"Value2","field3":"Value3"}}`.
lr_data = /ui2/cl_json=>generate( json = lv_response_string ).



" OK, generated, now let us access somete field :(
*IF lr_data IS BOUND.
*  ASSIGN lr_data->* TO <data>.
*
*  ASSIGN COMPONENT 1 OF STRUCTURE <data> TO <field>.
*  IF <field> IS ASSIGNED.
*    lr_data = <field>.
*    ASSIGN lr_data->* TO <data>.
*    ASSIGN COMPONENT `properties` OF STRUCTURE <data> TO <field>.
*    IF <field> IS ASSIGNED.
*      lr_data = <field>.
*      ASSIGN lr_data->* TO <data>.
*      ASSIGN COMPONENT `field1` OF STRUCTURE <data> TO <field>.
*      IF <field> IS ASSIGNED.
*      lr_data = <field>.
*      lv_spreadhsheetId =  <data>.
*      WRITE: <data>. " We got it -> Value1
*      ENDIF.
*    ENDIF.
*  ENDIF.
*ENDIF.



*********************** Conversione funzionante ***************
 DATA  lt_data_json type zgsne.
* Convert string to Abap structures (better than /UI2/CL_JSON, converts even tables without field names and just values)
      CALL METHOD cl_fdt_json=>json_to_data
        EXPORTING
          iv_json = lv_json
        CHANGING
          ca_data = lt_data_json.
WRITE 'test'.
***********************************************************s
*
*lv_spreadhsheetId  = json_document->GET_VALUE( KEY =  'properties').
*
*WHILE data_found = abap_true.
*  data_found  = JSON_DOCUMENT->GET_NEXT( ).
*ENDWHILE.

**** SECOND REQUEST TO CALL THE COPY FUNCTION***
