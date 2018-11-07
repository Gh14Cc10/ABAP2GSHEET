class ZCL_OA2C_CE_ZGOOGLE definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_OA2C_CONFIG_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_OA2C_CE_ZGOOGLE IMPLEMENTATION.


  method IF_OA2C_CONFIG_EXTENSION~GET_AC_AUTH_REQU_PARAMS.


DATA: ls_nvp LIKE LINE OF et_additional_params.
* parameter: access_type
ls_nvp-name = `access_type`.
ls_nvp-value = `offline`. "online|offline
APPEND  ls_nvp TO et_additional_params.
* parameter: approval_prompt
ls_nvp-name = `approval_prompt`.
ls_nvp-value = `force`. "auto|force
APPEND ls_nvp TO et_additional_params.
  endmethod.


  method IF_OA2C_CONFIG_EXTENSION~GET_SAML20_AT_REQU_PARAMS.
  endmethod.
ENDCLASS.
