CLASS zif_gsheet_request DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES ztest_type TYPE zgsheet_batch_upd_resp_s .

    DATA gv_single_request TYPE zgsheet_request_s .

    METHODS constructor
      IMPORTING
        VALUE(p_type) TYPE any .
    METHODS send_request
      IMPORTING
        VALUE(ip_spreadsheet_id) TYPE string
        VALUE(ip_sheet_id)       TYPE string .
    METHODS add_request
      IMPORTING
        VALUE(ip_batch_req)           LIKE gv_single_request OPTIONAL
        VALUE(ip_batch_upd_value_req) TYPE zgsheet_batch_update_val_req_s OPTIONAL .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES requests_list_ty TYPE zgsheet_requests_s .
    TYPES request_ty TYPE zgsheet_request_s .
ENDCLASS.



CLASS ZIF_GSHEET_REQUEST IMPLEMENTATION.


  METHOD add_request.
*    IF ME->GV_REQUEST-REQUESTS IS NOT INITIAL.
*    APPEND IP_BATCH_REQ TO ME->GV_REQUEST-REQUESTS.
*    ENDIF.

  ENDMETHOD.


  METHOD constructor.

  ENDMETHOD.


  METHOD send_request.

*        ZCL_GSPREADSHEET_API=>BATCH_UPDATE(
*      exporting
*        IP_SPREADSHEET_ID = IP_SPREADSHEET_ID
*        IP_SHEET_ID       = IP_SHEET_ID
*        IP_BATCH_REQS      =    ME->GV_BATCH_REQUEST " Request structure for spreadsheet batchupdate
*    ).


*ZIF_GSHEET_REQ=>GV_REQUEST_LIST-DATA = 10.
  ENDMETHOD.
ENDCLASS.
