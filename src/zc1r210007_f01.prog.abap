*&---------------------------------------------------------------------*
*& Include          ZC1R210007_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .
  CLEAR   gs_data.
  REFRESH gt_data.

  SELECT pernr ename entdt geder depid carrid
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM ztsa2101
    WHERE pernr IN so_per.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_layout .

  gs_layout-zebra = 'X'.
  gs_layout-cwidth_opt = 'X'.
  gs_layout-sel_mode = 'D'.

  PERFORM set_fcat USING :
        'X' 'PERNR'  ' ' 'ZTSA2101' 'PERNR' 'X'  10,
        ' ' 'ENAME'  ' ' 'ZTSA2101' 'ENAME' 'X'  20,
        ' ' 'ENTDT'  ' ' 'ZTSA2101' 'ENTDT' 'X'  30,
        ' ' 'GEDER'  ' ' 'ZTSA2101' 'GEDER' 'X'  10,
        ' ' 'DEPID'  ' ' 'ZTSA2101' 'DEPID' 'X'  10,
        ' ' 'CARRID' ' ' 'ZTSA2101' 'CARRID' 'X' 10.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_fcat  USING pv_key pv_field pv_text pv_ref_table pv_ref_field pv_edit pv_length.

  CLEAR : gs_fcat.

  IF gs_fcat IS INITIAL.

    gt_fcat = VALUE #( BASE gt_fcat
                     ( key       = pv_key
                       fieldname = pv_field
                       coltext   = pv_text
                       ref_table = pv_ref_table
                       ref_field = pv_ref_field
                       edit      = pv_edit
                       outputlen = pv_length ) ).
*
*    APPEND gs_fcat TO gt_fcat.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv .

  IF gcl_con IS NOT BOUND.
    CREATE OBJECT gcl_con
      EXPORTING
        repid     = sy-repid
        dynnr     = sy-dynnr
        side      = gcl_con->dock_at_left
        extension = 3000.

    CREATE OBJECT gcl_grid
      EXPORTING
        i_parent = gcl_con.

    CALL METHOD gcl_grid->set_table_for_first_display
      EXPORTING
        is_variant      = gs_variant
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout
      CHANGING
        it_outtab       = gt_data
        it_fieldcatalog = gt_fcat.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save .

  DATA : lt_save     TYPE TABLE OF ztsa2101,
         lv_error    ,
         lv_cnt      TYPE i,
         lt_data_del TYPE TABLE OF ztsa2101.

  REFRESH lt_save.

  CALL METHOD gcl_grid->check_changed_data.

  CLEAR lv_error. "?????? ????????? ?????? ?????? ??????
  LOOP AT gt_data INTO gs_data.


    IF gs_data-pernr IS INITIAL.
      MESSAGE s000 WITH TEXT-e01 DISPLAY LIKE 'E'.
      lv_error = 'X'. "??????????????? ?????? ?????? ?????? ????????? ???????????? ????????? ?????? ??????
      EXIT.            "?????? ???????????? ????????? ???????????? : ?????? loop ???????????? perfrom ??????
    ENDIF.

    lt_save = VALUE #( BASE lt_save "????????????????????? ??????
                        (
                         pernr  = gs_data-pernr
                         ename  = gs_data-ename
                         entdt  = gs_data-entdt
                         geder = gs_data-geder
                         depid  = gs_data-depid
                         carrid = gs_data-carrid
                         )
                         ).
  ENDLOOP.


  "????????? ????????? ?????? ?????? ??????
*CHECK lv_error is INITIAL.
  IF lv_error IS NOT INITIAL. "????????? ???????????? ?????? ?????? ????????????
    EXIT.
  ENDIF.

  IF lt_data_del IS NOT INITIAL.
    LOOP AT lt_data_del INTO DATA(gs_data_del).
      lt_data_del = VALUE #( BASE lt_data_del
                        ( pernr = gs_data-pernr )
                        ).
    ENDLOOP.
    DELETE ztsa2101 FROM TABLE lt_data_del.

    IF sy-dbcnt > 0.
      lv_cnt = lv_cnt + sy-dbcnt.
    ENDIF.

    IF lt_save IS NOT INITIAL.
      MODIFY ztsa2101 FROM TABLE lt_save.

      IF sy-dbcnt > 0. " ???????????? ?????????
        lv_cnt = lv_cnt + sy-dbcnt. "commit ??? ????????? ????????????????????? ??????????????? ????????? ??????.

      ENDIF.

      IF lv_cnt > 0.
        COMMIT WORK AND WAIT.
        MESSAGE s002 WITH TEXT-s01 .
      ENDIF.
    ENDIF.
    ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_row
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_row .

  CLEAR gs_data.
  APPEND gs_data TO gt_data.

  PERFORM refrshe_grid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form refrshe_grid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refrshe_grid .

  gs_stable-row = 'X'.
  gs_stable-col = 'X'.

  CALL METHOD gcl_grid->refresh_table_display
    EXPORTING
      is_stable      = gs_stable
      i_soft_refresh = space.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form delete_row
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM delete_row .

  REFRESH gt_rows.

  CALL METHOD gcl_grid->get_selected_rows
    IMPORTING
      et_index_rows = gt_rows.

  IF gt_rows IS INITIAL. "?????? ??????????????? ??????
    MESSAGE s000 WITH TEXT-e02 DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  SORT gt_rows BY index DESCENDING. "????????? ?????? ???????????? ????????? ??????

  LOOP AT gt_rows INTO gs_rows.

  READ TABLE gt_data INTO gs_data INDEX gs_rows-index.

  IF sy-subrc EQ 0.
    APPEND gs_data TO gt_data_del. " ?????? ????????? ?????? ???????????? ??????
  ENDIF.


    DELETE gt_data INDEX gs_rows-index. "???????????? ????????? ?????? ?????? ??????

  ENDLOOP.
  PERFORM refresh_grid.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form refresh_grid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_grid .

ENDFORM.
