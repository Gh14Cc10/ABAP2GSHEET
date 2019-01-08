CLASS zcl_gsheet_batch_req DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA gv_batch_request TYPE zgsheet_batch_update_reqs_s .

    METHODS send_request
      IMPORTING
        VALUE(ip_spreadsheet_id) TYPE string .
    METHODS add_request
      IMPORTING
        VALUE(ip_batch_req)           TYPE zgsheet_batch_update_req_s OPTIONAL
        VALUE(ip_batch_upd_value_req) TYPE zgsheet_batch_update_val_req_s OPTIONAL .
  PROTECTED SECTION.
  PRIVATE SECTION.


ENDCLASS.



CLASS ZCL_GSHEET_BATCH_REQ IMPLEMENTATION.


  METHOD add_request.

    APPEND ip_batch_req TO me->gv_batch_request-requests.

  ENDMETHOD.


  METHOD send_request.

    zcl_gspreadsheet_api=>batch_update(
  EXPORTING
    ip_spreadsheet_id = ip_spreadsheet_id
*        IP_SHEET_ID       = IP_SHEET_ID
    ip_batch_reqs      =    me->gv_batch_request " Request structure for spreadsheet batchupdate
).
  ENDMETHOD.
ENDCLASS.
