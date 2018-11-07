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
REPORT ZGOOGLE_SHARE_FRAMEWORK.

SELECTION-SCREEN: BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-i01.
PARAMETERS: p_url type string OBLIGATORY.
PARAMETERS: p_mail LIKE rlgrap-filename OBLIGATORY.
PARAMETERS: p_role LIKE rlgrap-filename OBLIGATORY.
SELECTION-SCREEN:END OF BLOCK bl1 .
*
*REPLACE 'https://docs.google.com/spreadsheets/d/' IN p_url WITH ''.
*REPLACE all OCCURRENCES OF REGEX '/.*' IN p_url WITH ''.

DATA: ls_permission type zgdrive_permission_s,
      lv_spreadsheet_id type string.
LV_SPREADSHEET_ID  =  ZCL_GSHEET_UTILITY=>EXTRACT_SPREADSHEET_ID( IP_URL =  p_url ).



LS_PERMISSION-ROLE = p_role.
LS_PERMISSION-type = 'user'.
LS_PERMISSION-email_address = p_mail.

*Creating new permission and share
ZCL_GDRIVE_PERMISSION_API=>CREATE(
  exporting
    IP_SPREADSHEET_ID =  lv_spreadsheet_id" Spreadsheet where to apply the permission
    IP_PERMISSION     =  ls_permission   " A permisssione for a google drive file
).
