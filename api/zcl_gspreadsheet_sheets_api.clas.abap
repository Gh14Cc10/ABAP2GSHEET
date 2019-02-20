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
      !PA_REQUEST type ZGSHEET_COPY_REQ_S .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GSPREADSHEET_SHEETS_API IMPLEMENTATION.


  METHOD copy_sheet.

    DATA: lv_target      TYPE string,
          lt_param       TYPE tihttpnvp,
          lv_req_string  TYPE string,
          lv_resp_string TYPE string.
    lv_target = gc_endpoint_url.

    REPLACE '{spreadsheetId}' WITH pa_spreadsheet_id INTO lv_target.
    REPLACE '{sheetId}' WITH pa_sheet_id INTO lv_target.
    CONCATENATE lv_target ':copyTo'  INTO lv_target.





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
