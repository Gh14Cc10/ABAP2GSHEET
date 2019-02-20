class ZCL_GDRIVE_FILE_API definition
  public
  inheriting from ZCL_GOOGLE_HTTP_API
  final
  create public .

public section.

  constants GC_ENDPOINT_URL type STRING value 'https://www.googleapis.com/drive/v3/files' ##NO_TEXT.
  constants GC_UPLOAD_ENDPOINT type STRING value 'https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart' ##NO_TEXT.

  class-methods UPDATE
    importing
      !IP_FOLDER_ID type STRING optional
      !IP_FILE_ID type STRING .
  class-methods COPY
    importing
      !IP_SOURCE_SPREADSHEET_ID type STRING
      value(IP_FILE) type ZGDRIVE_FILE_S optional
    exporting
      !EP_SPREADSHEET_JSON type STRING .
  class-methods DELETE
    importing
      !IP_SPREADSHEET_ID type STRING .
  class-methods LIST_FILTER
    importing
      !IT_PARAM type TIHTTPNVP
    exporting
      !EP_SPREADSHEET type ZGSPREADSHEET_S .
  class-methods UPLOAD
    importing
      !IP_FILE_XSTRING type XSTRING
      !IP_FILENAME type STRING
      !IP_ORIGINAL_MIME_TYPE type STRING
      !IP_DESTINATION_MIME_TYPE type STRING optional .
protected section.
private section.
ENDCLASS.



CLASS ZCL_GDRIVE_FILE_API IMPLEMENTATION.


  method COPY.


    DATA: lv_file      TYPE ZGDRIVE_FILE_S,
          lv_sheet     type zgspreadsheet_s,
          lv_json_file TYPE STRING,
          lv_target    type string value GC_ENDPOINT_URL.

    CONCATENATE lv_target '/' IP_SOURCE_SPREADSHEET_ID INTO lv_target.
    CONCATENATE lv_target '/copy' INTO lv_target.

*  lv_file-NAME = 'abap_test'.
*  lv_file-MIMETYPE  = ''.
*    lv_file-DESCRIPTION  = 'TestDescription'.
*lv_sheet-PROPERTIES-TITLE = 'abap_sheet'.
*  CREATE OBJECT lv_spreadsheet TYPE ZCL_SPREADSHEET.



    ZCL_GOOGLE_HTTP_API=>DECODE_ABAP2JSON(
      importing
       EP_JSON      =  lv_json_file
      changing
        CP_ABAP_DATA = ip_file
    ).

*lv_target = 'http://requestbin.net/r/1mtbo3r1'.

    ZCL_GOOGLE_HTTP_API=>SEND_POST_REQUEST(
      exporting
        IP_TARGET          = lv_target
        IP_PARAM_KIND      =  'H'
*        PT_PARAM           =     " HTTP Framework (iHTTP) Table Name/Value Pairs
        IP_JSON_REQUEST    = lv_json_file
      importing
        EP_RESPONSE_STRING = EP_SPREADSHEET_JSON
    ).

  endmethod."#EC CI_VALPAR


  method DELETE.
DATA:
      lt_param           TYPE tihttpnvp,
      ls_param           TYPE ihttpnvp,
      lv_target          TYPE string value GC_ENDPOINT_URL.

      CONCATENATE lv_target '/' ip_spreadsheet_id INTO lv_target.

   ZCL_GOOGLE_HTTP_API=>SEND_DELETE_REQUEST(
     exporting
       TARGET          = lv_target
       METHOD          = 'DELETE'
       PARAM_KIND      = 'H'
       LT_PARAM        =   lt_param      " HTTP Framework (iHTTP) Table Name/Value Pairs
*     importing
*       RESPONSE_STRING =
*       RESPONSE        =     " HTTP Framework (iHTTP) HTTP Response
   ).
  endmethod.


  method LIST_FILTER.
DATA:

      lt_param           TYPE tihttpnvp,
      ls_param           TYPE ihttpnvp,
      lv_get_response    type ref to IF_HTTP_RESPONSE,
      lv_target type string VALUE GC_ENDPOINT_URL,
      lv_response_string TYPE string.


****Sample filters
*ls_param-name = 'corpora'.
*ls_param-value = 'default'.
*APPEND ls_param TO lt_param.
*CLEAR ls_param.
*
*
*ls_param-name = 'supportsTeamDrives'.
*ls_param-value = 'false'.
*APPEND ls_param TO lt_param.
*CLEAR ls_param.
*
*
*ls_param-name = 'q'.
*ls_param-value ='%27mailFilter@gmail.com%27%20in%20ownersfields=nextPageToken, files(mimeType, id, name, trashed, ownedByMe, parents)'.
*APPEND ls_param TO lt_param.
*CLEAR ls_param.


