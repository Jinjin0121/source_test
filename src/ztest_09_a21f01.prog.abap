*&---------------------------------------------------------------------*
*& Include          ZTEST_09_A21F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form display_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_screen .

  IF gcl_container IS NOT INITIAL.

    CREATE OBJECT gcl_container
      EXPORTING
        repid     = sy-repid
        dynnr     = sy-dynnr
        side      = gcl_container->dock_at_left
        extension = 3000.

    CREATE OBJECT gcl_grid
      EXPORTING
        i_parent = gcl_container.

    gs_variant-report = sy-repid.

    CALL METHOD gcl_grid->set_table_for_first_display
      EXPORTING
*
        is_variant = gs_variant
        i_save     = 'A'
        i_default  = 'X'
        is_layout  = gs_layout
      CHANGING
        it_outtab  = gt_mast.
        it_fieldcatalog = gt_fcat.

  ENDIF.
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

  CLEAR gs_mast.
  REFRESH gt_mast.

  SELECT a~matnr a~stlan a~stlnr a~stlal b~mtart b~matkl c~maktx
    INTO CORRESPONDING FIELDS OF TABLE gt_mast
    FROM mast AS a
    INNER JOIN mara AS b
    ON a~matnr = b~matnr
    LEFT OUTER JOIN makt as c
    on a~matnr = c~matnr
    and c~spras = sy-langu
    WHERE a~werks = pa_wer
    AND a~matnr in so_mat.


    IF sy-subrc NE 0.
    LEAVE LIST-PROCESSING. "STOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Module LAYOUT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE layout OUTPUT.
PERFORM layout.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM layout .

  gs_layout-zebra      = 'X'.
  gs_layout-sel_mode   = 'D'.
  gs_layout-cwidth_opt = 'X'.

IF gt_fcat IS INITIAL.
  PERFORM set_fact USING :
    'X'   'MATNR'       ' '   'MAST' 'MATNR',
    ' '   'MAKTX'       ' '   'MAKT' 'MAKTX',
    ' '   'STLAN'       ' '   'MAST' 'STLAN',
    ' '   'STLNR'       ' '   'MAST' 'STLNR',
    ' '   'STLAL'       ' '   'MAST' 'STLAL',
    ' '   'MTARY'       ' '   'MARA' 'MTART',
    ' '   'MATKL'       ' '   'MARA' 'MATKL'.
  endif.
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
*&---------------------------------------------------------------------*
FORM set_fact  USING   pv_key pv_field pv_text pv_ref_table pv_ref_field.

  gs_fcat-key       = pv_key.
  gs_fcat-fieldname = pv_field.
  gs_fcat-coltext   = pv_text.
  gs_fcat-ref_table = pv_ref_table.
  gs_fcat-ref_field = pv_ref_field.

  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.
ENDFORM.
