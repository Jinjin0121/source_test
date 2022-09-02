*&---------------------------------------------------------------------*
*& Include          ZC1R210003_F01
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

  CLEAR gs_data.
  _clear gt_data.

  SELECT a~matnr a~stlan a~stlnr a~stlal b~mtart b~matkl "c~maktx
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM mast AS a
    INNER JOIN mara AS b
       ON a~matnr = b~matnr
*    LEFT OUTER JOIN makt AS c
*       ON a~matnr = c~matnr
*      AND c~spras = sy-langu
    WHERE a~werks = pa_wer
      AND a~matnr IN so_mat.


  IF sy-subrc NE 0.
    MESSAGE s001.
    LEAVE LIST-PROCESSING. "STOP.
  ENDIF.



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
  gs_layout-sel_mode = 'D'.
  gs_layout-cwidth_opt = 'X'.

  IF gt_fcat IS INITIAL.

    PERFORM set_fcat USING :
      'X'   'MATNR'       ' '   'MAST' 'MATNR',
      ' '   'MAKTX'       ' '   'MAKT' 'MAKTX',
      ' '   'STLAN'       ' '   'MAST' 'STLAN',
      ' '   'STLNR'       ' '   'MAST' 'STLNR',
      ' '   'STLAL'       ' '   'MAST' 'STLAL',
      ' '   'MTARY'       ' '   'MARA' 'MTART',
      ' '   'MATKL'       ' '   'MARA' 'MATKL'.
  ENDIF.
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
FORM set_fcat  USING   pv_key pv_field pv_text pv_ref_table pv_ref_field.

  gs_fcat = VALUE #(
                       key = pv_key
                        fieldname = pv_field
                        coltext   = pv_text
                        ref_table = pv_ref_table
                        ref_field = pv_ref_field

                        ).

  CASE pv_field.
    WHEN 'STLNR'.
      gs_fcat-hotspot = 'X'.
  ENDCASE.

*  gs_fcat-key       = pv_key       .
*  gs_fcat-fieldname = pv_field .
*  gs_fcat-coltext   = pv_text   .
*  gs_fcat-ref_table = pv_ref_table .
*  gs_fcat-ref_field = pv_ref_field .
*
  APPEND gs_fcat TO gt_fcat.
*  CLEAR gs_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_screen .

  IF gcl_container IS INITIAL.

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

    IF gcl_handler IS NOT BOUND.
      CREATE OBJECT gcl_handler.
    ENDIF.

    SET HANDLER : gcl_handler->handle_double_click FOR gcl_grid,
                  gcl_handler->handle_hotspot      FOR gcl_grid.

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
*& Form handle_double_click
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW
*&      --> E_COLUMN
*&---------------------------------------------------------------------*
FORM handle_double_click  USING ps_row    TYPE lvc_s_row
                                ps_column TYPE lvc_s_col.

  READ TABLE gt_data INTO gs_data INDEX ps_row-index.

  IF sy-subrc NE 0.
    EXIT.
  ENDIF.

  CASE ps_column-fieldname.
    WHEN 'MATNR'.
      IF gs_data-matnr IS INITIAL.
        EXIT.
      ENDIF.

      SET PARAMETER ID : 'MAT' FIELD gs_data-matnr.
      CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_hotspot
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW_ID
*&      --> E_COLUMN_ID
*&---------------------------------------------------------------------*
FORM handle_hotspot  USING    ps_row_id    TYPE lvc_s_row
                              ps_column_id TYPE lvc_s_col.

  READ TABLE gt_data INTO gs_data INDEX ps_row_id-index.

  IF sy-subrc NE 0.
    EXIT.
  ENDIF.

  CASE ps_column_id-fieldname.
    WHEN 'STLNR'.
      IF gs_data-stlnr IS INITIAL.
        EXIT.
      ENDIF.
      SET PARAMETER ID : 'MAT' FIELD gs_data-matnr,
                         'WRK' FIELD pa_wer,
                         'CSV' FIELD gs_data-stlan.

      CALL TRANSACTION 'CS03' AND SKIP FIRST SCREEN.

  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_MAKTX
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_maktx .

  IF gcl_maktx IS NOT BOUND.

    CREATE OBJECT gcl_maktx.

  ENDIF.

  LOOP AT gt_data INTO gs_data.

    CALL METHOD gcl_maktx->get_makt_text
      EXPORTING
        pi_matnr = gs_data-matnr
      IMPORTING
        pe_maktx = gs_data-maktx.

    MODIFY gt_data FROM gs_data INDEX sy-tabix.
  ENDLOOP.

ENDFORM.
