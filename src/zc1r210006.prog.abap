*&---------------------------------------------------------------------*
*& Report ZC1R210006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZC1R210006_TOP                          .    " Global Data

 INCLUDE ZC1R210006_s01                          .  " Selection
 INCLUDE ZC1R210006_c01                          .  " Class
 INCLUDE ZC1R210006_O01                          .  " PBO-Modules
 INCLUDE ZC1R210006_I01                          .  " PAI-Modules
 INCLUDE ZC1R210006_F01                          .  " FORM-Routines

 START-OF-SELECTION.

PERFORM get_data.

call SCREEN 100.
