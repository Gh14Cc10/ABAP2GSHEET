*&---------------------------------------------------------------------*
*& Report ZGOOGLE_DEMO_LIVE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgoogle_demo_mb51.

SELECTION-SCREEN: BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-002.





SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (17) TEXT-004.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_title TYPE string OBLIGATORY LOWER CASE.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (16) TEXT-005.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_vari TYPE c LENGTH 16 OBLIGATORY LOWER CASE DEFAULT 'GSHEET_VAR'.
SELECTION-SCREEN END OF LINE.



SELECTION-SCREEN:END OF BLOCK bl1 .






DATA lr_alv_data  TYPE REF TO data.



*
DATA: lt_values      TYPE zgsheet_array_string_tt,
      lt_value       LIKE LINE OF lt_values,
      lv_value_range TYPE zgsheet_value_ranges_s.



DATA: lv_column_n      TYPE int3,
      ls_request_batch TYPE zgsheet_batch_update_req_s.

DATA: lv_batch_req_obj   TYPE REF TO zcl_gsheet_batch_req,
      lv_spreadsheet_obj TYPE REF TO zcl_gspreadsheet,
      ls_spreadsheet     TYPE zgspreadsheet_s.

FIELD-SYMBOLS <ft_alv_data>   TYPE ANY TABLE.
FIELD-SYMBOLS <fs_line>   TYPE any.
FIELD-SYMBOLS <fs_field>   TYPE any.




cl_salv_bs_runtime_info=>set(
  EXPORTING display  = abap_false
            metadata = abap_true
            data     = abap_true ).


* Submit Report
SUBMIT rm07docs  "#EC CI_SUBMIT
  USING SELECTION-SET p_vari
  AND RETURN.
*Reading ALV from memory
TRY.

    cl_salv_bs_runtime_info=>get_data_ref(
      IMPORTING
        r_data                     = lr_alv_data
    ).

    ASSIGN lr_alv_data->* TO <ft_alv_data>.

    DATA:
      lo_tabledescr TYPE REF TO cl_abap_tabledescr,
      lt_keyfields  TYPE abap_keydescr_tab,
      ls_column     TYPE abap_keydescr,
      lv_col_name   TYPE c LENGTH 30.


    .
  CATCH cx_salv_bs_sc_runtime_info.
    MESSAGE TExT-031 TYPE 'E'.
ENDTRY.
*Clear memory
cl_salv_bs_runtime_info=>clear_all( ).




*--------



CREATE OBJECT lv_batch_req_obj TYPE zcl_gsheet_batch_req.

*Set spreadsheet title
ls_spreadsheet-properties-title = p_title.



*Google spreadsheet creation on google drive
zcl_gspreadsheet_api=>create_new_spreadsheet(
  EXPORTING
    ip_spreadsheet_s =     ls_spreadsheet  " Google sheet object structure
  IMPORTING
    ep_spreadsheet   =     lv_spreadsheet_obj " Google sheet object structure
).
CLEAR ls_spreadsheet.
*Retrieve the spreadsheet created
ls_spreadsheet = lv_spreadsheet_obj->get_abap_obj( ).







*Label for the header line

APPEND TEXT-007 TO lt_value.
APPEND TEXT-008 TO lt_value.
APPEND TEXT-009 TO lt_value.
APPEND TEXT-010 TO lt_value.
APPEND TEXT-011 TO lt_value.
APPEND TEXT-012 TO lt_value.
APPEND TEXT-013 TO lt_value.
APPEND TEXT-014 TO lt_value.
APPEND TEXT-015 TO lt_value.
APPEND TEXT-016 TO lt_value.
APPEND TEXT-017 TO lt_value.
APPEND TEXT-018 TO lt_value.
APPEND TEXT-019 TO lt_value.
APPEND TEXT-020 TO lt_value.
APPEND TEXT-021 TO lt_value.
APPEND TEXT-022 TO lt_value.
APPEND TEXT-023 TO lt_value.
APPEND TEXT-024 TO lt_value.
APPEND TEXT-025 TO lt_value.
APPEND TEXT-026 TO lt_value.
APPEND TEXT-027 TO lt_value.
APPEND TEXT-028 TO lt_value.
APPEND TEXT-029 TO lt_value.
APPEND TEXT-030 TO lt_value.


