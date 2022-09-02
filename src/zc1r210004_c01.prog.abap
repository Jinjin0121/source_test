*&---------------------------------------------------------------------*
*& Include          ZC1R210004_C01
*&---------------------------------------------------------------------*

CLASS lcl_event_handler DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS: handle_double_click FOR EVENT double_click OF cl_gui_alv_grid
      IMPORTING e_row e_column.

ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.
 METHOD handle_double_click.
  PERFORM handle_double_click USING e_row e_column.
   ENDMETHOD.
ENDCLASS.
