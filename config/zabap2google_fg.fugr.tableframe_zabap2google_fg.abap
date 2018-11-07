*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZABAP2GOOGLE_FG
*   generation date: 08/02/2018 at 16:47:21
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZABAP2GOOGLE_FG    .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