APPEND  lt_value TO lt_values.

*Count number of coulumn
DESCRIBE TABLE lt_value LINES lv_column_n.
CLEAR lt_value.


*Set the header size
ls_request_batch-repeat_cell-range-start_column_index = '0'.
ls_request_batch-repeat_cell-range-end_row_index = '1'.
ls_request_batch-repeat_cell-range-end_column_index = lv_column_n.
ls_request_batch-repeat_cell-fields = 'USER_ENTERED_FORMAT'.
ls_request_batch-repeat_cell-cell-user_entered_format-background_color-red = '0.2'.
ls_request_batch-repeat_cell-cell-user_entered_format-background_color-blue = '0.8'.
ls_request_batch-repeat_cell-cell-user_entered_format-background_color-green = '1'.
ls_request_batch-repeat_cell-cell-user_entered_format-background_color-alpha = '1'.
lv_batch_req_obj->add_request(
  EXPORTING
    ip_batch_req           =   ls_request_batch  " Request structure for spreadsheet batchupdate
).
lv_batch_req_obj->send_request( ip_spreadsheet_id = ls_spreadsheet-spreadsheet_id ).
CLEAR ls_request_batch.



** Writing values

*First cell where to start the table
lv_value_range-range = 'A1'.

APPEND TEXT-032 TO lt_keyfields.
APPEND TEXT-033 TO lt_keyfields.
APPEND TEXT-034 TO lt_keyfields.
APPEND TEXT-035 TO lt_keyfields.
APPEND TEXT-036 TO lt_keyfields.
APPEND TEXT-037 TO lt_keyfields.
APPEND TEXT-038 TO lt_keyfields.
APPEND TEXT-039 TO lt_keyfields.
APPEND TEXT-040 TO lt_keyfields.
APPEND TEXT-041 TO lt_keyfields.
APPEND TEXT-042 TO lt_keyfields.
APPEND TEXT-043 TO lt_keyfields.
APPEND TEXT-044 TO lt_keyfields.
APPEND TEXT-045 TO lt_keyfields.
APPEND TEXT-046 TO lt_keyfields.
APPEND TEXT-047 TO lt_keyfields.
APPEND TEXT-048 TO lt_keyfields.
APPEND TEXT-049 TO lt_keyfields.
APPEND TEXT-050 TO lt_keyfields.
APPEND TEXT-051 TO lt_keyfields.
APPEND TEXT-052 TO lt_keyfields.
APPEND TEXT-053 TO lt_keyfields.
APPEND TEXT-054 TO lt_keyfields.
APPEND TEXT-055 TO lt_keyfields.


LOOP AT <ft_alv_data> ASSIGNING <fs_line>.
  LOOP AT  lt_keyfields INTO ls_column.
    ASSIGN COMPONENT ls_column-name OF STRUCTURE <fs_line> TO  <fs_field>.

    IF sy-subrc EQ 0.

      APPEND  <fs_field>  TO lt_value.
    ENDIF.

  ENDLOOP.

  APPEND  lt_value TO lt_values.
  CLEAR lt_value.
ENDLOOP.



lv_value_range-values = lt_values.


zcl_gspreadsheet_values_api=>append(
  EXPORTING
    ip_spreadsheet_id =   ls_spreadsheet-spreadsheet_id
    ip_range          =  'A1'
    ip_value_range    =    lv_value_range " Values within a range of the spreadsheet structure

).
WRITE TEXT-006.
WRITE ls_spreadsheet-spreadsheet_url.
