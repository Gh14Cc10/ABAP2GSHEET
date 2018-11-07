*&---------------------------------------------------------------------*
*& Report ZGOOGLE_DEMO_DOWNLAD_TABLE
*&---------------------------------------------------------------------*
*& Download the cell valu content of a google spreadsheet link to copy
*& into a database table
*& p_url: Spreadsheeet link
*& p_range: Range of cells to read the header row from the spreadsheet
*& p_head: Range of cells to read the value rows the the spreadsheet
*&
*&---------------------------------------------------------------------*
REPORT ZGOOGLE_DEMO_DOWNLOAD_GSHEET.

"Da usare con qualsiasi excel che abbia una tabella
*https://docs.google.com/spreadsheets/d/15iWsHbq7Y6JK1RTZD0EGkmxjB_L1u_WXdbiJp9y2rlI/edit#gid=0



DATA: lv_spreadsheet_id type string,
      lt_range_read     type zgsheet_string_tt.



SELECTION-SCREEN: BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-001.

selection-screen begin of line.
selection-screen comment (16) text-002.
selection-screen END OF LINE.

selection-screen begin of line.
PARAMETERS: p_url type string OBLIGATORY LOWER CASE.
selection-screen END OF LINE.

selection-screen begin of line.
selection-screen comment (16) text-012.
selection-screen END OF LINE.

selection-screen begin of line.
selection-screen comment (16) text-013.
selection-screen END OF LINE.

selection-screen begin of line.
PARAMETERS: p_range type string OBLIGATORY LOWER CASE DEFAULT 'C1'.
selection-screen END OF LINE.

selection-screen begin of line.
selection-screen comment (16) text-014.
PARAMETERS: p_head  type string OBLIGATORY LOWER CASE DEFAULT 'B1'.
selection-screen END OF LINE.

SELECTION-SCREEN:END OF BLOCK bl1 .


lv_spreadsheet_id =  ZCL_GSHEET_UTILITY=>EXTRACT_SPREADSHEET_ID( ip_url = p_url ).


DATA ls_valueRange type ZGSHEET_VALUE_RANGES_S.
DATA ls_header_field type ZGSHEET_VALUE_RANGES_S.

DATA ls_table_structure TYPE  ZGDEMO_WRITABLE.
DATA lt_table_data type TABLE OF ZGDEMO_WRITABLE.


*DATA ls_line  type string.
DATA lt_values_rows type ZGSHEET_ARRAY_STRING_TT.
DATA lt_values_row_values type ZGSHEET_STRING_TT.


*header data
DATA lt_headers_rows  type ZGSHEET_ARRAY_STRING_TT.
DATA lt_header_fields   type ZGSHEET_STRING_TT.

*
DATA lv_value_row type string.



FIELD-SYMBOLS <gv_fieldvalue> TYPE ANY.
DATA lv_fieldname type string.

*read value range
LS_VALUERANGE = ZCL_GSPREADSHEET_VALUES_API=>GET(
  exporting
    IP_SPREADSHEET_ID = lv_spreadsheet_id
    IP_RANGE          = p_range
).
*Read table lines
lt_values_rows =  LS_VALUERANGE-VALUES.


*read header range
ls_header_field = ZCL_GSPREADSHEET_VALUES_API=>GET(
  exporting
    IP_SPREADSHEET_ID = lv_spreadsheet_id
    IP_RANGE          = p_head
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
INSERT ZGDEMO_WRITABLE FROM TABLE lt_table_data.



*DELETE FROM ZGDEMO_WRITABLE
*WHERE 1 = 1.
