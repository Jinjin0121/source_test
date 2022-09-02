*&---------------------------------------------------------------------*
*& Include          ZC1R210002S01
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-T01.
  PARAMETERS      pa_wer TYPE marc-werks OBLIGATORY DEFAULT '1010'.
  SELECT-OPTIONS: so_mat  FOR mara-matnr,
                  so_mta  FOR mara-mtart,
                  so_ekg  FOR marc-ekgrp.
SELECTION-SCREEN END OF BLOCK bl1.
