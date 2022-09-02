*&---------------------------------------------------------------------*
*& Include SAPMZC1210001_TOP                        - Module Pool      SAPMZC1210001
*&---------------------------------------------------------------------*
PROGRAM SAPMZC1210001 MESSAGE-ID zmcsa21.

data : BEGIN OF gs_data,
      matnr TYPE ZTSA2109-matnr, "Material
      werks TYPE ZTSA2109-werks, "plant
      mtatr TYPE ZTSA2109-mtatr, "Mat.Type
      matkl TYPE ZTSA2109-matkl, "mat.group
      menge TYPE ZTSA2109-menge, "Quantity
      meins TYPE ZTSA2109-meins, "Unit
      dmbtr TYPE ZTSA2109-dmbtr, "Price
      waers TYPE ZTSA2109-waers, "Currency
  END OF gs_data,

       gt_data like TABLE OF gs_data,
       gv_okcode TYPE sy-ucomm.

* ALV 관련
DATA : gcl_container TYPE REF TO cl_gui_custom_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layout     TYPE lvc_s_layo,
       gs_variant    TYPE disvariant.
