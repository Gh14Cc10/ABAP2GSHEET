CLASS zcl_oa2c_specifics_zgoogle DEFINITION
  PUBLIC
  INHERITING FROM cl_oa2c_specifics_abstract
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS if_oa2c_specifics~get_config_extension
        REDEFINITION .
    METHODS if_oa2c_specifics~get_endpoint_settings
        REDEFINITION .
    METHODS if_oa2c_specifics~get_supported_grant_types
        REDEFINITION .
    METHODS if_oa2c_specifics~get_ac_auth_requ_param_names
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_OA2C_SPECIFICS_ZGOOGLE IMPLEMENTATION.


  METHOD if_oa2c_specifics~get_ac_auth_requ_param_names.
*CALL METHOD SUPER->IF_OA2C_SPECIFICS~GET_AC_AUTH_REQU_PARAM_NAMES
**  IMPORTING
**    E_CLIENT_ID           =
**    E_REDIRECT_URI        =
**    E_RESPONSE_TYPE       =
**    E_RESPONSE_TYPE_VALUE =
**    E_SCOPE               =
**    ET_ADD_PARAM_NAMES    =
*    .

    DATA: ls_add_param TYPE if_oa2c_specifics~ty_s_add_param.
    CALL METHOD super->if_oa2c_specifics~get_ac_auth_requ_param_names
      IMPORTING
        e_client_id           = e_client_id
        e_redirect_uri        = e_redirect_uri
        e_response_type       = e_response_type
        e_response_type_value = e_response_type_value
        e_scope               = e_scope.


    ls_add_param-name = `access_type`.
    INSERT ls_add_param INTO TABLE et_add_param_names.
    ls_add_param-name = `approval_prompt`.
    INSERT ls_add_param INTO TABLE et_add_param_names.
    ls_add_param-name = `login_hint`.
    INSERT ls_add_param INTO TABLE et_add_param_names.
  ENDMETHOD.


  METHOD if_oa2c_specifics~get_config_extension.
*CALL METHOD SUPER->IF_OA2C_SPECIFICS~GET_CONFIG_EXTENSION
*  RECEIVING
*    R_CONFIG_EXTENSION =
*    .
    r_config_extension = `ZGOOGLE`.
  ENDMETHOD.


  METHOD if_oa2c_specifics~get_endpoint_settings.
*CALL METHOD SUPER->IF_OA2C_SPECIFICS~GET_ENDPOINT_SETTINGS
**  IMPORTING
**    E_CHANGEABLE                  =
**    E_AUTHORIZATION_ENDPOINT_PATH =
**    E_TOKEN_ENDPOINT_PATH         =
**    E_REVOCATION_ENDPOINT_PATH    =
*    .

    e_changeable = abap_false.
    e_authorization_endpoint_path = `accounts.google.com/o/oauth2/auth`.
    e_token_endpoint_path = `accounts.google.com/o/oauth2/token`.
    e_revocation_endpoint_path = `accounts.google.com/o/oauth2/revoke`.
  ENDMETHOD.


  METHOD if_oa2c_specifics~get_supported_grant_types.
*CALL METHOD SUPER->IF_OA2C_SPECIFICS~GET_SUPPORTED_GRANT_TYPES
**  IMPORTING
**    E_AUTHORIZATION_CODE =
**    E_SAML20_ASSERTION   =
**    E_REFRESH            =
**    E_REVOCATION         =
**    E_ROPC               =
**    E_CC                 =
*    .

    e_authorization_code = abap_true.
    e_saml20_assertion = abap_false.
    e_refresh = abap_true. e_revocation = abap_true.

  ENDMETHOD.
ENDCLASS.
