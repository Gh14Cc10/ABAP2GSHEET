class ZCL_GSHEET_VALUE_RANGE definition
  public
  final
  create public .

public section.

  data GT_VALUES type ZGSHEET_ARRAY_STRING_TT .
  data GT_VALUES_STRING type ZGSHEET_STRING_TT .
  data GS_VALUE_RANGE type ZGSHEET_VALUE_RANGES_S .
  data GV_COLUMN_NUM type INT4 .

  methods APPEND_CELL_VALUE
    importing
      !IP_VALUE type ANY .
  methods MOVE_NEXT_ROW .
  methods GET_COLUMN_NUMBER
    returning
      value(EP_COLUMN_NUMBER) type INT4 .
protected section.
private section.
ENDCLASS.



CLASS ZCL_GSHEET_VALUE_RANGE IMPLEMENTATION.


  method APPEND_CELL_VALUE.



    APPEND IP_VALUE TO me->GT_VALUES_STRING.
  endmethod.


  method GET_COLUMN_NUMBER.



 EP_COLUMN_NUMBER = ME->GV_COLUMN_NUM.
  endmethod.


  method MOVE_NEXT_ROW.

*     APPEND GT_VALUES_STRING TO  me->GT_VALUES.
    APPEND GT_VALUES_STRING TO me->GS_VALUE_RANGE-VALUES.
     CLEAR GT_VALUES_STRING.
  endmethod.
ENDCLASS.
