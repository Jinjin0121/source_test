*&---------------------------------------------------------------------*
*& Include ZC1R210003_TOP                           - Report ZC1R210003
*&---------------------------------------------------------------------*
REPORT zc1r210003 MESSAGE-ID zmcas21.

CLASS lcl_event_handler DEFINITION DEFERRED.

DATA: BEGIN OF gs_data,
        matnr TYPE mast-matnr,
        maktx TYPE makt-maktx,
        stlan TYPE mast-stlan,
        stlnr TYPE mast-stlnr,
        stlal TYPE mast-stlal,
        mtart TYPE mara-mtart,
        matkl TYPE mara-matkl,
      END OF gs_data,

      gt_data LIKE TABLE OF gs_data.

" ALV 관련
DATA : gcl_container TYPE REF TO cl_gui_docking_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gcl_maktx     TYPE REF TO ZCLC121_0002,
       gcl_handler   TYPE REF TO lcl_event_handler,
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layout     TYPE lvc_s_layo,
       gs_variant    TYPE disvariant.

data : gs_maktx      TYPE makt-maktx.

DATA : gv_okcode TYPE sy-ucomm.

* 메크로
DEFINE _clear.

  CLEAR   &1.
  REFRESH &1.

end-OF-DEFINITION.
