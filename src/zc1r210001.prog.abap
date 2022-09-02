*&---------------------------------------------------------------------*
*& Report ZC1R210001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r210001_top                          .    " Global Data

INCLUDE zc1r210001_s01                          .  " Selection Scrren
INCLUDE zc1r210001_o01                          .  " PBO-Modules
INCLUDE zc1r210001_i01                          .  " PAI-Modules
INCLUDE zc1r210001_f01                          .  " FORM-Routines

INITIALIZATION.
  PERFORM init_param.

START-OF-SELECTION.
  PERFORM get_data.

  CALL SCREEN 100.
