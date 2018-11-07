*&---------------------------------------------------------------------*
*& Report ZGOOGL_TEST_ALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZGOOGL_TEST_ALV.


DATA: lt_outtab TYPE STANDARD TABLE OF alv_t_t2.
FIELD-SYMBOLS: <lt_outtab> LIKE lt_outtab.
DATA lo_data TYPE REF TO DATA.

" Let know the model
 cl_salv_bs_runtime_info=>set(
  EXPORTING
    display  = abap_false
    metadata = abap_false
    DATA     = abap_true
).


SUBMIT salv_demo_table_simple

  AND RETURN.

TRY.
    " get data from SALV model
    cl_salv_bs_runtime_info=>get_data_ref(
          IMPORTING
            r_data = lo_data
    ).
    ASSIGN lo_data->* to <lt_outtab>.
    BREAK-POINT.

  CATCH cx_salv_bs_sc_runtime_info.
ENDTRY.
