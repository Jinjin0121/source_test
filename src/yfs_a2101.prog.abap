*&---------------------------------------------------------------------*
*& Report YTEST0001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT yfs_a2101.

TYPES : BEGIN OF wa,
          field1(3) TYPE c,
          field2(3) TYPE c,
        END OF wa.
DATA : ws   TYPE wa,
       gtab TYPE TABLE OF line.

data : f_value type c length 4.
FIELD-SYMBOLS : <fs> LIKE ws.
FIELD-SYMBOLS : <fs1> .
field-symbols : <fs2>.


assign f_value to <fs2>.
<fs2> = 'BBBB'.
assign f_value to <fs1>.
<fs1> = 'AAAA'.

write : / <Fs2>, f_value, <Fs1>.

*ASSIGN ws TO <fs>.
*<fs>-field1 = 'AAA'.
*WRITE :/ <fs>-field1, ws-field1 .




*
*
*
**-----
* any 타입은 모든 타입을 허용하는 것을 의미한다.
*FIELD-SYMBOLS : <fn> TYPE any.
*DATA : wa_cosp TYPE cosp.
*DATA : sum_12 LIKE cosp-wtg001.
*
*DATA : fname(20).
*DATA : nn(2) TYPE n.
*
*
*DO 12 TIMES.
*  nn = nn + 1.
*  CONCATENATE 'WA_COSP-WTG0' nn INTO fname.
*  CONDENSE fname.
*  ASSIGN (fname) TO <fn>.
*  <fn> = sy-index.
*  sum_12 = sum_12 + <fn>.
*  WRITE : / <fn>.
*ENDDO.
*WRITE : /   sum_12.
*
*
*
*DATA : BEGIN OF gs_str,
*         col1 TYPE char5 VALUE 'KOREA',
*         col2 TYPE char10 VALUE 'SEOUL',
*         col3 TYPE char15 VALUE 'DMC',
*       END OF gs_str.
*
*FIELD-SYMBOLS : <fstr> LIKE gs_str,
*                <fch>  TYPE any.
*
*ASSIGN gs_str TO <fstr>.
*
*new-line.
*DO 3 TIMES.
*  ASSIGN COMPONENT sy-index OF STRUCTURE <fstr> TO <fch>.
*  WRITE <fch>.
*ENDDO.
*
*
*
*
*
*
**---iieldcatalog를 이용한  예제
*FIELD-SYMBOLS : <lf> TYPE lvc_s_fcat.
*FIELD-SYMBOLS : <fn1>, <fn2>.
*DATA : lt_fcat TYPE lvc_t_fcat.
*
*DATA : gt_tab TYPE TABLE OF cosp.
*
*LOOP AT lt_fcat ASSIGNING <lf>.
*  IF <lf>-fieldname CS 'WTG'.
*
**-- 구조체의 필드를 field symbol 에 assign.
*    ASSIGN COMPONENT <lf>-fieldname OF STRUCTURE
*               gt_tab TO <fn1>.
*
*  ENDIF.
*
*ENDLOOP.
