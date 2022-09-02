*&---------------------------------------------------------------------*
*& Include ZC1R210007_TOP                           - Report ZC1R210007
*&---------------------------------------------------------------------*
REPORT zc1r210007 MESSAGE-ID zmcsa21.

TABLES :ztsa2101.

DATA : BEGIN OF gs_data.
         .INCLUDE TYPE ztsa2101.
DATA END OF gs_data.

DATA gt_data LIKE TABLE OF gs_data.

data gt_data_del LIKE TABLE OF gs_data.
"alv

DATA: gcl_con    TYPE REF TO cl_gui_docking_container,
      gcl_grid   TYPE REF TO cl_gui_alv_grid,
      gs_fcat    TYPE lvc_s_fcat,
      gt_fcat    TYPE lvc_t_fcat,
      gs_layout  TYPE lvc_s_layo,
      gs_variant TYPE disvariant,
      gs_stable  TYPE lvc_s_stbl.

"Delete
data : gt_rows   TYPE lvc_t_row, "선택한 행의 데이터를 저장할 테이블
       gs_rows   TYPE lvc_s_row.

DATA gv_okcode TYPE sy-ucomm.
