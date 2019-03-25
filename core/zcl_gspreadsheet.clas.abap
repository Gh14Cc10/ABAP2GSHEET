class ZCL_GSPREADSHEET definition
  public
  final
  create public .

public section.

  methods SET_TITLE
    importing
      !IP_TITLE type STRING .
  methods CREATE_FROM_TEMPLATE
    importing
      !PA_SOURCE_SPREADSHEET_ID type STRING
      !PA_SOURCE_SHEET_ID type ZGSHEET_SHEET_ID optional
      !PA_SOURCE_SHEET_NAME type STRING optional .
  methods UPDATE_ABAP
    exporting
      !PA_SPREADSHEET type ZGSPREADSHEET_S .
  methods GET_JSON
    returning
      value(P_GSHEET_JSON) type STRING .
  methods SET_JSON
    importing
      !P_GSHEET_JSON type STRING .
  methods REPEAT_CELL
    importing
      !IP_SHEET_ID type STRING
      !IP_SPREADSHEET_ID type STRING .
  methods ADD_SHEET
    importing
      !IP_PROPERTY type ZGSHEET_PROPERTY_S .
  methods DELETE_SHEET
    importing
      !IP_SHEET_ID type STRING .
  methods GET_SHEETS_LIST
    importing
      !PA_SPREADSHEET_ID type STRING optional
    returning
      value(PA_SHEETS_LIST) type ZGSHEET_TT .
  methods GET_ABAP_OBJ
    returning
      value(PA_SPREADSHEET_OBJ) type ZGSPREADSHEET_S .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA gv_json_string TYPE string .
    DATA gs_abap_spreadsheet TYPE zgspreadsheet_s .

    METHODS update_spreadsheet_properties .
    METHODS update_sheet_properties .
    METHODS update_dimension_properties .
    METHODS update_named_range .
    METHODS add_named_range .
    METHODS delete_named_range .
    METHODS auto_fill .
    METHODS cut_paste .
    METHODS copy_paste .
    METHODS merge_cells .
    METHODS unmerge_cells .
    METHODS update_borders .
    METHODS update_cells .
    METHODS add_filter_view .
    METHODS append_cells .
    METHODS clear_basic_filter .
    METHODS delete_dimension .
    METHODS delete_embedded_object .
    METHODS delete_filterview .
    METHODS duplicate_filterview .
    METHODS duplicate_sheet .
    METHODS find_replace .
    METHODS insert_dimension .
    METHODS insert_range .
    METHODS move_dimension .
    METHODS update_embedded_obj_position .
    METHODS paste_data .
    METHODS text_to_columns .
    METHODS update_filter_view .
    METHODS delete_range .
    METHODS append_dimension .
ENDCLASS.



CLASS ZCL_GSPREADSHEET IMPLEMENTATION.


  METHOD add_filter_view.
  ENDMETHOD.


  METHOD add_named_range.
  ENDMETHOD.


  METHOD add_sheet.


    DATA: ls_request_batch  TYPE zgsheet_batch_update_req_s,
          lo_batch_req_obj  TYPE REF TO zcl_gsheet_batch_req,
          lv_spreadsheet_id TYPE string.

    lv_spreadsheet_id =  me->gs_abap_spreadsheet-spreadsheet_id.

    CREATE OBJECT lo_batch_req_obj TYPE zcl_gsheet_batch_req.

    CLEAR ls_request_batch.
    ls_request_batch-add_sheet-properties = ip_property.

    lo_batch_req_obj->add_request( ip_batch_req = ls_request_batch  ).
    lo_batch_req_obj->send_request(
      EXPORTING
        ip_spreadsheet_id =  lv_spreadsheet_id
*      IP_SHEET_ID       = ip_sheet_ID
    ).

  ENDMETHOD.


  METHOD append_cells.
  ENDMETHOD.


  METHOD append_dimension.
  ENDMETHOD.


  METHOD auto_fill.
  ENDMETHOD.


  METHOD clear_basic_filter.
  ENDMETHOD.


  METHOD copy_paste.
  ENDMETHOD.


  METHOD create_from_template.

    DATA: lv_request          TYPE zgsheet_copy_req_s,
          lt_src_sheets_list  TYPE zgsheet_tt,
          ls_src_sheet        TYPE zgsheet_s,
          ls_gspreadsheet     TYPE zgspreadsheet_s,
          lo_gspreadsheet_obj TYPE REF TO  zcl_gspreadsheet.

***Create new empty spreadsheet***
    zcl_gspreadsheet_api=>create_new_spreadsheet(
      IMPORTING
        ep_spreadsheet   =     lo_gspreadsheet_obj " Google spreadsheet class instance
    ).

    me->set_json( p_gsheet_json =  lo_gspreadsheet_obj->get_json( ) ).
    ls_gspreadsheet  = lo_gspreadsheet_obj->get_abap_obj( ).
    CLEAR lo_gspreadsheet_obj.
    lt_src_sheets_list  = me->get_sheets_list( pa_spreadsheet_id =   pa_source_spreadsheet_id ).

    lv_request-destination_spreadsheet_id = ls_gspreadsheet-spreadsheet_id.

