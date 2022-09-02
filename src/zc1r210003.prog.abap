*&---------------------------------------------------------------------*
*& Report ZC1R210003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r210003_top                          .    " Global Data

INCLUDE zc1r210003_s01                          .  " Selection-screen
INCLUDE zc1r210003_c01                          .  " Selection-screen
INCLUDE zc1r210003_o01                          .  " PBO-Modules
INCLUDE zc1r210003_i01                          .  " PAI-Modules
INCLUDE zc1r210003_f01                          .  " FORM-Routines

START-OF-SELECTION.

  PERFORM get_data.
  PERFORM set_MAKTX.
  CALL SCREEN '0100'.
