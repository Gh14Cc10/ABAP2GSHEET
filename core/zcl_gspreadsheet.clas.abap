class ZCL_GSPREADSHEET definition
  public
  final
  create public .

public section.

  methods SET_TITLE
    importing
      value(IP_TITLE) type STRING .
  methods CREATE_FROM_TEMPLATE
    importing
      value(PA_SOURCE_SPREADSHEET_ID) type STRING
      value(PA_SOURCE_SHEET_ID) type ZGSHEET_SHEET_ID optional
      value(PA_SOURCE_SHEET_NAME) type STRING optional .
  methods UPDATE_ABAP
    exporting
      value(PA_SPREADSHEET) type ZGSPREADSHEET_S .
  methods GET_JSON
    returning
      value(P_GSHEET_JSON) type STRING .
  methods SET_JSON
    importing
      value(P_GSHEET_JSON) type STRING .
  methods REPEAT_CELL
    importing
      !IP_SHEET_ID type STRING
      !IP_SPREADSHEET_ID type STRING .
  methods ADD_SHEET
    importing
      value(IP_PROPERTY) type ZGSHEET_PROPERTY_S .
  methods DELETE_SHEET
    importing
      value(IP_SHEET_ID) type STRING .
  methods GET_SHEETS_LIST
    importing
      value(PA_SPREADSHEET_ID) type STRING optional
    returning
      value(PA_SHEETS_LIST) type ZGSHEET_TT .
  methods GET_ABAP_OBJ
    returning
      value(PA_SPREADSHEET_OBJ) type ZGSPREADSHEET_S .
protected section.
private section.

  data GV_JSON_STRING type STRING .
  data GS_ABAP_SPREADSHEET type ZGSPREADSHEET_S .

  methods UPDATE_SPREADSHEET_PROPERTIES .
  methods UPDATE_SHEET_PROPERTIES .
  methods UPDATE_DIMENSION_PROPERTIES .
  methods UPDATE_NAMED_RANGE .
  methods ADD_NAMED_RANGE .
  methods DELETE_NAMED_RANGE .
  methods AUTO_FILL .
  methods CUT_PASTE .
  methods COPY_PASTE .
  methods MERGE_CELLS .
  methods UNMERGE_CELLS .
  methods UPDATE_BORDERS .
  methods UPDATE_CELLS .
  methods ADD_FILTER_VIEW .
  methods APPEND_CELLS .
  methods CLEAR_BASIC_FILTER .
  methods DELETE_DIMENSION .
  methods DELETE_EMBEDDED_OBJECT .
  methods DELETE_FILTERVIEW .
  methods DUPLICATE_FILTERVIEW .
  methods DUPLICATE_SHEET .
  methods FIND_REPLACE .
  methods INSERT_DIMENSION .
  methods INSERT_RANGE .
  methods MOVE_DIMENSION .
  methods UPDATE_EMBEDDED_OBJ_POSITION .
  methods PASTE_DATA .
  methods TEXT_TO_COLUMNS .
  methods UPDATE_FILTER_VIEW .
  methods DELETE_RANGE .
  methods APPEND_DIMENSION .
ENDCLASS.



CLASS ZCL_GSPREADSHEET IMPLEMENTATION.


  method ADD_FILTER_VIEW.
  endmethod.


  method ADD_NAMED_RANGE.
  endmethod.


method ADD_SHEET.


  DATA: ls_request_batch  type ZGSHEET_BATCH_UPDATE_REQ_S,

        lv_batch_req_obj  type ref to ZCL_GSHEET_BATCH_REQ,

        lv_spreadsheet_id type string.
  lv_spreadsheet_id =  me->GS_ABAP_SPREADSHEET-SPREADSHEET_ID.

  CREATE OBJECT lv_batch_req_obj type ZCL_GSHEET_BATCH_REQ.



  CLEAR ls_request_batch.
  ls_request_batch-ADD_SHEET-PROPERTIES = IP_PROPERTY.



  lv_batch_req_obj->ADD_REQUEST( IP_BATCH_REQ = ls_request_batch  ).
  lv_batch_req_obj->SEND_REQUEST(
    exporting
      IP_SPREADSHEET_ID =  lv_spreadsheet_id
*      IP_SHEET_ID       = ip_sheet_ID
  ).

