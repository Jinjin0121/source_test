*&---------------------------------------------------------------------*
*& Report ZC1R210004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZC1R210004_TOP                          .    " Global Data

 INCLUDE ZC1R210004_S01                          .  " Selection Screen
 INCLUDE ZC1R210004_C01                          .  " Local Class
 INCLUDE ZC1R210004_O01                          .  " PBO-Modules
 INCLUDE ZC1R210004_I01                          .  " PAI-Modules
 INCLUDE ZC1R210004_F01                          .  " FORM-Routines

 START-OF-SELECTION.

 PERFORM get_flight_list.
 PERFORM set_carrname.

 call SCREEN '0100'.
