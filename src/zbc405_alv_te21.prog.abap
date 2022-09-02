*&---------------------------------------------------------------------*
*& Report ZBC405_ALV_TE21
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_alv_te21.

"데이터 선언
TABLES : zsflight_a21.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-a01.
  SELECT-OPTIONS: so_car FOR zsflight_a21-carrid OBLIGATORY MEMORY ID car,
                  so_con FOR zsflight_a21-connid MEMORY ID con,
                  so_fld FOR zsflight_a21-fldate MEMORY ID fld.

  PARAMETERS p_edit AS CHECKBOX.

SELECTION-SCREEN END OF BLOCK b1.

TYPES BEGIN OF gty_a21.
INCLUDE TYPE zsflight_a21.
TYPES END OF gty_a21.

DATA: gt_a21 TYPE TABLE OF gty_a21,
      gs_a21 LIKE LINE OF gt_a21.

"클래스 선언
DATA: go_container TYPE REF TO cl_gui_custom_container,
      go_alv       TYPE REF TO cl_gui_alv_grid,
      gs_layout    TYPE lvc_s_layo,
      gt_field     TYPE lvc_t_fcat,
      gs_field     TYPE lvc_s_fcat,
      bt           TYPE lvc_t_styl.

"셀렉트옵션 디폴트를 위한 변수 선언.
DATA : rt_def TYPE zz_range_type,
       rs_def TYPE zst03_carrid.

"이벤트 선언
INCLUDE zbc405_alv_te32_class.


INITIALIZATION.

  rs_def-low = 'AA'.
  rs_def-high = 'UA'.
  rs_def-sign = 'I'.
  rs_def-option = 'EQ'.
  APPEND rs_def TO rt_def.

  so_car[] = rt_def[].

START-OF-SELECTION.
  PERFORM select.


  CALL SCREEN 100.

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  LEAVE TO SCREEN 0.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create OUTPUT.

  IF go_container IS INITIAL.

    " 컨테이너 생성
    CREATE OBJECT go_container
      EXPORTING
        container_name = 'MY_AREA'
      EXCEPTIONS
        OTHERS         = 6.

    "그리드 생성
    CREATE OBJECT go_alv
      EXPORTING
        i_parent = go_container
      EXCEPTIONS
        OTHERS   = 5.

    "레이아웃 생성
    PERFORM layout.
    PERFORM filed.

    CALL METHOD go_alv->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified. " 엔터치는  순간 반영

    SET HANDLER event=>on_data_changed FOR go_alv.

    "디스플레이 화면
    CALL METHOD go_alv->set_table_for_first_display
      EXPORTING
*       i_buffer_active  =
*       i_bypassing_buffer            =
*       i_consistency_check           =
        i_structure_name = 'ZSFLIGHT_A21'
*       is_variant       =
*       i_save           =
*       i_default        = 'X'
        is_layout        = gs_layout
*       is_print         =
*       it_special_groups             =
*       it_toolbar_excluding          =
*       it_hyperlink     =
*       it_alv_graphics  =
*       it_except_qinfo  =
*       ir_salv_adapter  =
      CHANGING
        it_outtab        = gt_a21
        it_fieldcatalog  = gt_field
*       it_sort          =
*       it_filter        =
      EXCEPTIONS
*       invalid_parameter_combination = 1
*       program_error    = 2
*       too_many_lines   = 3
        OTHERS           = 4.

  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form PARA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM para .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form Select
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM select .

  SELECT *
    FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE gt_a21
    WHERE carrid IN so_car
    AND connid IN so_con.

    IF gs_a21-f= 'X'.
      gs_ct-fieldname = 'BTN_TEXT'.

      gs_ct-style = cl_gui_alv_grid=>mc_style_button.
      APPEND gs_ct TO gs_sbook-ct.


      gs_sbook-btn_text = 'Invoice'.
    ENDIF.
    MODIFY gt_sbook FROM gs_sbook

ENDFORM.
*&---------------------------------------------------------------------*
*& Form layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM layout .
  gs_layout-zebra = 'X'.
  gs_layout-cwidth_opt = 'X'.
  gs_layout-sel_mode = 'D'.

* modify style 을 쓰려면 layout style 을 선언하고 데이터선언도 필요하다.
*  gs_layout-stylefname = 'BT'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form filed
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM filed .
  gs_field-fieldname = 'PLANETYPE'.
  gs_field-edit = p_edit.
  APPEND gs_field TO gt_field.



ENDFORM.