endmethod.


  method APPEND_CELLS.
  endmethod.


  method APPEND_DIMENSION.
  endmethod.


  method AUTO_FILL.
  endmethod.


  method CLEAR_BASIC_FILTER.
  endmethod.


  method COPY_PASTE.
  endmethod.


  method CREATE_FROM_TEMPLATE.

    DATA: LV_REQUEST          TYPE ZGSHEET_COPY_REQ_S,
*          LV_GSPREADSHEETS_API TYPE REF TO ZCL_GSPREADSHEET_API,
*          LV_GSHEETS_API      TYPE REF TO  ZCL_GSPREADSHEET_SHEETS_API,
          LT_SRC_SHEETS_LIST  TYPE ZGSHEET_TT,
          LS_SRC_SHEET        TYPE ZGSHEET_S,
          LS_GSPREADSHEET     TYPE ZGSPREADSHEET_S,
          LV_GSPREADSHEET_OBJ TYPE REF TO  ZCL_GSPREADSHEET.

*    CREATE OBJECT:
*          LS_GSPREADSHEET TYPE ZCL_GSPREADSHEET_API,
*          LV_GSHEETS_API TYPE ZCL_GSPREADSHEET_SHEETS_API.

***Create new empty spreadsheet***

    ZCL_GSPREADSHEET_API=>CREATE_NEW_SPREADSHEET(
*      exporting
*        IP_SPREADSHEET_S =     " Google spreadsheet  structure to create
      importing
        EP_SPREADSHEET   =     LV_GSPREADSHEET_OBJ " Google spreadsheet class instance
    ).







    ME->SET_JSON( P_GSHEET_JSON =  LV_GSPREADSHEET_OBJ->get_json( ) ).
    LS_GSPREADSHEET  = LV_GSPREADSHEET_OBJ->get_abap_obj( ).
    CLEAR LV_GSPREADSHEET_OBJ.
    LT_SRC_SHEETS_LIST  = ME->GET_SHEETS_LIST( PA_SPREADSHEET_ID =   PA_SOURCE_SPREADSHEET_ID ).

    LV_REQUEST-DESTINATION_SPREADSHEET_ID = LS_GSPREADSHEET-SPREADSHEET_ID.

*** Looop all the sheets:

    LOOP AT LT_SRC_SHEETS_LIST INTO  LS_SRC_SHEET.


      ZCL_GSPREADSHEET_SHEETS_API=>COPY_SHEET(
       exporting
         PA_SPREADSHEET_ID =  PA_SOURCE_SPREADSHEET_ID
         PA_SHEET_ID       =  LS_SRC_SHEET-PROPERTIES-SHEET_ID
         PA_REQUEST        = LV_REQUEST " Copy to Action request structure
     ).

    ENDLOOP.
  endmethod.


  method CUT_PASTE.
  endmethod.


  method DELETE_DIMENSION.
  endmethod.


  method DELETE_EMBEDDED_OBJECT.
  endmethod.


  method DELETE_FILTERVIEW.
  endmethod.


  method DELETE_NAMED_RANGE.
  endmethod.


  method DELETE_RANGE.
  endmethod.


  method DELETE_SHEET.

    DATA:    ls_request_batch  type ZGSHEET_BATCH_UPDATE_REQ_S,

    lv_batch_req_obj  type ref to ZCL_GSHEET_BATCH_REQ,

    lv_spreadsheet_id type string.
    lv_spreadsheet_id =  me->GS_ABAP_SPREADSHEET-SPREADSHEET_ID.

    CREATE OBJECT lv_batch_req_obj type ZCL_GSHEET_BATCH_REQ.



    CLEAR ls_request_batch.
    ls_request_batch-DELETE_SHEET-SHEET_ID = IP_SHEET_ID.


    lv_batch_req_obj->ADD_REQUEST( IP_BATCH_REQ = ls_request_batch  ).
    lv_batch_req_obj->SEND_REQUEST(
      exporting
        IP_SPREADSHEET_ID =  lv_spreadsheet_id
*        IP_SHEET_ID       = ip_sheet_ID
    ).
  endmethod.


  method DUPLICATE_FILTERVIEW.
  endmethod.


  method DUPLICATE_SHEET.
  endmethod.


  method FIND_REPLACE.
  endmethod.


  method GET_ABAP_OBJ.

    PA_SPREADSHEET_OBJ = ME->GS_ABAP_SPREADSHEET.
  endmethod.


  method GET_JSON.

  p_gsheet_json = me->GV_JSON_STRING.
  endmethod.


  method GET_SHEETS_LIST.

    DATA: ls_spreadsheet Type ZGSPREADSHEET_S,
          lv_sheet type  ZGSHEET_S.


    ls_spreadsheet  = ZCL_GSPREADSHEET_API=>GET_SPREADSHEET(
                      PA_SPREADSHEET_ID = me->GS_ABAP_SPREADSHEET-SPREADSHEET_ID

                  ).
