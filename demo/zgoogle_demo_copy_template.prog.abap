*&---------------------------------------------------------------------*
*& Report ZGOOGLE_DEMO_TEMPLATE
*&---------------------------------------------------------------------*
*& - Create a new spreadsheet from another
*&---------------------------------------------------------------------*
REPORT ZGOOGLE_DEMO_COPY_TEMPLATE.

DATA: ls_file_s type ZGDRIVE_FILE_S,
      lv_spreadsheet_json type string,
      ls_spreadsheet_s type zgSPREADSHEET_S,
      lv_html_link type string value '<a href=https://docs.google.com/spreadsheets/d/$1> https://docs.google.com/spreadsheets/d/$1 </a>'.

* Our template link:  https://docs.google.com/spreadsheets/d/1T8ApYlNVZdW7LlXLdeBIFqwn5Rf4fB0hfi63TU15jak/edit#gid=2048178854
* force to create a google sheeet


SELECTION-SCREEN: BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-001.
  selection-screen begin of line.
selection-screen comment (16) text-002.
PARAMETERS: p_url LIKE rlgrap-filename OBLIGATORY .
selection-screen END OF LINE.
SELECTION-SCREEN:END OF BLOCK bl1 .

REPLACE 'https://docs.google.com/spreadsheets/d/' IN p_url WITH ''.
REPLACE all OCCURRENCES OF REGEX '/.*' IN p_url WITH ''.

ls_spreadsheet_s-SPREADSHEET_ID = p_url.

ls_file_s-MIME_TYPE ='application/vnd.google-apps.spreadsheet'.
ls_file_s-NAME = 'sheet from teestt'.
ls_file_s-DESCRIPTION  = 'TestDescription'.





ZCL_GDRIVE_FILE_API=>COPY(
  exporting
    IP_SOURCE_SPREADSHEET_ID =  ls_spreadsheet_s-SPREADSHEET_ID
    IP_FILE                  =     ls_file_s" Google drive file structure
  importing
    EP_SPREADSHEET_JSON                = lv_spreadsheet_json    " Google drive file structure
).




ZCL_GOOGLE_HTTP_API=>ENCODE_JSON2ABAP(
  exporting
    IP_JSON      = lv_spreadsheet_json
  changing
    CP_ABAP_DATA = LS_FILE_S
).

REPLACE ALL OCCURRENCES OF '$1'IN lv_html_link WITH LS_FILE_S-iD.

cl_demo_output=>display_html( html = lv_html_link ).
