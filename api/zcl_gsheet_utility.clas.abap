class ZCL_GSHEET_UTILITY definition
  public
  final
  create public .

public section.

  class-data GC_SPREADSHEET_URL_PREFIX type STRING value 'https://docs.google.com/spreadsheets/d/' ##NO_TEXT.

  class-methods EXTRACT_SPREADSHEET_ID
    importing
      !IP_URL type STRING
    returning
      value(EP_IDENTIFIER) type STRING .
protected section.
private section.
ENDCLASS.



CLASS ZCL_GSHEET_UTILITY IMPLEMENTATION.


  method EXTRACT_SPREADSHEET_ID.

     ep_identifier = ip_url.
    REPLACE  GC_SPREADSHEET_URL_PREFIX IN ep_identifier WITH ''.
    REPLACE all OCCURRENCES OF REGEX '/.*' IN  ep_identifier WITH ''.




  endmethod.
ENDCLASS.
