*&---------------------------------------------------------------------*
*& Include ZSA_JIN01TOP                             - Report ZSA_JIN01
*&---------------------------------------------------------------------*
REPORT zsa_jin01.

DATA: gs_main TYPE dv_flights.

"스크린 생성
SELECTION-SCREEN BEGIN OF SCREEN 1100 AS SUBSCREEN.
  SELECT-OPTIONS so_car for gs_main-carrid.
SELECTION-SCREEN END OF SCREEN 1100.

"Tab Screen
SELECTION-SCREEN BEGIN OF TABBED BLOCK jin FOR 5 LINES.
  SELECTION-SCREEN TAB (20) tab1 USER-COMMAND jin01 DEFAULT SCREEN 1100.
SELECTION-SCREEN END OF BLOCK jin.
