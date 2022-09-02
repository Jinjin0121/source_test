*&---------------------------------------------------------------------*
*& Include ZC1R210006_TOP                           - Report ZC1R210006
*&---------------------------------------------------------------------*
REPORT zc1r210006 MESSAGE-ID zmca21.

TABLES : bkpf.

DATA : BEGIN OF gs_data,
         belnr TYPE bseg-belnr,
         buzei TYPE bseg-buzei,
         blart TYPE bkpf-blart,
         budat TYPE bkpf-budat,
         shkzg TYPE bseg-shkzg,
         dmbtr TYPE bseg-dmbtr,
         waers TYPE bkpf-waers,
         hkont TYPE bseg-hkont,
       END OF gs_data,

       gt_data LIKE TABLE OF gs_data.

"ALV DATA
DATA : gcl_con    TYPE REF TO cl_gui_docking_container,
       gcl_grid   TYPE REF TO cl_gui_alv_grid,
       gs_fcat    TYPE lvc_s_fcat,
       gt_fcat    TYPE lvc_t_fcat,
       gs_layout  TYPE lvc_s_layo,
       gs_vairant TYPE disvariant.

DATA gv_okcode TYPE sy-ucomm.
