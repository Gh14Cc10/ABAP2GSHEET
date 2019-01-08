CLASS zcl_gspreadsheet_sheets_api DEFINITION
  PUBLIC
  INHERITING FROM zcl_google_http_api
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS gc_endpoint_url TYPE string VALUE 'https://sheets.googleapis.com/v4/spreadsheets/{spreadsheetId}/sheets/{sheetId}' ##NO_TEXT.

    CLASS-METHODS copy_sheet
      IMPORTING
        !pa_spreadsheet_id TYPE string
        !pa_sheet_id       TYPE zgsheet_sheet_id
        VALUE(pa_request)  TYPE zgsheet_copy_req_s .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GSPREADSHEET_SHEETS_API IMPLEMENTATION.


  METHOD copy_sheet.

    DATA: lv_target      TYPE string,
*          LV_GHTTP        TYPE REF TO  ZCL_GOOGLE_HTTP_API,
          lt_param       TYPE tihttpnvp,
          lv_req_string  TYPE string,
          lv_resp_string TYPE string.
*    CREATE OBJECT LV_GHTTP TYPE ZCL_GOOGLE_HTTP_API.

    lv_target = gc_endpoint_url.

    REPLACE '{spreadsheetId}' WITH pa_spreadsheet_id INTO lv_target.
    REPLACE '{sheetId}' WITH pa_sheet_id INTO lv_target.
    CONCATENATE lv_target ':copyTo'  INTO lv_target.




*lv_target = 'https://sheets.googleapis.com/v4/spreadsheets/1T8ApYlNVZdW7LlXLdeBIFqwn5Rf4fB0hfi63TU15jak/sheets/0:copyTo'.

*  CALL METHOD cl_fdt_json=>DATA_TO_JSON
*    exporting
*      IA_DATA = pa_request
*    receiving
*      RV_JSON = lv_req_string
    .

*lv_req_string = '{"destinationSpreadsheetId":''1XotQtwxiA9CdObItIJl37vHBC5YkGlv8UKkp6NDzcEU''}'.
    lv_req_string = /ui2/cl_json=>serialize( data = pa_request compress = abap_true pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).

    zcl_google_http_api=>send_post_request(
      EXPORTING
        ip_target          = lv_target
        ip_param_kind      =  'H'
*        PT_PARAM           =     " HTTP Framework (iHTTP) Table Name/Value Pairs
        ip_json_request    = lv_req_string
      IMPORTING
        ep_response_string =  lv_resp_string
    ).














  ENDMETHOD.
ENDCLASS.
