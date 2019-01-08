*&---------------------------------------------------------------------*
*& Report ZGOOGLE_DEMO_UPLOAD_EXCEL
*&---------------------------------------------------------------------*
*& - Upload an excel to your google drive folder
*&---------------------------------------------------------------------*
REPORT zgoogle_demo_upload_excel.



DATA : filename TYPE string,
       data     TYPE xstring.

DATA  : length   TYPE i.
DATA: lt_binary_data  TYPE STANDARD TABLE OF x255 WITH NON-UNIQUE DEFAULT KEY.



filename = 'C:\sampleData.xlsx'.
CALL FUNCTION 'GUI_UPLOAD'
  EXPORTING
    filename   = filename
    filetype   = 'BIN'
  IMPORTING
    filelength = length
  TABLES
    data_tab   = lt_binary_data
  EXCEPTIONS
    OTHERS     = 99.

CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
  EXPORTING
    input_length = length
  IMPORTING
    buffer       = data
  TABLES
    binary_tab   = lt_binary_data.

******* Send to google Drive

CALL METHOD zcl_gdrive_file_api=>upload(
  EXPORTING
    ip_file_xstring          = data
    ip_filename              = 'ExcelFromSap'
    ip_destination_mime_type = 'application/vnd.google-apps.spreadsheet'
    ip_original_mime_type    = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
                               ).
