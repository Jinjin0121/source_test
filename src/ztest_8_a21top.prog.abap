*&---------------------------------------------------------------------*
*& Include ZTEST_8_A21TOP                           - Module Pool      ZTEST_8_A21
*&---------------------------------------------------------------------*
PROGRAM ZTEST_8_A21.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

  PARAMETERS: pa_wer TYPE mkal-werks,
              pa_ber TYPE pbid-berid,
              pa_pbd TYPE pbid-pbdnr,
              pa_ver TYPE pbid-versb.

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.

  PARAMETERS: ra_crt  RADIOBUTTON GROUP rd_1,
              ra_disp RADIOBUTTON GROUP rd_1.

SELECTION-SCREEN END OF BLOCK b2.

TABLES: mara, marc.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.

  SELECT-OPTIONS: so_manr  FOR  mara-matnr,
                  so_mtrt  FOR  mara-mtart,
                  so_makl  FOR  mara-matkl,
                  so_ekrp  FOR  marc-ekgrp.
  PARAMETERS : pa_dipo TYPE marc-dispo,
               pa_dimm TYPE marc-dismm.

SELECTION-SCREEN END OF BLOCK b3.
