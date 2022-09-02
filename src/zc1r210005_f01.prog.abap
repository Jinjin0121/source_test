*&---------------------------------------------------------------------*
*& Include          ZC1R210005_F01
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

  CLEAR : gs_data, gt_data.

  SELECT a~carrid a~carrname b~connid b~fldate
         b~planetype b~price b~currency a~url
   INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM scarr AS a
    INNER JOIN sflight AS b
       ON a~carrid    = b~carrid
    WHERE a~carrid    IN so_carr
      AND b~connid    IN so_conn
      AND b~planetype IN so_plan.

  IF sy-subrc NE 0.
    MESSAGE s100.
    LEAVE LIST-PROCESSING.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layout .

  gs_layout-zebra      = 'X'.
  gs_layout-sel_mode   = 'D'.
  gs_layout-cwidth_opt = 'X'.

  IF gt_fcat IS INITIAL.
    PERFORM set_fcat USING :
        'X' 'CARRID'    '바꿈' 'SCARR'    'CARRID'    ' ',
        ' ' 'CARRNAME'  ' '   'SCARR'    'CARRNAME'  ' ',
        ' ' 'CONNID'    ' '   'SFLIGHT'  'CONNID'    ' ',
        ' ' 'FLDATE'    ' '   'SFLIGHT'  'FLDATE'    ' ',
        ' ' 'PLANETYPE' ' '   'SFLIGHT'  'PLANETYPE' ' ',
        ' ' 'PRICE'     ' '   'SFLIGHT'  'PRICE'     'CURRENCY',
        ' ' 'CURRENCY'  ' '   'SFLIGHT'  'CURRENCY'  ' ',
        ' ' 'URL'       ' '   'SCARR'    'URL'       ' '.


*          'X' 'CARRID'    ' ' 'SCARR'   'CARRID'  ,
*          ' ' 'CARRNAME'  ' ' 'SCARR'   'CARRNAME',
*          ' ' 'CONNID'    ' ' 'SFLIGHT' 'CONNID'  ,
*          ' ' 'FLDATE'    ' ' 'SFLIGHT' 'FLDATE'  ,
*          ' ' 'PLANETYPE' ' ' 'SFLIGHT' 'PLANETYPE',
*          ' ' 'PRICE'     ' ' 'SFLIGHT' 'PRICE'    ,
*          ' ' 'CURRENCY'  ' ' 'SFLIGHT' 'CURRENCY' ,
*          ' ' 'URL'       ' ' 'SCARR'   'URL'      .
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
FORM set_fcat  USING pv_key pv_field pv_text pv_ref_table pv_ref_field pv_curr.

  CLEAR gs_fcat.

  gs_fcat-key = pv_key.
  gs_fcat-fieldname  =  pv_field.
  gs_fcat-coltext    =  pv_text.
  gs_fcat-ref_table  =  pv_ref_table.
  gs_fcat-ref_field  =  pv_ref_field.
  gs_fcat-cfieldname =  pv_curr.

  APPEND gs_fcat TO gt_fcat.


*  gs_fcat = VALUE #( key = pv_key
*                     fieldname = pv_field
*                     coltext   = pv_text
*                     ref_table = pv_ref_table
*                     ref_field = pv_ref_field ).
*
*  CASE pv_field.
*    WHEN 'PRICE'.
*      gs_fcat = VALUE #( BASE gs_fcat
*                          cfieldname = 'CURRNECY' ).
*  ENDCASE.
*
*  APPEND gs_fcat TO gt_fcat.

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

  IF gcl_container IS NOT BOUND.
    CREATE OBJECT gcl_container
      EXPORTING
        repid     = sy-repid
        dynnr     = sy-dynnr
        side      = gcl_container->dock_at_left
        extension = 3000.

    CREATE OBJECT gcl_grid
      EXPORTING
        i_parent = gcl_container.

    SET HANDLER lcl_event_handler=>on_double_click FOR gcl_grid.

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
