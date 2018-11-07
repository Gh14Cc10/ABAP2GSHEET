class ZCL_GSPREADSHEET_SHEETS_API definition
  public
  inheriting from ZCL_GOOGLE_HTTP_API
  final
  create public .

public section.

  constants GC_ENDPOINT_URL type STRING value 'https://sheets.googleapis.com/v4/spreadsheets/{spreadsheetId}/sheets/{sheetId}' ##NO_TEXT.

  class-methods COPY_SHEET
    importing
      !PA_SPREADSHEET_ID type STRING
      !PA_SHEET_ID type ZGSHEET_SHEET_ID
      value(PA_REQUEST) type ZGSHEET_COPY_REQ_S .
protected section.
private section.
ENDCLASS.



CLASS ZCL_GSPREADSHEET_SHEETS_API IMPLEMENTATION.


  method COPY_SHEET.

    DATA: lv_target    TYPE string,
*          LV_GHTTP        TYPE REF TO  ZCL_GOOGLE_HTTP_API,
          lt_param     TYPE tihttpnvp,
          lv_req_string type string,
          lv_resp_string      TYPE string.
*    CREATE OBJECT LV_GHTTP TYPE ZCL_GOOGLE_HTTP_API.

    lv_target = GC_ENDPOINT_URL.

    REPLACE '{spreadsheetId}' WITH PA_SPREADSHEET_ID INTO lv_target.
    REPLACE '{sheetId}' WITH PA_SHEET_ID INTO lv_target.
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

    ZCL_GOOGLE_HTTP_API=>SEND_POST_REQUEST(
      exporting
        IP_TARGET          = lv_target
        IP_PARAM_KIND      =  'H'
*        PT_PARAM           =     " HTTP Framework (iHTTP) Table Name/Value Pairs
        IP_JSON_REQUEST    = lv_req_string
      importing
        EP_RESPONSE_STRING =  lv_resp_string
    ).














  endmethod.
ENDCLASS.
