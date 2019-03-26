*&---------------------------------------------------------------------*
*& Report ZGOOGLE_DEMO_DOWNLAD_TABLE
*&---------------------------------------------------------------------*
*& Download the cell valu content of a google spreadsheet link to copy
*& into a database table
*& p_url: Spreadsheeet link that must contain a table
*& p_range: Range of cells to read the header row from the spreadsheet
*& p_head: Range of cells to read the value rows the the spreadsheet
*&
*&---------------------------------------------------------------------*
REPORT zgoogle_demo_download_gsheet.

"i.e. spreadsheet
*https://docs.google.com/spreadsheets/d/15iWsHbq7Y6JK1RTZD0EGkmxjB_L1u_WXdbiJp9y2rlI/edit#gid=0



DATA: lv_spreadsheet_id TYPE string,
      lt_range_read     TYPE zgsheet_string_tt.



SELECTION-SCREEN: BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-001.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (16) TEXT-002.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_url TYPE string OBLIGATORY LOWER CASE.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (16) TEXT-013.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_range TYPE string OBLIGATORY LOWER CASE DEFAULT 'C1'.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (16) TEXT-014.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_head  TYPE string OBLIGATORY LOWER CASE DEFAULT 'B1'.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN:END OF BLOCK bl1 .


lv_spreadsheet_id =  zcl_gsheet_utility=>extract_spreadsheet_id( ip_url = p_url ).


DATA ls_valuerange TYPE zgsheet_value_ranges_s.
DATA ls_header_field TYPE zgsheet_value_ranges_s.

DATA ls_table_structure TYPE  zgdemo_writable.
DATA lt_table_data TYPE TABLE OF zgdemo_writable.


*DATA ls_line  type string.
DATA lt_values_rows TYPE zgsheet_array_string_tt.
DATA lt_values_row_values TYPE zgsheet_string_tt.


*header data
DATA lt_headers_rows  TYPE zgsheet_array_string_tt.
DATA lt_header_fields   TYPE zgsheet_string_tt.

*
DATA lv_value_row TYPE string.



FIELD-SYMBOLS <gv_fieldvalue> TYPE any.
DATA lv_fieldname TYPE string.

*read value range
ls_valuerange = zcl_gspreadsheet_values_api=>get(
  EXPORTING
    ip_spreadsheet_id = lv_spreadsheet_id
    ip_range          = p_range
).
*Read table lines
lt_values_rows =  ls_valuerange-values.


*read header range
ls_header_field = zcl_gspreadsheet_values_api=>get(
  EXPORTING
    ip_spreadsheet_id = lv_spreadsheet_id
    ip_range          = p_head
).

lt_headers_rows  = ls_header_field-values.


READ TABLE lt_headers_rows INDEX 1 INTO lt_header_fields.


LOOP AT  lt_values_rows  INTO lt_values_row_values.

  LOOP AT  lt_values_row_values  INTO  lv_value_row.

    READ TABLE lt_header_fields INDEX sy-tabix INTO lv_fieldname.
    ASSIGN COMPONENT lv_fieldname OF STRUCTURE ls_table_structure TO <gv_fieldvalue>.
    <gv_fieldvalue> =  lv_value_row.

*READ TABLE ls_string_internal_tt WITH TABLE KEY  INTO ls_string_internal_tt INDEX 1.
  ENDLOOP.
  APPEND ls_table_structure TO lt_table_data.

ENDLOOP.

*WRITING DATABASE table
INSERT zgdemo_writable FROM TABLE lt_table_data.



*DELETE FROM ZGDEMO_WRITABLE
*WHERE 1 = 1.
