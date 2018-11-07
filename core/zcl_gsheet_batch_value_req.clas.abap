class ZCL_GSHEET_BATCH_VALUE_REQ definition
  public
  final
  create public .

public section.

  data GV_REQUESTS type ZGSHEET_BATCH_UPD_VAL_REQS_S .
  data GV_SINGLE_REQUEST type ZGSHEET_BATCH_UPDATE_VAL_REQ_S .

  methods ADD_REQUEST
    importing
      !IP_REQUEST type ANY .
  methods SEND_REQUEST
    importing
      !IP_SPREADSHEET_ID type STRING
      !IP_SHEET_ID type STRING .
protected section.
private section.
ENDCLASS.



CLASS ZCL_GSHEET_BATCH_VALUE_REQ IMPLEMENTATION.


  method ADD_REQUEST.
     ME->GV_SINGLE_REQUEST = IP_REQUEST.
      APPEND IP_REQUEST TO ME->GV_REQUESTS-REQUESTS.

  endmethod.


  method SEND_REQUEST.

        ZCL_GSPREADSHEET_VALUES_API=>BATCH_UPDATE(
      exporting
        IP_SPREADSHEET_ID = IP_SPREADSHEET_ID
        IP_SHEET_ID       = IP_SHEET_ID
        IP_BATCH_REQ     =    ME->GV_SINGLE_REQUEST" Request structure for spreadsheet batchupdate
    ).
  endmethod.
ENDCLASS.
