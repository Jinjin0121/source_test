*&---------------------------------------------------------------------*
*& Include          ZTEST_09_A21S01
*&---------------------------------------------------------------------*

TABLES mast.
SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.

  PARAMETERS     pa_wer TYPE mast-werks DEFAULT '1010' OBLIGATORY.
  SELECT-OPTIONS so_mat FOR  mast-matnr.

SELECTION-SCREEN END OF BLOCK bl1.
