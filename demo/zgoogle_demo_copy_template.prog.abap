*&---------------------------------------------------------------------*
*& Report ZGOOGLE_DEMO_TEMPLATE
*&---------------------------------------------------------------------*
*& - Create a new spreadsheet from another
*&---------------------------------------------------------------------*
REPORT zgoogle_demo_copy_template.

DATA: ls_file_s           TYPE zgdrive_file_s,
      lv_spreadsheet_json TYPE string,
      ls_spreadsheet_s    TYPE zgspreadsheet_s,
      lv_html_link        TYPE string VALUE '<a href=https://docs.google.com/spreadsheets/d/$1> https://docs.google.com/spreadsheets/d/$1 </a>'. ##NO_TEXT

* Our template link:  https://docs.google.com/spreadsheets/d/1T8ApYlNVZdW7LlXLdeBIFqwn5Rf4fB0hfi63TU15jak/edit#gid=2048178854
* force to create a google sheeet


SELECTION-SCREEN: BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-001.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (16) TEXT-002.
PARAMETERS: p_url LIKE rlgrap-filename OBLIGATORY .
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN:END OF BLOCK bl1 .

REPLACE 'https://docs.google.com/spreadsheets/d/' IN p_url WITH ''.
REPLACE ALL OCCURRENCES OF REGEX '/.*' IN p_url WITH ''.

ls_spreadsheet_s-spreadsheet_id = p_url.

ls_file_s-mime_type ='application/vnd.google-apps.spreadsheet'. ##NO_TEXT
ls_file_s-name = 'sheet from teestt'. ##NO_TEXT
ls_file_s-description  = 'TestDescription'. ##NO_TEXT





zcl_gdrive_file_api=>copy(
  EXPORTING
    ip_source_spreadsheet_id =  ls_spreadsheet_s-spreadsheet_id
    ip_file                  =     ls_file_s" Google drive file structure
  IMPORTING
    ep_spreadsheet_json                = lv_spreadsheet_json    " Google drive file structure
).




zcl_google_http_api=>encode_json2abap(
  EXPORTING
    ip_json      = lv_spreadsheet_json
  CHANGING
    cp_abap_data = ls_file_s
).

REPLACE ALL OCCURRENCES OF '$1'IN lv_html_link WITH ls_file_s-id.

cl_demo_output=>display_html( html = lv_html_link ).
