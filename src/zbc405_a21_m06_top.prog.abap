*&---------------------------------------------------------------------*
*& Include ZBC405_A21_M06_TOP                       - Module Pool      ZBC405_A21_M06
*&---------------------------------------------------------------------*
PROGRAM zbc405_a21_m06.

TYPES : BEGIN OF ts_emp,
          pernr        TYPE ztsa2001-pernr,
          ename        TYPE ztsa2001-ename,
          depid        TYPE ztsa2001-depid,
          gender       TYPE ztsa2001-gender,
          gender_t(10),
          phone        TYPE ztsa2002-phone,
        END OF ts_emp.

DATA : gs_emp TYPE ts_emp,
       gt_emp LIKE TABLE OF gs_emp,
       gs_dep TYPE ztsa2002,
       gt_dep LIKE TABLE OF gs_dep.
