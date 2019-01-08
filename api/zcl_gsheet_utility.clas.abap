CLASS zcl_gsheet_utility DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-DATA gc_spreadsheet_url_prefix TYPE string VALUE 'https://docs.google.com/spreadsheets/d/' ##NO_TEXT.

    CLASS-METHODS extract_spreadsheet_id
      IMPORTING
        !ip_url              TYPE string
      RETURNING
        VALUE(ep_identifier) TYPE string .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GSHEET_UTILITY IMPLEMENTATION.


  METHOD extract_spreadsheet_id.

    ep_identifier = ip_url.
    REPLACE  gc_spreadsheet_url_prefix IN ep_identifier WITH ''.
    REPLACE ALL OCCURRENCES OF REGEX '/.*' IN  ep_identifier WITH ''.




  ENDMETHOD.
ENDCLASS.
