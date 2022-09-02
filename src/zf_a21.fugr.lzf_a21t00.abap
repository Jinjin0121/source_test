*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZSAPLANE_A21....................................*
DATA:  BEGIN OF STATUS_ZSAPLANE_A21                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSAPLANE_A21                  .
CONTROLS: TCTRL_ZSAPLANE_A21
            TYPE TABLEVIEW USING SCREEN '0021'.
*...processing: ZSCARR_A21......................................*
DATA:  BEGIN OF STATUS_ZSCARR_A21                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSCARR_A21                    .
CONTROLS: TCTRL_ZSCARR_A21
            TYPE TABLEVIEW USING SCREEN '0017'.
*...processing: ZSFLIGHT_A21....................................*
DATA:  BEGIN OF STATUS_ZSFLIGHT_A21                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSFLIGHT_A21                  .
CONTROLS: TCTRL_ZSFLIGHT_A21
            TYPE TABLEVIEW USING SCREEN '0019'.
*...processing: ZSPFLI_A21......................................*
DATA:  BEGIN OF STATUS_ZSPFLI_A21                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSPFLI_A21                    .
CONTROLS: TCTRL_ZSPFLI_A21
            TYPE TABLEVIEW USING SCREEN '0015'.
*.........table declarations:.................................*
TABLES: *ZSAPLANE_A21                  .
TABLES: *ZSCARR_A21                    .
TABLES: *ZSFLIGHT_A21                  .
TABLES: *ZSPFLI_A21                    .
TABLES: ZSAPLANE_A21                   .
TABLES: ZSCARR_A21                     .
TABLES: ZSFLIGHT_A21                   .
TABLES: ZSPFLI_A21                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
