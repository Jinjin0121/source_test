*&---------------------------------------------------------------------*
*& Include ZC1R210001_TOP                           - Report ZC1R210001
*&---------------------------------------------------------------------*
REPORT zc1r210001 MESSAGE-ID zmcsa21.

TABLES: sflight.

DATA : BEGIN OF gs_data,
         carrid    TYPE sflight-carrid,
         connid    TYPE sflight-connid,
         fldate    TYPE sflight-fldate,
         price     TYPE sflight-price,
         currency  TYPE sflight-currency,
         planetype TYPE sflight-planetype,
       END OF gs_data,

       gt_data LIKE TABLE OF gs_data.

data : gv_okcode TYPE sy-ucomm.


* ALV
DATA : gcl_container TYPE REF TO cl_gui_docking_container, "docking 사이즈 제한이 없어 doking을 쓴다.
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,                      "Table 타입이기때문에 table of 를 생략한다.
       gs_layout     TYPE lvc_s_layo,
       gs_variant    TYPE disvariant.
