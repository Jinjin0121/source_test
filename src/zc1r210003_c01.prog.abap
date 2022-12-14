*&---------------------------------------------------------------------*
*& Include          ZC1R210003_C01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Class lcl_evrnt_handler
*&---------------------------------------------------------------------*
*&*클래스의 속성 : Inheritance   (상속성)
*&*클래스의 속성 : Encapsulation (캡슐화)
*&*클래스의 속성 : Polymorpgism  (다형성)
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS :
      handle_double_click FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row e_column,

      handle_hotspot for EVENT hotspot_click of cl_gui_alv_grid
        IMPORTING e_row_id e_column_id.

ENDCLASS.
*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_evrnt_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.
  METHOD handle_double_click.
    PERFORM handle_double_click USING e_row e_column.
    ENDMETHOD.

   METHOD handle_hotspot.
     PERFORM handle_hotspot USING e_row_id e_column_id.
     ENDMETHOD.
ENDCLASS.
