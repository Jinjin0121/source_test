*&---------------------------------------------------------------------*
*& Include ZC1R210005_TOP                           - Report ZC1R210005
*&---------------------------------------------------------------------*
REPORT zc1r210005 MESSAGE-ID zmcsa21.

TABLES : scarr, sflight.

DATA: BEGIN OF gs_data,
        carrid    TYPE scarr-carrid,
        carrname  TYPE scarr-carrname,
        connid    TYPE sflight-connid,
        fldate    TYPE sflight-fldate,
        planetype TYPE sflight-planetype,
        price     TYPE sflight-price,
        currency  TYPE sflight-currency,
        url       TYPE scarr-url,
      END OF gs_data,

      gt_data LIKE TABLE OF gs_data.

"on double click

data: BEGIN OF gs_sbook,
  carrid      TYPE sbook-carrid     ,
  connid      TYPE sbook-connid     ,
  fldate      TYPE sbook-fldate     ,
  bookid      TYPE sbook-bookid     ,
  customid    TYPE sbook-customid   ,
  custtype    TYPE sbook-custtype   ,
  luggeweight TYPE sbook-luggweight,
  wunit TYPE sbook-carrid,
  END OF gs_sbook,

  gt_sbook like TABLE OF gs_sbook.

"alv data
DATA : gcl_container TYPE REF TO cl_gui_docking_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layout     TYPE lvc_s_layo,
       gs_variant    TYPE disvariant.

"alv data
DATA : gcl_container_pop     TYPE REF TO cl_gui_custom_container,
       gcl_grid_pop          TYPE REF TO cl_gui_alv_grid,
       gs_fcat_pop           TYPE lvc_s_fcat,
       gt_fcat_pop           TYPE lvc_t_fcat,
       gs_layout_pop         TYPE lvc_s_layo,
       gs_variant_pop        TYPE disvariant.
DATA gv_okcode TYPE sy-ucomm.