*REPLACE '&1' WITH PA_SPREADSHEET_ID INTO lv_target.




ZCL_GOOGLE_HTTP_API=>SEND_GET_REQUEST(
  exporting

    TARGET = lv_target
    PARAM_KIND =      'H'
    LT_PARAM   =     lt_param" HTTP Framework (iHTTP) Table Name/Value Pairs
      importing
   response_string = lv_response_string
   RESPONSE = lv_get_response
).






ZCL_GOOGLE_HTTP_API=>ENCODE_JSON2ABAP(
  exporting
    IP_JSON      = lv_response_string
  changing
    CP_ABAP_DATA =  EP_SPREADSHEET
).


  endmethod.


  method UPDATE.
    DATA:
*      GOBJECT            TYPE REF TO ZCL_GOOGLE_HTTP_API,
      lt_param           TYPE tihttpnvp,
      ls_param           TYPE ihttpnvp,
      lv_get_response    type ref to IF_HTTP_RESPONSE,
      lv_target type string VALUE GC_ENDPOINT_URL,
      lv_response_string TYPE string.




*
CONCATENATE  lv_target '/' IP_FILE_ID   INTO lv_target.
CONCATENATE  lv_target '?addParents=' IP_FOLDER_ID  INTO lv_target.


*ZCL_GOOGLE_HTTP_API=>SEND_PATCH_REQUEST(
*  exporting
*    IP_TARGET          = lv_target
*    IP_PARAM_KIND      =  'H'
**    TP_PARAM           =     " HTTP Framework (iHTTP) Table Name/Value Pairs
*    IP_JSON_REQUEST    =
**    IT_MULTIPARTS      =     " Single part for mutipart post request
**  importing
**    EP_RESPONSE_STRING =
*).


ZCL_GOOGLE_HTTP_API=>SEND_GET_REQUEST(
  exporting

    TARGET = lv_target
    PARAM_KIND =      'H'
    LT_PARAM   =     lt_param" HTTP Framework (iHTTP) Table Name/Value Pairs
      importing
   response_string = lv_response_string
   RESPONSE = lv_get_response
).
  endmethod.


  method UPLOAD.



DATA:
   lv_target     TYPE string value GC_UPLOAD_ENDPOINT,
   lv_resp_string type string,
   lv_param_kind TYPE string,
   lt_multipart type zgsheet_post_multipart_tt,
   ls_part  type zgsheet_post_multipart_s,
   ls_param   TYPE ihttpnvp,
   lv_json_request type string value '',
   lv_mime_string type string,
   lv_fname_String type string.

    lv_fname_String = text-005.
    lv_mime_string = text-006.

ls_part-CONTENT_TYPE = text-001.

ls_param-NAME =  text-002.
ls_param-VALUE = text-003.
LS_PART-CDATA =  text-004.
REPLACE lv_fname_String  WITH IP_FILENAME INTO ls_part-CDATA.
IF IP_DESTINATION_MIME_TYPE IS NOT INITIAL.
REPLACE lv_mime_string WITH IP_DESTINATION_MIME_TYPE INTO ls_part-CDATA.
ELSE.
 REPLACE lv_mime_string WITH IP_ORIGINAL_MIME_TYPE INTO ls_part-CDATA.
ENDIF.


APPEND ls_param TO LS_PART-HEADER_FIELDS.
APPEND ls_part TO lt_multipart.
CLEAR: ls_part,
      ls_param.


ls_part-CONTENT_TYPE = IP_ORIGINAL_MIME_TYPE.
ls_param-NAME =  text-002.

APPEND ls_param TO LS_PART-HEADER_FIELDS.
ls_part-DATA = ip_file_xstring.
APPEND ls_part TO lt_multipart.
CLEAR: ls_part,
      ls_param.






lv_param_kind = 'H'.


ZCL_GOOGLE_HTTP_API=>SEND_POST_REQUEST(
  exporting
    IP_TARGET          = lv_target
    IP_PARAM_KIND      = lv_param_kind

    IP_JSON_REQUEST    =  lv_json_request
    IT_MULTIPARTS      =  lt_multipart   " Single part for mutipart post request
   importing
    EP_RESPONSE_STRING =  lv_resp_string
).


  endmethod.
ENDCLASS.
