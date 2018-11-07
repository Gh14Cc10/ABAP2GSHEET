class ZIF_GSHEET_REQUEST definition
  public
  final
  create public .

public section.

  types ZTEST_TYPE type ZGSHEET_BATCH_UPD_RESP_S .

  data GV_SINGLE_REQUEST type ZGSHEET_REQUEST_S .

  methods CONSTRUCTOR
    importing
      value(P_TYPE) type ANY .
  methods SEND_REQUEST
    importing
      value(IP_SPREADSHEET_ID) type STRING
      value(IP_SHEET_ID) type STRING .
  methods ADD_REQUEST
    importing
      value(IP_BATCH_REQ) like GV_SINGLE_REQUEST optional
      value(IP_BATCH_UPD_VALUE_REQ) type ZGSHEET_BATCH_UPDATE_VAL_REQ_S optional .
protected section.
private section.

  types REQUESTS_LIST_TY type ZGSHEET_REQUESTS_S .
  types REQUEST_TY type ZGSHEET_REQUEST_S .
ENDCLASS.



CLASS ZIF_GSHEET_REQUEST IMPLEMENTATION.


  method ADD_REQUEST.
*    IF ME->GV_REQUEST-REQUESTS IS NOT INITIAL.
*    APPEND IP_BATCH_REQ TO ME->GV_REQUEST-REQUESTS.
*    ENDIF.

  endmethod.


  method CONSTRUCTOR.

  endmethod.


  method SEND_REQUEST.

*        ZCL_GSPREADSHEET_API=>BATCH_UPDATE(
*      exporting
*        IP_SPREADSHEET_ID = IP_SPREADSHEET_ID
*        IP_SHEET_ID       = IP_SHEET_ID
*        IP_BATCH_REQS      =    ME->GV_BATCH_REQUEST " Request structure for spreadsheet batchupdate
*    ).


*ZIF_GSHEET_REQ=>GV_REQUEST_LIST-DATA = 10.
  endmethod.
ENDCLASS.
