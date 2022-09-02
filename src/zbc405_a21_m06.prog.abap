*&---------------------------------------------------------------------*
*& Module Pool      ZBC405_A21_M06
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zbc405_a21_m06_top                      .    " Global Data

* INCLUDE ZBC405_A21_M06_O01                      .  " PBO-Modules
* INCLUDE ZBC405_A21_M06_I01                      .  " PAI-Modules
* INCLUDE ZBC405_A21_M06_F01                      .  " FORM-Routines

*멘토링 테스트 <ztsa2001 : 사원테이블>


"Select Single
*SELECT SINGLE pernr ename depid gender
*  FROM ztsa2001
*  INTO CORRESPONDING FIELDS OF gs_emp
*  WHERE pernr = '20220001'.
*
*WRITE : '사원명' , gs_emp-pernr.
*NEW-LINE.
*WRITE : 'EMANE' , gs_emp-ename.
*NEW-LINE.
*WRITE : '부서코드' , gs_emp-depid.
*WRITE :/ '성별' , gs_emp-gender.


"loop 문
*SELECT *
*  FROM ztsa2001
*  INTO CORRESPONDING FIELDS OF TABLE gt_emp.



*CLEAR gs_emp.
*LOOP AT gt_emp INTO gs_emp.
*  "gs_emp 수정
*  CASE gs_emp-gender.
*    WHEN '1'.
*      gs_emp-gender_t = '남성'.
*    WHEN '2'.
*      gs_emp-gender_t = '여성'.
*  ENDCASE.
*
*  SELECT SINGLE phone
*    FROM ztsa2002
*    INTO CORRESPONDING FIELDS OF gs_emp
*    WHERE depid = gs_emp-depid.
*
*  CASE gs_emp-ename.
*    WHEN '기안'.
*      gs_emp-gender = '1'.
*  ENDCASE.
*
*  MODIFY gt_emp FROM gs_emp.
*ENDLOOP.

SELECT *
  FROM ztsa2001
  INTO CORRESPONDING FIELDS OF TABLE gt_emp.

SELECT *
  FROM ztsa2002
  INTO CORRESPONDING FIELDS OF TABLE gt_dep
  WHERE depid BETWEEN 'D001' and 'D003'.

"READTABLE
  CLEAR gs_emp.

LOOP at gt_emp INTO gs_emp.
  "gs_emp
  READ TABLE gt_dep into gs_dep

  "key의 기준은 loop into 를 기준으로 한다.
  with key depid = gs_emp-depid.

  gs_emp-phone = gs_dep-phone.

  MODIFY gt_emp FROM gs_emp.
  CLEAR : gs_emp, gs_dep.
  endloop.

cl_demo_output=>display_data( gt_emp ).
