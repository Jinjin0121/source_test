*&---------------------------------------------------------------------*
*& Include          ZC1R210006_F01
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

  SELECT a~belnr a~buzei a~shkzg a~dmbtr a~hkont
         b~blart b~budat b~waers
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM bseg AS a
    INNER JOIN bkpf AS b
    ON a~bukrs = b~bukrs
    AND a~gjahr = b~gjahr
    WHERE b~bukrs = pa_bukr
      and b~gjahr = pa_gjah
      and b~belnr IN so_beln
      AND b~blart IN so_blar.


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

if gt_fact is INITIAL.

PERFORM set_fcat USING :
      'X' 'BELNR' ' ' 'BSEG' 'BELNR',
      'X' 'BUZEI' ' ' 'BSEG' 'BUZEI',
      ' ' 'BLART' ' ' 'BKPF' 'BLART',
      ' ' 'BUDAT' ' ' 'BKPF' 'BUDAT',
      ' ' 'SHKZG' ' ' 'BSEG' 'SHKZG',
      ' ' 'DMBTR' ' ' 'BSEG' 'DMBTR',
      ' ' 'WAERS' ' ' 'BKPF' 'WAERS',
      ' ' 'HKONT' ' ' 'BSEG' 'HKONT'.

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
FORM set_fcat  USING  pv_key pv_field pv_text pv_ref_table pv_ref_field.

  gs_fcat = VALUE #( key = pv_key
                     fieldname = pv_field
                     coltext   = pv_text
                     ref_table = pv_ref_table
                     ref_field = pv_ref_field ).

 case  pv_field.
   when



ENDFORM.
