class ZCL_GSHEET_BATCH_REQ definition
  public
  final
  create public .

public section.

  data GV_BATCH_REQUEST type ZGSHEET_BATCH_UPDATE_REQS_S .

  methods SEND_REQUEST
    importing
      value(IP_SPREADSHEET_ID) type STRING .
  methods ADD_REQUEST
    importing
      value(IP_BATCH_REQ) type ZGSHEET_BATCH_UPDATE_REQ_S optional
      value(IP_BATCH_UPD_VALUE_REQ) type ZGSHEET_BATCH_UPDATE_VAL_REQ_S optional .
protected section.
private section.


ENDCLASS.



CLASS ZCL_GSHEET_BATCH_REQ IMPLEMENTATION.


  method ADD_REQUEST.

    APPEND IP_BATCH_REQ TO ME->GV_BATCH_REQUEST-REQUESTS.

  endmethod.


  method SEND_REQUEST.

        ZCL_GSPREADSHEET_API=>BATCH_UPDATE(
      exporting
        IP_SPREADSHEET_ID = IP_SPREADSHEET_ID
*        IP_SHEET_ID       = IP_SHEET_ID
        IP_BATCH_REQS      =    ME->GV_BATCH_REQUEST " Request structure for spreadsheet batchupdate
    ).
  endmethod.
ENDCLASS.
