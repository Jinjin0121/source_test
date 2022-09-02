*&---------------------------------------------------------------------*
*& Include          ZC1R210005_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'S100'.
 SET TITLEBAR 'T100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_LAYOUT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_layout OUTPUT.
PERFORM set_layout.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module DISPLAY_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE display_screen OUTPUT.
PERFORM display_screen.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0101 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0101 OUTPUT.
 SET PF-STATUS 'S101'.
 SET TITLEBAR 'T101'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_FCAT_LAYOUT_0101 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_fcat_layout_0101 OUTPUT.

gs_layout_pop-zebra = 'X'.
gs_layout_pop-sel_mode = 'D'.
gs_layout_pop-no_toolbar = 'X'.

"유닛은 단위가 필요하다.
PERFORM set_fcat_pop using :
      'X' 'CARRID'     'SBOOK' 'CARRID'     ' ',
      'X' 'CONNID'     'SBOOK' 'CONNID'     ' ',
      'X' 'FLDAYE'     'SBOOK' 'FLDAYE'     ' ',
      'X' 'BOOKID'     'SBOOK' 'BOOKID'     ' ',
      ' ' 'CUSTOMID'   'SBOOK' 'CUSTOMID'   ' ',
      ' ' 'CUSTTYPE'   'SBOOK' 'CUSTTYPE'   ' ',
      ' ' 'LUGGWEIGHT' 'SBOOK' 'LUGGWEIGHT' 'WUNIT ',
      ' ' 'WUNIT'      'SBOOK' 'WUNIT'      ' '.
ENDMODULE.
