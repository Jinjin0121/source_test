*&---------------------------------------------------------------------*
*& Module Pool      ZTEST_09_A21
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZTEST_09_A21TOP                         .    " Global Data

 INCLUDE ZTEST_09_A21S01                         .  " Selecion-Screen
 INCLUDE ZTEST_09_A21O01                         .  " PBO-Modules
 INCLUDE ZTEST_09_A21I01                         .  " PAI-Modules
 INCLUDE ZTEST_09_A21F01                         .  " FORM-Routines

 START-OF-SELECTION.
 PERFORM get_data.
 call SCREEN 100.