*** Loop all the sheets:

    LOOP AT lt_src_sheets_list INTO  ls_src_sheet.

      zcl_gspreadsheet_sheets_api=>copy_sheet(
       EXPORTING
         pa_spreadsheet_id =  pa_source_spreadsheet_id
         pa_sheet_id       =  ls_src_sheet-properties-sheet_id
         pa_request        = lv_request " Copy to Action request structure
     ).

    ENDLOOP.
  ENDMETHOD.


  METHOD cut_paste.
  ENDMETHOD.


  METHOD delete_dimension.
  ENDMETHOD.


  METHOD delete_embedded_object.
  ENDMETHOD.


  METHOD delete_filterview.
  ENDMETHOD.


  METHOD delete_named_range.
  ENDMETHOD.


  METHOD delete_range.
  ENDMETHOD.


  METHOD delete_sheet.

    DATA: ls_request_batch  TYPE zgsheet_batch_update_req_s,
          lo_batch_req_obj  TYPE REF TO zcl_gsheet_batch_req,
          lv_spreadsheet_id TYPE string.

    lv_spreadsheet_id =  me->gs_abap_spreadsheet-spreadsheet_id.

    CREATE OBJECT lo_batch_req_obj TYPE zcl_gsheet_batch_req.

    CLEAR ls_request_batch.
    ls_request_batch-delete_sheet-sheet_id = ip_sheet_id.

    lo_batch_req_obj->add_request( ip_batch_req = ls_request_batch  ).
    lo_batch_req_obj->send_request(
      EXPORTING
        ip_spreadsheet_id =  lv_spreadsheet_id
*        IP_SHEET_ID       = ip_sheet_ID
    ).
  ENDMETHOD.


  METHOD duplicate_filterview.
  ENDMETHOD.


  METHOD duplicate_sheet.
  ENDMETHOD.


  METHOD find_replace.
  ENDMETHOD.


  METHOD get_abap_obj.

    pa_spreadsheet_obj = me->gs_abap_spreadsheet.

  ENDMETHOD.


  METHOD get_json.

    p_gsheet_json = me->gv_json_string.

  ENDMETHOD.


  METHOD get_sheets_list.

    DATA: ls_spreadsheet TYPE zgspreadsheet_s,
          lv_sheet       TYPE  zgsheet_s.

    ls_spreadsheet  = zcl_gspreadsheet_api=>get_spreadsheet(
                      pa_spreadsheet_id = me->gs_abap_spreadsheet-spreadsheet_id
                  ).

    LOOP AT  ls_spreadsheet-sheets INTO lv_sheet.
      WRITE lv_sheet-properties-sheet_id.
      WRITE lv_sheet-properties-title.
    ENDLOOP.

    pa_sheets_list = ls_spreadsheet-sheets.
  ENDMETHOD.


  METHOD insert_dimension.
  ENDMETHOD.


  METHOD insert_range.
  ENDMETHOD.


  METHOD merge_cells.
  ENDMETHOD.


  METHOD move_dimension.
  ENDMETHOD.


  METHOD paste_data.
  ENDMETHOD.


  METHOD repeat_cell.

    DATA: ls_request_s     TYPE zgsheet_batch_update_reqs_s,
          lt_list_request  TYPE zgsheet_batch_update_reqs_tt,
          ls_batch_request TYPE zgsheet_batch_update_req_s.


    ls_batch_request-repeat_cell-range-sheet_id =  ip_sheet_id.
    ls_batch_request-repeat_cell-range-start_column_index = 1.
    ls_batch_request-repeat_cell-range-end_column_index = 10.
    ls_batch_request-repeat_cell-range-start_row_index  = 0.
    ls_batch_request-repeat_cell-range-end_row_index =  2.
    ls_batch_request-repeat_cell-fields = '*'.
    ls_batch_request-repeat_cell-cell-user_entered_value-number_value = 28.
    APPEND ls_batch_request TO lt_list_request.
    ls_request_s-requests = lt_list_request.

    zcl_gspreadsheet_api=>batch_update(
      EXPORTING
        ip_spreadsheet_id = ip_spreadsheet_id
*        IP_SHEET_ID       = IP_SHEET_ID
        ip_batch_reqs      =    ls_request_s  " Request structure for spreadsheet batchupdate
    ).
  ENDMETHOD.


  METHOD set_json.

    me->gv_json_string = p_gsheet_json.
*** Update internal structure that modelize the spreadsheet
    me->update_abap( ).

  ENDMETHOD.


  METHOD set_title.

    me->gs_abap_spreadsheet-properties-title = ip_title.

  ENDMETHOD.


  METHOD text_to_columns.
  ENDMETHOD.


  METHOD unmerge_cells.
  ENDMETHOD.


  METHOD update_abap.

    /ui2/cl_json=>deserialize( EXPORTING json = me->gv_json_string pretty_name = /ui2/cl_json=>pretty_mode-camel_case CHANGING data = pa_spreadsheet ).
    me->gs_abap_spreadsheet = pa_spreadsheet.

  ENDMETHOD.


  METHOD update_borders.
  ENDMETHOD.


  METHOD update_cells.
  ENDMETHOD.


  METHOD update_dimension_properties.
  ENDMETHOD.


  METHOD update_embedded_obj_position.
  ENDMETHOD.


  METHOD update_filter_view.
  ENDMETHOD.


  METHOD update_named_range.
  ENDMETHOD.


  METHOD update_sheet_properties.
  ENDMETHOD.


  METHOD update_spreadsheet_properties.
  ENDMETHOD.
ENDCLASS.
