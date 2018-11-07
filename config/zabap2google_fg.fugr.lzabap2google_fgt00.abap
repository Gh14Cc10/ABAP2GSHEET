*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 08/03/2018 at 16:52:11
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZABAP2G_DIMENS_V................................*
DATA:  BEGIN OF STATUS_ZABAP2G_DIMENS_V              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZABAP2G_DIMENS_V              .
CONTROLS: TCTRL_ZABAP2G_DIMENS_V
            TYPE TABLEVIEW USING SCREEN '0002'.
*...processing: ZABAP2G_PARAMS..................................*
DATA:  BEGIN OF STATUS_ZABAP2G_PARAMS                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZABAP2G_PARAMS                .
CONTROLS: TCTRL_ZABAP2G_PARAMS
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZABAP2G_DIMENS_V              .
TABLES: *ZABAP2G_PARAMS                .
TABLES: ZABAP2G_DIMENS_V               .
TABLES: ZABAP2G_PARAMS                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