*
*
*                   GET_SPREADSHEET( PA_SPREADSHEET_ID = PA_SPREADSHEET_ID  ).

LOOP AT  ls_spreadsheet-SHEETS INTO lv_sheet.
WRITE lv_sheet-PROPERTIES-SHEET_ID.
WRITE lv_sheet-PROPERTIES-TITLE.
ENDLOOP.

    PA_SHEETS_LIST = ls_spreadsheet-SHEETS.
  endmethod.


  method INSERT_DIMENSION.
  endmethod.


  method INSERT_RANGE.
  endmethod.


  method MERGE_CELLS.
  endmethod.


  method MOVE_DIMENSION.
  endmethod.


  method PASTE_DATA.
  endmethod.


  method REPEAT_CELL.

  DATA: ls_request_s type zgsheet_batch_update_reqs_s,
       lt_list_request type   ZGSHEET_BATCH_UPDATE_REQS_TT ,
       ls_batch_request type ZGSHEET_BATCH_UPDATE_REQ_S.

*lv_reqUpdate =
* '{"requests":[{"repeatCell":{"range":{"sheetId":357392262,"startColumnIndex":1,"endColumnIndex":10,"startRowIndex":0,"endRowIndex":2},"fields":"*",
* "cell":{"userEnteredValue":{"numberValue":27}}}}],"responseIncludeGridData":true}'.


LS_BATCH_REQUEST-REPEAT_CELL-range-sheet_Id =  IP_SHEET_ID.
LS_BATCH_REQUEST-REPEAT_CELL-range-START_COLUMN_INDEX = 1.
LS_BATCH_REQUEST-REPEAT_CELL-range-END_COLUMN_INDEX = 10.
LS_BATCH_REQUEST-REPEAT_CELL-range-START_ROW_INDEX  = 0.
LS_BATCH_REQUEST-REPEAT_CELL-range-END_ROW_INDEX =  2.
LS_BATCH_REQUEST-REPEAT_CELL-FIELDS = '*'.
LS_BATCH_REQUEST-REPEAT_CELL-CELL-USER_ENTERED_VALUE-NUMBER_VALUE = 28.
APPEND LS_BATCH_REQUEST TO lt_list_request.
 ls_request_s-REQUESTS = lt_list_request.

    ZCL_GSPREADSHEET_API=>BATCH_UPDATE(
      exporting
        IP_SPREADSHEET_ID = IP_SPREADSHEET_ID
*        IP_SHEET_ID       = IP_SHEET_ID
        IP_BATCH_REQS      =    ls_request_s  " Request structure for spreadsheet batchupdate
    ).
  endmethod.


  method SET_JSON.

    me->GV_JSON_STRING = p_gsheet_json.
*** Update internal structure that modelize the spreadsheet
    me->UPDATE_ABAP( ).

  endmethod.


  method SET_TITLE.

    ME->GS_ABAP_SPREADSHEET-PROPERTIES-TITLE = IP_TITLE.
  endmethod.


  method TEXT_TO_COLUMNS.
  endmethod.


  method UNMERGE_CELLS.
  endmethod.


  method UPDATE_ABAP.

/ui2/cl_json=>deserialize( EXPORTING json = ME->GV_JSON_STRING pretty_name = /ui2/cl_json=>pretty_mode-camel_case CHANGING data = PA_SPREADSHEET ).
ME->GS_ABAP_SPREADSHEET = PA_SPREADSHEET.


  endmethod.


  method UPDATE_BORDERS.
  endmethod.


  method UPDATE_CELLS.
  endmethod.


  method UPDATE_DIMENSION_PROPERTIES.
  endmethod.


  method UPDATE_EMBEDDED_OBJ_POSITION.
  endmethod.


  method UPDATE_FILTER_VIEW.
  endmethod.


  method UPDATE_NAMED_RANGE.
  endmethod.


  method UPDATE_SHEET_PROPERTIES.
  endmethod.


  method UPDATE_SPREADSHEET_PROPERTIES.
  endmethod.
ENDCLASS.
