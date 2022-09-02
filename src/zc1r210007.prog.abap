*&---------------------------------------------------------------------*
*& Report ZC1R210007
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r210007_top                          .    " Global Data

INCLUDE zc1r210007_s01                          .  " Selction-screen
INCLUDE zc1r210007_o01                          .  " PBO-Modules
INCLUDE zc1r210007_i01                          .  " PAI-Modules
INCLUDE zc1r210007_f01                          .  " FORM-Routines

START-OF-SELECTION.
  PERFORM get_data.

  CALL SCREEN 100.
