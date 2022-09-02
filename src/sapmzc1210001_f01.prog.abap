*&---------------------------------------------------------------------*
*& Include          SAPMZC1210001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  F4_WERKS  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_werks INPUT.

  PERFORM f4_werks.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form f4_werks
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f4_werks .

  SELECT werks, name1, ekorg, land1
    INTO TABLE @DATA(lt_werks)
    FROM t001w.

  IF sy-subrc NE 0.
    MESSAGE s001.
    EXIT.
  ENDIF.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield     = 'WERKS'
      dynpprog     = sy-repid
      dynpnr       = sy-dynnr
      dynprofield  = 'GS_DATA-WERKS'
      window_title = TEXT-t01
      value_org    = 'S'
    TABLES
      value_tab    = lt_werks.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  SELECT matnr werks mtatr matkl menge meins
         dmbtr waers
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM ZTSA2109.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fact_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fact_layout .
  gs_layout-zebra = 'X'.
  gs_layout-cwidth_opt = 'X'.
  gs_layout-sel_mode = 'D'.

  IF gt_fcat IS INITIAL.

    PERFORM set_fact USING:
          'X' 'MATNR' ' ' 'ZTC1210001' 'MATNR' ''      '',
          'X' 'WERKS' ' ' 'ZTC1210001' 'WERKS' ''      '',
          ' ' 'MTART' ' ' 'ZTC1210001' 'MTART' ''      '',
          ' ' 'MATKL' ' ' 'ZTC1210001' 'MATKL' ''      '',
          ' ' 'MENGE' ' ' 'ZTC1210001' 'MENGE' 'MEINS' '',
          ' ' 'MEINS' ' ' 'ZTC1210001' 'MEINS' ''      '',
          ' ' 'DMBTR' ' ' 'ZTC1210001' 'DMBTR' ''      'WAERS',
          ' ' 'WAERS' ' ' 'ZTC1210001' 'WAERS' ''      ''.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fact
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_fact  USING pv_key
                     pv_field
                     pv_text
                     pv_ref_table
                     pv_ref_field
                     pv_qfield
                     pv_cfield.

  gt_fcat = VALUE #( BASE gt_fcat
                     (
                       key        = pv_key
                       fieldname  = pv_field
                       coltext    = pv_text
                       ref_table  = pv_ref_table
                       ref_field  = pv_ref_field
                       qfieldname = pv_qfield
                       cfieldname = pv_cfield
                       )
                       ).

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

  IF gcl_container IS NOT BOUND.
    CREATE OBJECT gcl_container
      EXPORTING
        container_name = 'GCL_CONTAINER'.

    CREATE OBJECT gcl_grid
      EXPORTING
        i_parent = gcl_container.

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
*& Form save_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_data .

  DATA : ls_save TYPE ZTSA2109.

  CLEAR   ls_save.

  IF gs_data-matnr IS INITIAL OR
     gs_data-werks IS INITIAL.
    MESSAGE s000 WITH TEXT-e01 DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  ls_save = CORRESPONDING #( gs_data ).

  MODIFY ZTSA2109 FROM ls_save.

  IF sy-dbcnt > 0. "직전에 변경된 데이터의 카운트
    COMMIT WORK AND WAIT.
    MESSAGE s000 WITH TEXT-m01.
  ELSE.
    ROLLBACK WORK.
    MESSAGE s000 WITH TEXT-m02 DISPLAY LIKE 'W'.
  ENDIF.
ENDFORM.
