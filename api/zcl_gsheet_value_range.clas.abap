CLASS zcl_gsheet_value_range DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA gt_values TYPE zgsheet_array_string_tt .
    DATA gt_values_string TYPE zgsheet_string_tt .
    DATA gs_value_range TYPE zgsheet_value_ranges_s .
    DATA gv_column_num TYPE int4 .

    METHODS append_cell_value
      IMPORTING
        !ip_value TYPE any .
    METHODS move_next_row .
    METHODS get_column_number
      RETURNING
        VALUE(ep_column_number) TYPE int4 .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GSHEET_VALUE_RANGE IMPLEMENTATION.


  METHOD append_cell_value.



    APPEND ip_value TO me->gt_values_string.
  ENDMETHOD.


  METHOD get_column_number.



    ep_column_number = me->gv_column_num.
  ENDMETHOD.


  METHOD move_next_row.

*     APPEND GT_VALUES_STRING TO  me->GT_VALUES.
    APPEND gt_values_string TO me->gs_value_range-values.
    CLEAR gt_values_string.
  ENDMETHOD.
ENDCLASS.
