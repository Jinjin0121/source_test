*&---------------------------------------------------------------------*
*& Include          ZC1R210005_C01
*&---------------------------------------------------------------------*

CLASS lcl_event_handler DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS :
      on_double_click FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row e_column.
ENDCLASS.
*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_evrnt_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_double_click.
  PERFORM on_double_click USING e_row
                                e_column.
  ENDMETHOD.
ENDCLASS.
*&---------------------------------------------------------------------*
*& Form on_double_click
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW
*&      --> E_COLUMN
*&---------------------------------------------------------------------*
FORM on_double_click  USING ps_row    TYPE lvc_s_row
                            ps_column TYPE lvc_t_row.

READ TABLE gt_data INTO gs_data INDEX ps_row-index.
if sy-subec ne 0.
  exit.
  endif.

 if ps_column-feldname ne 'PLANETYPE'.
   SELECT carrid   connid   fldate      bookid
          customid custtype luggweight wubit
     FROM sbook
     INTO CORRESPONDING FIELDS OF TABLE gt_sbook
     WHERE carrid   = gs_data-carrid
       and connid   = gs_data-connid
       and flcdate  = gs_data-fldate.

call SUBSCREEN '0101'   starting at

*   cl_demo_output=>display_data ( gt_sbook ).
endif.
ENDFORM.
