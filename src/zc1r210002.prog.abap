*&---------------------------------------------------------------------*
*& Report ZC1R210002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZC1R210002TOP                           .    " Global Data

 INCLUDE ZC1R210002S01                           .  " Selection-Scrren
 INCLUDE ZC1R210002O01                           .  " PBO-Modules
 INCLUDE ZC1R210002I01                           .  " PAI-Modules
 INCLUDE ZC1R210002F01                           .  " FORM-Routines

 START-OF-SELECTION.

 PERFORM get_data.

 call SCREEN 100.
