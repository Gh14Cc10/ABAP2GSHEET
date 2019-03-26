*&---------------------------------------------------------------------*
*& Report ZGOOGLE_SHEETS_CHANGES
*&---------------------------------------------------------------------*
*& - New spreadsheet creation
*& - New sheet added to the same spreadsheet
*& - Newly created sheet immediately deleted
*& -
*& -
*&---------------------------------------------------------------------*
REPORT zgoogle_demo_add_sheet.

DATA: lo_spreadsheet_obj TYPE REF TO zcl_gspreadsheet,
      ls_spreadsheet     TYPE zgspreadsheet_s,
      lt_sheets          TYPE zgsheet_tt,
      ls_sheet           TYPE zgsheet_s,
      ls_batch_request   TYPE zgsheet_batch_update_req_s.



zcl_gspreadsheet_api=>create_new_spreadsheet(
  EXPORTING
    ip_spreadsheet_s =     ls_spreadsheet  " Google sheet object structure
  IMPORTING
    ep_spreadsheet   =     lo_spreadsheet_obj " Google sheet object structure
).


ls_spreadsheet = lo_spreadsheet_obj->get_abap_obj( ).

"Write the new spreadsheet url
WRITE ls_spreadsheet-spreadsheet_url.


*Add a new sheet inside the spreadsheet

ls_spreadsheet-properties-title = 'NewSpreadsheetTest'.
ls_sheet-properties-title = 'NewSheetToDelete'.
lo_spreadsheet_obj->add_sheet( ip_property =  ls_sheet-properties ).

lt_sheets = lo_spreadsheet_obj->get_sheets_list(
    pa_spreadsheet_id = ls_spreadsheet-spreadsheet_id
).
CLEAR ls_sheet.
LOOP AT lt_sheets INTO ls_sheet.
  IF ls_sheet-properties-title EQ 'NewSheetToDelete'.
    lo_spreadsheet_obj->delete_sheet( ip_sheet_id =  ls_sheet-properties-sheet_id ).
  ENDIF.
ENDLOOP.


WRITE ''.
