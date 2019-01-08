*&---------------------------------------------------------------------*
*& Report ZGOOGLE_DEMO_LIVE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgoogle_demo_live_mb52_fixed.
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



DATA: lv_batch_req_obj   TYPE REF TO zcl_gsheet_batch_req,
      lv_spreadsheet_obj TYPE REF TO zcl_gspreadsheet,
      ls_spreadsheet     TYPE zgspreadsheet_s.

* Values grid
DATA: lt_values      TYPE zgsheet_array_string_tt,
      lt_value       LIKE LINE OF lt_values,
      lv_value_range TYPE zgsheet_value_ranges_s.



DATA: lv_column_n      TYPE int3,
      ls_request_batch TYPE zgsheet_batch_update_req_s.


DATA:
  lt_keyfields TYPE abap_keydescr_tab,
  ls_column    TYPE abap_keydescr.

FIELD-SYMBOLS <ft_alv_data>   TYPE ANY TABLE.
FIELD-SYMBOLS <fs_line>   TYPE any.
FIELD-SYMBOLS <fs_field>   TYPE any.



cl_salv_bs_runtime_info=>set(
  EXPORTING display  = abap_false
            metadata = abap_true
            data     = abap_true ).


* Submit Report
SUBMIT rm07mlbs
  USING SELECTION-SET p_vari
  AND RETURN.

TRY.

    cl_salv_bs_runtime_info=>get_data_ref(
      IMPORTING
        r_data                     = lr_alv_data
    ).

    ASSIGN lr_alv_data->* TO <ft_alv_data>.

  CATCH cx_salv_bs_sc_runtime_info.
    MESSAGE `Unable to retrieve ALV data` TYPE 'E'.
ENDTRY.
cl_salv_bs_runtime_info=>clear_all( ).




*--------





CREATE OBJECT lv_batch_req_obj TYPE zcl_gsheet_batch_req.

*Local spreadsheet
ls_spreadsheet-properties-title = p_title.



*Creation on google drive
zcl_gspreadsheet_api=>create_new_spreadsheet(
  EXPORTING
    ip_spreadsheet_s =     ls_spreadsheet  " Google sheet object structure
  IMPORTING
    ep_spreadsheet   =     lv_spreadsheet_obj " Google sheet object structure
).
CLEAR ls_spreadsheet.
ls_spreadsheet = lv_spreadsheet_obj->get_abap_obj( ).







* Writing header

APPEND 'Material ID' TO lt_value.
APPEND 'Plant ID' TO lt_value.
APPEND 'Storage location ID' TO lt_value.
APPEND 'Base Unit of Measure' TO lt_value.
APPEND 'Unrestricted Stock' TO lt_value.
APPEND 'Currency' TO lt_value.
APPEND 'Unrestricted Value' TO lt_value.
APPEND 'Transit Stock' TO lt_value.
APPEND 'Transit Value' TO lt_value.
APPEND 'Quality Inspection Stock' TO lt_value.
APPEND 'Quality Inspection Value' TO lt_value.
APPEND 'Restricted Stock' TO lt_value.
APPEND 'Restricted Value' TO lt_value.
APPEND 'Blocked Stock' TO lt_value.
APPEND 'Blocked Value' TO lt_value.
APPEND 'Returns Stock' TO lt_value.
APPEND 'Returns Value' TO lt_value.
APPEND 'Material' TO lt_value.
APPEND 'Plant' TO lt_value.
APPEND 'Material type' TO lt_value.
APPEND 'Material Group' TO lt_value.
APPEND 'Storage Location' TO lt_value.
APPEND  lt_value TO lt_values.
DESCRIBE TABLE lt_value LINES lv_column_n.
CLEAR lt_value.



ls_request_batch-repeat_cell-range-start_column_index = '0'.
ls_request_batch-repeat_cell-range-end_row_index = '1'.
ls_request_batch-repeat_cell-range-end_column_index = lv_column_n.
ls_request_batch-repeat_cell-fields = 'USER_ENTERED_FORMAT'.
ls_request_batch-repeat_cell-cell-user_entered_format-background_color-red = '0.75'.
ls_request_batch-repeat_cell-cell-user_entered_format-background_color-blue = '075'.
ls_request_batch-repeat_cell-cell-user_entered_format-background_color-green = '0.75'.
ls_request_batch-repeat_cell-cell-user_entered_format-background_color-alpha = '1'.
lv_batch_req_obj->add_request(
  EXPORTING
    ip_batch_req           =   ls_request_batch  " Request structure for spreadsheet batchupdate
).
CLEAR ls_request_batch.
ls_request_batch-update_dimension_properties-fields = 'pixelSize'.
ls_request_batch-update_dimension_properties-properties-pixel_size = '60'.
ls_request_batch-update_dimension_properties-range-sheet_id = '0'.
ls_request_batch-update_dimension_properties-range-dimension = 'ROWS'.
ls_request_batch-update_dimension_properties-range-start_index = '0'.
ls_request_batch-update_dimension_properties-range-end_index = '1'.

lv_batch_req_obj->add_request(
  EXPORTING
    ip_batch_req           =   ls_request_batch  " Request structure for spreadsheet batchupdate
).

lv_batch_req_obj->send_request( ip_spreadsheet_id = ls_spreadsheet-spreadsheet_id ).
CLEAR ls_request_batch.



** Writing values

*First cell where to start the table
lv_value_range-range = 'A1'.

APPEND 'MATNR' TO lt_keyfields.
APPEND 'WERKS' TO lt_keyfields.
APPEND 'LGORT' TO lt_keyfields.

APPEND 'MEINS' TO lt_keyfields.
APPEND 'LABST' TO lt_keyfields.
APPEND 'WAERS' TO lt_keyfields.

APPEND 'WLABS' TO lt_keyfields.
APPEND 'UMLME' TO lt_keyfields.
APPEND 'WUMLM' TO lt_keyfields.

APPEND 'INSME' TO lt_keyfields.
APPEND 'WINSM' TO lt_keyfields.
APPEND 'EINME' TO lt_keyfields.

APPEND 'WEINM' TO lt_keyfields.
APPEND 'SPEME' TO lt_keyfields.
APPEND 'WSPEM' TO lt_keyfields.
APPEND 'RETME' TO lt_keyfields.
APPEND 'WRETM' TO lt_keyfields.
APPEND 'MAKTX' TO lt_keyfields.
APPEND 'NAME1' TO lt_keyfields.
APPEND 'MTART' TO lt_keyfields.
APPEND 'MATKL' TO lt_keyfields.
APPEND 'LGOBE' TO lt_keyfields.



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
    ip_spreadsheet_id =   ls_spreadsheet-spreadsheet_id "'13R2I5IKMYRVgdjTe1bMAeVkS1Fs4AZlsM97_TKup_H4'
    ip_range          =  'A1'
    ip_value_range    =    lv_value_range " Values within a range of the spreadsheet structure

).

WRITE TEXT-006.
WRITE ls_spreadsheet-spreadsheet_url.
