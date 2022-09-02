*&---------------------------------------------------------------------*
*& Report ZBC405_A21_ALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zbc405_a21_alvtop                       .    " Global Data
*INCLUDE zbc405_a21_etop                       .    " Global Data

* INCLUDE ZBC405_A21_ALVO01                       .  " PBO-Modules
* INCLUDE ZBC405_A21_ALVI01                       .  " PAI-Modules
* INCLUDE ZBC405_A21_ALVF01                       .  " FORM-Routines

"신호등 데이터 선언
TYPES : BEGIN OF typ_flt.
          INCLUDE TYPE sflight.
TYPES :   btn_text TYPE c LENGTH 10. "버튼 텍스트
TYPES : it_styl TYPE lvc_t_styl.
TYPES : changes_possible TYPE icon-id. " 아이콘으로 보인다.
TYPES : light TYPE c LENGTH 1.
TYPES : row_color TYPE c LENGTH 4. " 필드 색상
TYPES : it_color TYPE lvc_t_scol. " 셀 색상
TYPES : tankcap TYPE saplane-tankcap.
TYPES : cap_unit TYPE saplane-cap_unit.
TYPES : weight TYPE saplane-weight.
TYPES : wei_unit TYPE saplane-wei_unit.
TYPES : END OF typ_flt.


DATA gs_flt TYPE typ_flt.
DATA gt_flt TYPE TABLE OF typ_flt.
DATA ok__code LIKE sy-ucomm.

*ALV data 선언
DATA: go_container TYPE REF TO cl_gui_custom_container,
      go_alv_grid  TYPE REF TO cl_gui_alv_grid,
      gv_variant   TYPE disvariant,
      gv_save      TYPE c LENGTH 1,
      gs_layout    TYPE lvc_s_layo,
      gt_sort      TYPE lvc_t_sort,
      gs_sort      TYPE lvc_s_sort,
      gs_color     TYPE lvc_s_scol,
      gt_exct      TYPE ui_functions, " excluding
      gt_fcat      TYPE lvc_t_fcat,
      gs_fcat      TYPE lvc_s_fcat,
      gs_styl      TYPE lvc_s_styl.

DATA : gs_stable       TYPE lvc_s_stbl,
       gv_soft_refresh TYPE abap_bool.

INCLUDE zbc405_a21_alv_class. " 이벤트 인클루드 선언

*Selection-screen
SELECT-OPTIONS: so_car FOR gs_flt-carrid MEMORY ID car,
                so_con FOR gs_flt-connid MEMORY ID con,
                so_dat FOR gs_flt-fldate.

SELECTION-SCREEN SKIP 1.

PARAMETERS: p_data TYPE sy-datum DEFAULT '20211001'.


PARAMETERS: pa_lv TYPE disvariant-variant.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_lv.

  gv_variant-report = sy-cprog.
  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load     = 'F' "S,F,L
    CHANGING
      cs_variant      = gv_variant
    EXCEPTIONS
      not_found       = 1
      wrong_input     = 2
      fc_not_complete = 3
      OTHERS          = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    pa_lv = gv_variant-variant.
  ENDIF.

START-OF-SELECTION.

  PERFORM get_data.



  CALL SCREEN 100.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100' WITH sy-datum sy-uname.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
* free 를 통해 메모리를 최적화한다.
      CALL METHOD go_alv_grid->free.
      CALL METHOD go_container->free.
      FREE : go_alv_grid, go_container.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_AND_TRANSFER OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_and_transfer OUTPUT.
  IF go_container IS INITIAL.

    CREATE OBJECT go_container
      EXPORTING
        container_name = 'MY_CONTROL_AREA'
      EXCEPTIONS
        OTHERS         = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
  CREATE OBJECT go_alv_grid
    EXPORTING
      i_parent = go_container
    EXCEPTIONS
      OTHERS   = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  PERFORM make_variant.
  PERFORM make_layout.
  PERFORM make_sort.
  PERFORM make_fcat.

  APPEND cl_gui_alv_grid=>mc_fc_filter TO gt_exct.
  APPEND cl_gui_alv_grid=>mc_fc_info TO gt_exct.
*  APPEND cl_gui_alv_grid=>mc_fc_exct_all TO gt_exct. "툴바 전체 삭제



  SET HANDLER lcl_handler=>on_doubleclick FOR go_alv_grid.
  SET HANDLER lcl_handler=>on_hotspot     FOR go_alv_grid.
  SET HANDLER lcl_handler=>on_toolbar     FOR go_alv_grid.
  SET HANDLER lcl_handler=>on_user_command FOR go_alv_grid.
  SET HANDLER lcl_handler=>on_button_click FOR go_alv_grid.
  SET HANDLER lcl_handler=>on_context_menu_request FOR go_alv_grid.
  SET HANDLER lcl_handler=>on_before_user_com FOR go_alv_grid.

  CALL METHOD go_alv_grid->set_table_for_first_display
    EXPORTING
*     i_buffer_active               =
*     i_bypassing_buffer            =
*     i_consistency_check           =
      i_structure_name              = 'SFLIGHT'
      is_variant                    = gv_variant
      i_save                        = gv_save
      i_default                     = 'X'
      is_layout                     = gs_layout
*     is_print                      =
*     it_special_groups             =
      it_toolbar_excluding          = gt_exct
*     it_hyperlink                  =
*     it_alv_graphics               =
*     it_except_qinfo               =
*     ir_salv_adapter               =
    CHANGING
      it_outtab                     = gt_flt
      it_fieldcatalog               = gt_fcat
      it_sort                       = gt_sort
*     it_filter                     =
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

