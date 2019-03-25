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


  METHOD copy.


    DATA: lv_sheet     TYPE zgspreadsheet_s,
          lv_json_file TYPE string,
          lv_target    TYPE string VALUE gc_endpoint_url.

    CONCATENATE lv_target '/' ip_source_spreadsheet_id INTO lv_target.
    CONCATENATE lv_target '/copy' INTO lv_target.

    zcl_google_http_api=>decode_abap2json(
      IMPORTING
       ep_json      =  lv_json_file
      CHANGING
        cp_abap_data = ip_file
    ).


    zcl_google_http_api=>send_post_request(
      EXPORTING
        ip_target          = lv_target
        ip_param_kind      =  'H'
*        PT_PARAM           =     " HTTP Framework (iHTTP) Table Name/Value Pairs
        ip_json_request    = lv_json_file
      IMPORTING
        ep_response_string = ep_spreadsheet_json
    ).

  ENDMETHOD.                                             "#EC CI_VALPAR


  METHOD delete.
    DATA:
      lt_param  TYPE tihttpnvp,
      ls_param  TYPE ihttpnvp,
      lv_target TYPE string VALUE gc_endpoint_url.

    CONCATENATE lv_target '/' ip_spreadsheet_id INTO lv_target.

    zcl_google_http_api=>send_delete_request(
      EXPORTING
        target          = lv_target
        method          = 'DELETE'
        param_kind      = 'H'
        lt_param        =   lt_param      " HTTP Framework (iHTTP) Table Name/Value Pairs
*     importing
*       RESPONSE_STRING =
*       RESPONSE        =     " HTTP Framework (iHTTP) HTTP Response
    ).
  ENDMETHOD.


  METHOD list_filter.
    DATA:

      lt_param           TYPE tihttpnvp,
      ls_param           TYPE ihttpnvp,
      lv_get_response    TYPE REF TO if_http_response,
      lv_target          TYPE string VALUE gc_endpoint_url,
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

    zcl_google_http_api=>send_get_request(
      EXPORTING

        target = lv_target
        param_kind =      'H'
        lt_param   =     lt_param" HTTP Framework (iHTTP) Table Name/Value Pairs
          IMPORTING
       response_string = lv_response_string
       response = lv_get_response
    ).

    zcl_google_http_api=>encode_json2abap(
      EXPORTING
        ip_json      = lv_response_string
      CHANGING
        cp_abap_data =  ep_spreadsheet
    ).


  ENDMETHOD.


  METHOD update.
    DATA:
*      GOBJECT            TYPE REF TO ZCL_GOOGLE_HTTP_API,
      lt_param           TYPE tihttpnvp,
      ls_param           TYPE ihttpnvp,
      lv_get_response    TYPE REF TO if_http_response,
      lv_target          TYPE string VALUE gc_endpoint_url,
      lv_response_string TYPE string.

*
    CONCATENATE  lv_target '/' ip_file_id   INTO lv_target.
    CONCATENATE  lv_target '?addParents=' ip_folder_id  INTO lv_target.


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


    zcl_google_http_api=>send_get_request(
      EXPORTING

        target = lv_target
        param_kind =      'H'
        lt_param   =     lt_param" HTTP Framework (iHTTP) Table Name/Value Pairs
          IMPORTING
       response_string = lv_response_string
       response = lv_get_response
    ).
  ENDMETHOD.


  METHOD upload.

    DATA:
      lv_target       TYPE string VALUE gc_upload_endpoint,
      lv_resp_string  TYPE string,
      lv_param_kind   TYPE string,
      lt_multipart    TYPE zgsheet_post_multipart_tt,
      ls_part         TYPE zgsheet_post_multipart_s,
      ls_param        TYPE ihttpnvp,
      lv_json_request TYPE string VALUE '',
      lv_mime_string  TYPE string,
      lv_fname_string TYPE string.

    lv_fname_string = TEXT-005.
    lv_mime_string = TEXT-006.

    ls_param-name =  TEXT-002.
    ls_param-value = TEXT-003.

    ls_part-content_type = TEXT-001.
    ls_part-cdata =  TEXT-004.

    REPLACE lv_fname_string WITH ip_filename INTO ls_part-cdata.

    IF ip_destination_mime_type IS NOT INITIAL.
      REPLACE lv_mime_string WITH ip_destination_mime_type INTO ls_part-cdata.
    ELSE.
      REPLACE lv_mime_string WITH ip_original_mime_type INTO ls_part-cdata.
    ENDIF.


    APPEND ls_param TO ls_part-header_fields.
    APPEND ls_part TO lt_multipart.
    CLEAR: ls_part,
          ls_param.


    ls_part-content_type = ip_original_mime_type.
    ls_param-name =  TEXT-002.

    APPEND ls_param TO ls_part-header_fields.
    ls_part-data = ip_file_xstring.
    APPEND ls_part TO lt_multipart.
    CLEAR: ls_part,
          ls_param.

    lv_param_kind = 'H'.

    zcl_google_http_api=>send_post_request(
      EXPORTING
        ip_target          = lv_target
        ip_param_kind      = lv_param_kind

        ip_json_request    =  lv_json_request
        it_multiparts      =  lt_multipart   " Single part for mutipart post request
       IMPORTING
        ep_response_string =  lv_resp_string
    ).


  ENDMETHOD.
ENDCLASS.
