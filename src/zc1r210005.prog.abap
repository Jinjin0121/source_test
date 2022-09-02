*&---------------------------------------------------------------------*
*& Report ZC1R210005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r210005_top                          .    " Global Data

INCLUDE zc1r210005_s01                          .  " Selection-Screen
INCLUDE zc1r210005_c01                          .  " Local-CLASS
INCLUDE zc1r210005_o01                          .  " PBO-Modules
INCLUDE zc1r210005_i01                          .  " PAI-Modules
INCLUDE zc1r210005_f01                          .  " FORM-Routines

START-OF-SELECTION.

  PERFORM get_data.

  CALL SCREEN 100.
