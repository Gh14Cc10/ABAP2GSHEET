*&---------------------------------------------------------------------*
*& Report ZGOOGLE_SHEETS_CHANGES
*&---------------------------------------------------------------------*
*& - New spreadsheet creation
*& - New sheet add to the same spreadsheet
*& -  Newly created sheet immediately deleted
*& -
*& -
*&---------------------------------------------------------------------*
REPORT ZGOOGLE_DEMO_ADD_SHEET.

   DATA:  lo_spreadsheet_obj type ref to ZCL_GSPREADSHEET,
      ls_spreadsheet type ZGSPREADSHEET_S,
      lt_sheets type ZGSHEET_TT,
      ls_sheet type ZGSHEET_S,
      ls_batch_request type ZGSHEET_BATCH_UPDATE_REQ_S.




*ls_spreadsheet-SHEETS
APPEND ls_sheet TO  lt_sheets.


ZCL_GSPREADSHEET_API=>CREATE_NEW_SPREADSHEET(
  exporting
    IP_SPREADSHEET_S =     ls_spreadsheet  " Google sheet object structure
  importing
    EP_SPREADSHEET   =     lo_spreadsheet_obj " Google sheet object structure
).


 ls_spreadsheet = LO_SPREADSHEET_OBJ->GET_ABAP_OBJ( ).
 WRITE ls_spreadsheet-SPREADSHEET_URL.


*Add a new  sheet
ls_spreadsheet-PROPERTIES-TITLE = 'NewSpreadsheetTest'.
ls_sheet-PROPERTIES-title = 'NewSheetToDelete'.
lo_spreadsheet_obj->ADD_SHEET( IP_PROPERTY =  ls_sheet-PROPERTIES ).

lt_sheets = lo_spreadsheet_obj->GET_SHEETS_LIST(
*    PA_SPREADSHEET_ID =
).
CLEAR ls_sheet.
LOOP AT lt_sheets INTO LS_SHEET.
IF LS_SHEET-PROPERTIES-TITLE EQ 'NewSheetToDelete'.
  lo_spreadsheet_obj->DELETE_SHEET( IP_SHEET_ID =  LS_SHEET-PROPERTIES-SHEET_ID ).
ENDIF.
ENDLOOP.


WRITE ''.
