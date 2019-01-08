CLASS zcl_oa2c_ce_zgoogle DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_oa2c_config_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_OA2C_CE_ZGOOGLE IMPLEMENTATION.


  METHOD if_oa2c_config_extension~get_ac_auth_requ_params.


    DATA: ls_nvp LIKE LINE OF et_additional_params.
* parameter: access_type
    ls_nvp-name = `access_type`.
    ls_nvp-value = `offline`. "online|offline
    APPEND  ls_nvp TO et_additional_params.
* parameter: approval_prompt
    ls_nvp-name = `approval_prompt`.
    ls_nvp-value = `force`. "auto|force
    APPEND ls_nvp TO et_additional_params.
  ENDMETHOD.


  METHOD if_oa2c_config_extension~get_saml20_at_requ_params.
  ENDMETHOD.
ENDCLASS.
