*&---------------------------------------------------------------------*
*& Report YTEST0004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT yfs_a2107_alv.

TABLES : ztspfli_t03.

SELECT-OPTIONS : s_car FOR ztspfli_t03-carrid,
                 s_con FOR ztspfli_t03-connid.

TYPES : BEGIN OF ty_type.
          INCLUDE TYPE ztspfli_t03.
TYPES :   sum_amt TYPE  ztspfli_t03-wtg001.
TYPES : END OF ty_type.


DATA : gt_tab TYPE TABLE OF ty_type.
DATA : wa_tab TYPE ty_type.
DATA : fname(20).
DATA : nn(3) TYPE n.
DATA : sum_amt TYPE ztspfli_t03-wtg001.
FIELD-SYMBOLS : <fs> TYPE any.


DATA : gt_nametab TYPE TABLE OF dntab,
       gs_nametab TYPE dntab,
       lt_fcat    TYPE TABLE OF lvc_s_fcat,
       ls_fcat    LIKE LINE  OF lt_fcat.
FIELD-SYMBOLS : <lf> TYPE lvc_s_fcat.
DATA : go_alv_grid TYPE REF TO   cl_gui_alv_grid.



START-OF-SELECTION.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE gt_tab
         FROM ztspfli_t03
     WHERE carrid IN s_car AND
           connid IN s_con.




  CALL FUNCTION 'NAMETAB_GET'
    EXPORTING
      langu          = sy-langu
      tabname        = 'ZTSPFLI_T03'
    TABLES
      nametab        = gt_nametab
    EXCEPTIONS
      no_texts_found = 1.


  LOOP AT gt_nametab INTO gs_nametab
      WHERE  fieldname NE 'MANDT'.

    ls_fcat-fieldname =  gs_nametab-fieldname.
    ls_fcat-ref_table =  'ZTSPLFI_T03'.
    ls_fcat-ref_field =  gs_nametab-fieldname.
    ls_fcat-coltext   = gs_nametab-fieldtext.
    IF gs_nametab-fieldname(3) CS 'WTG'.
      ls_fcat-cfieldname = gs_nametab-reffield.
    ENDIF.
    APPEND  ls_fcat  TO lt_fcat.
  ENDLOOP.
  IF sy-subrc EQ 0.

    ls_fcat-fieldname = 'SUM_AMT'.
    ls_fcat-cfieldname = 'WAERS'.
    ls_fcat-coltext = 'SumAmt'.
    APPEND ls_fcat TO lt_fcat.
  ENDIF.


  DATA : l_tabix LIKE sy-tabix.
  LOOP AT gt_tab INTO wa_tab.

    l_tabix = sy-tabix.
    CLEAR : nn, wa_tab-sum_amt.
*    DO 7 TIMES.
*
*      nn  = nn + 1.
*      CONCATENATE 'WA_TAB-WTG' nn INTO fname.
*      CONDENSE fname.
*
*      ASSIGN (fname) TO <fs>.
*      wa_tab-sum_amt = wa_tab-sum_amt + <fs>.
*    ENDDO.

    LOOP AT lt_fcat ASSIGNING <lf>.
      IF <lf>-fieldname CS 'WTG'.

        ASSIGN COMPONENT <lf>-fieldname OF STRUCTURE
                   wa_tab TO <fs>.
        wa_tab-sum_amt = wa_tab-sum_amt + <fs>.
      ENDIF.
    ENDLOOP.
    MODIFY gt_tab FROM wa_tab INDEX l_tabix.
  ENDLOOP.
  WRITE space.

  CREATE OBJECT go_alv_grid
    EXPORTING
      i_parent = cl_gui_container=>screen0.

  CALL METHOD go_alv_grid->set_table_for_first_display
    CHANGING
      it_outtab       = gt_tab
      it_fieldcatalog = lt_fcat.
*