* refresh
*  ON CHANGE OF gt_flt.
  gv_soft_refresh = 'X'.
  gs_stable-row = 'X'.
  gs_stable-col = 'X'.
  CALL METHOD go_alv_grid->refresh_table_display
    EXPORTING
      is_stable      = gs_stable
      i_soft_refresh = gv_soft_refresh
    EXCEPTIONS
      finished       = 1
      OTHERS         = 2.
  IF sy-subrc <> 0.
*     Implement suitable error handling here
  ENDIF.


ENDMODULE.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  SELECT *
    FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE gt_flt
    WHERE carrid IN so_car AND
          connid IN so_con AND
          fldate IN so_dat.

  LOOP AT gt_flt INTO gs_flt.

    IF gs_flt-seatsocc < 5.
      gs_flt-light = 1. "red

    ELSEIF gs_flt-seatsocc < 100.
      gs_flt-light = 2. "yellow
    ELSE.
      gs_flt-light = 3. "green

    ENDIF.

    IF gs_flt-fldate+4(2) = sy-datum+4(2).
      gs_flt-row_color = 'C511'.
    ENDIF.

    IF gs_flt-planetype = '747-400'. "747 항공기 셀에 색상을 넣어라
      gs_color-fname = 'PLANETYPE'.
      gs_color-color-col = col_total.
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_flt-it_color.
    ENDIF.

    IF gs_flt-seatsocc_b = 0.
      gs_color-fname = 'SEATSOCC_B'.
      gs_color-color-col = col_negative.
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_flt-it_color.
    ENDIF.
    IF gs_flt-fldate < p_data.
      gs_flt-changes_possible = icon_space.
    ELSE.
      gs_flt-changes_possible = icon_okay.
    ENDIF.

    IF gs_flt-seatsmax_b = gs_flt-seatsocc_b.
      gs_flt-btn_text = 'FullSeats!'.

      gs_styl-fieldname = 'BTN_TEXT'.
      gs_styl-style = cl_gui_alv_grid=>mc_style_button.
      APPEND gs_styl TO gs_flt-it_styl.
    ENDIF.

    SELECT SINGLE *
        FROM saplane
        INTO CORRESPONDING FIELDS OF gs_flt
      WHERE planetype = gs_flt-planetype.
    MODIFY gt_flt FROM gs_flt.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_variant
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_variant .

  gv_variant-report = sy-cprog.
  gv_variant-variant = pa_lv.
  gv_save = 'A'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_layout .

  gs_layout-zebra = 'X'. " low의 색을 반복하여 나타낸다.
*  gs_layout-cwidth_opt = 'X'. "Culom(세로줄)의 길이에 맞춰 필드 조정
  gs_layout-sel_mode = 'A'. " A,B,C,D

  " 신호등 만들기
  gs_layout-excp_fname = 'LIGHT'. " 신호등 이름
  gs_layout-excp_led = 'X'.


  gs_layout-info_fname = 'ROW_COLOR'.
  gs_layout-ctab_fname = 'IT_COLOR'.

  gs_layout-stylefname = 'IT_STYL'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_sort
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_sort .

  CLEAR gs_sort.
  gs_sort-fieldname = 'CARRID'.
  gs_sort-up = 'X'.
  gs_sort-spos = 1.
  APPEND gs_sort TO gt_sort.

  CLEAR gs_sort.
  gs_sort-fieldname = 'CONNID'.
  gs_sort-up = 'X'.
  gs_sort-spos = 2.
  APPEND gs_sort TO gt_sort.


  CLEAR gs_sort.
  gs_sort-fieldname = 'FLDATE'.
  gs_sort-down = 'X'.
  gs_sort-spos = 3.
  APPEND gs_sort TO gt_sort.

  CLEAR gs_sort.
  gs_sort-fieldname = 'PLANETYPE'.
  gs_sort-down = 'X'.
  gs_sort-spos = 4.
  APPEND gs_sort TO gt_sort.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_fcat .
  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'CARRID'.
*  gs_fcat-hotspot = 'X'.
  APPEND gs_fcat TO gt_fcat.

* 필드명 변경
  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'LIGHT'.
  gs_fcat-coltext = 'Info'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'PRICE'.
*  gs_fcat-no_out = 'X'.
*  gs_fcat-edit = 'X'. " 필드를 입력가능한 필드로 변경.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'CHANGES_POSSIBLE'.
  gs_fcat-coltext = 'Chang.Poss'.
  gs_fcat-col_opt = 'X'. "필드 간격 줄이기
  gs_fcat-col_pos = '5'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'SEATSOCC'.
  gs_fcat-do_sum = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'PAYMENTSUM'.
  gs_fcat-no_out = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'BTN_TEXT'.
  gs_fcat-coltext = 'Status'.
  gs_fcat-col_pos = 12.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'TANCKCAP'.
  gs_fcat-ref_table = 'SAPLANE'.
  gs_fcat-ref_field = 'TANKCAP'.
  gs_fcat-col_pos = 20.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'CAP_UNIT'.
  gs_fcat-ref_table = 'SAPLANE'.
  gs_fcat-ref_field = 'CAP_UNIT'.
  gs_fcat-col_pos = 21.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'WEIGHT'.
  gs_fcat-ref_table = 'SAPLANE'.
  gs_fcat-ref_field = 'WEIGHT'.
  gs_fcat-decimals = 0.
  gs_fcat-col_pos = 22.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'WEI_UNIT'.
  gs_fcat-ref_table = 'SAPLANE'.
  gs_fcat-ref_field = 'WEI_UNIT'.
  gs_fcat-col_pos = 23.
  APPEND gs_fcat TO gt_fcat.




ENDFORM.
