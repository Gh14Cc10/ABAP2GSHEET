class ZCL_GSHEET_BATCH_REQ definition
  public
  final
  create public .

public section.

  data GV_BATCH_REQUEST type ZGSHEET_BATCH_UPDATE_REQS_S .

  methods CONSTRUCTOR .
  methods SEND_REQUEST
    importing
      !IP_SPREADSHEET_ID type STRING .
  methods ADD_REQUEST
    importing
      !IP_BATCH_REQ type ZGSHEET_BATCH_UPDATE_REQ_S optional
      !IP_BATCH_UPD_VALUE_REQ type ZGSHEET_BATCH_UPDATE_VAL_REQ_S optional .
  PROTECTED SECTION.
  PRIVATE SECTION.


ENDCLASS.



CLASS ZCL_GSHEET_BATCH_REQ IMPLEMENTATION.


  METHOD add_request.

    APPEND ip_batch_req TO me->gv_batch_request-requests.

  ENDMETHOD.


  method CONSTRUCTOR.
  endmethod.


  METHOD send_request.

    zcl_gspreadsheet_api=>batch_update(
    EXPORTING
    ip_spreadsheet_id = ip_spreadsheet_id
    ip_batch_reqs      =    me->gv_batch_request " Request structure for spreadsheet batchupdate
).
  ENDMETHOD.
ENDCLASS.
