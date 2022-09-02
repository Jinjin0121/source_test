*&---------------------------------------------------------------------*
*& Include ZC1R210002TOP                            - Report ZC1R210002
*&---------------------------------------------------------------------*
REPORT zc1r210002  MESSAGE-ID zmcsa21.

TABLES : mara, marc.

DATA : BEGIN OF gs_mara,
         matnr TYPE mara-matnr,
         mtart TYPE mara-mtart,
         matkl TYPE mara-matkl,
         meins TYPE mara-meins,
         tragr TYPE mara-tragr,
         pstat TYPE marc-pstat,
         dismm TYPE marc-dismm,
         ekgrp TYPE marc-ekgrp,
       END OF gs_mara,

       gt_mara LIKE TABLE OF gs_mara.
