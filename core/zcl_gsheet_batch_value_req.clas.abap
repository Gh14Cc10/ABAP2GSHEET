CLASS zcl_gsheet_batch_value_req DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA gv_requests TYPE zgsheet_batch_upd_val_reqs_s .
    DATA gv_single_request TYPE zgsheet_batch_update_val_req_s .

    METHODS add_request
      IMPORTING
        !ip_request TYPE any .
    METHODS send_request
      IMPORTING
        !ip_spreadsheet_id TYPE string
        !ip_sheet_id       TYPE string .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GSHEET_BATCH_VALUE_REQ IMPLEMENTATION.


  METHOD add_request.

    me->gv_single_request = ip_request.
    APPEND ip_request TO me->gv_requests-requests.

  ENDMETHOD.


  METHOD send_request.

    zcl_gspreadsheet_values_api=>batch_update(
    EXPORTING
     ip_spreadsheet_id = ip_spreadsheet_id
     ip_sheet_id       = ip_sheet_id
     ip_batch_req     =    me->gv_single_request" Request structure for spreadsheet batchupdate
).
  ENDMETHOD.
ENDCLASS.
