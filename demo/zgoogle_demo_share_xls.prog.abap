*&---------------------------------------------------------------------*
*& Report DEMO_SHARE_XLS
*&---------------------------------------------------------------------*
*& Share any spreadsheet provided to the provided user with role specified
*& p_url: Spreadsheet link to share
*& p_mail: mail to share to the document

*& p_role: Role to use to share the document
*owner
*organizer
*fileOrganizer
*writer
*commenter
*reader
*&---------------------------------------------------------------------*
REPORT zgoogle_share_framework.

SELECTION-SCREEN: BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-i01.
PARAMETERS: p_url TYPE string OBLIGATORY.
PARAMETERS: p_mail LIKE rlgrap-filename OBLIGATORY.
PARAMETERS: p_role LIKE rlgrap-filename OBLIGATORY.
SELECTION-SCREEN:END OF BLOCK bl1 .
*
*REPLACE 'https://docs.google.com/spreadsheets/d/' IN p_url WITH ''.
*REPLACE all OCCURRENCES OF REGEX '/.*' IN p_url WITH ''.

DATA: ls_permission     TYPE zgdrive_permission_s,
      lv_spreadsheet_id TYPE string.
lv_spreadsheet_id  =  zcl_gsheet_utility=>extract_spreadsheet_id( ip_url =  p_url ).



ls_permission-role = p_role.
ls_permission-type = 'user'.
ls_permission-email_address = p_mail.

*Creating new permission and share
zcl_gdrive_permission_api=>create(
  EXPORTING
    ip_spreadsheet_id =  lv_spreadsheet_id" Spreadsheet where to apply the permission
    ip_permission     =  ls_permission   " A permisssione for a google drive file
).
