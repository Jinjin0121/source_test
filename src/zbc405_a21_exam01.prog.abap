*&---------------------------------------------------------------------*
*& Report ZBC405_A21_EXAM01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a21_exam01.

TABLES ztspfli_a21.

TYPES BEGIN OF gty_a21.
INCLUDE TYPE ztspfli_a21.
TYPES: light(1),
       id(1), "custom field
       gu_flght(10), "custom field
       gu_fr_tzone  TYPE sairport-time_zone, "custom field
       gu_to_tzone  TYPE sairport-time_zone, "custom field
       it_color     TYPE lvc_t_scol,
       timezonefr   TYPE s_tzone,
       timezoneto   TYPE s_tzone,
       btn_text     TYPE c LENGTH 10,
       fltype_icon  TYPE icon-id,
       row_color(4),
       chg.
TYPES END OF gty_a21.

DATA: gt_a21 TYPE TABLE OF gty_a21,
      gs_a21 LIKE LINE OF gt_a21.

TYPES : BEGIN OF rty_carrid.
TYPES : sign TYPE ddsign.
TYPES : option TYPE ddoption.
TYPES : low TYPE s_carr_id.
TYPES : high TYPE s_carr_id.
TYPES : END OF rty_carrid.

DATA : wa_carr TYPE rty_carrid.
DATA : rt_carr TYPE TABLE OF rty_carrid.

TYPES : BEGIN OF rty_connid.
TYPES : sign TYPE ddsign.
TYPES : option TYPE ddoption.
TYPES : low TYPE s_conn_id.
TYPES : high TYPE s_conn_id.
TYPES : END OF rty_connid.

DATA : wa_conn TYPE rty_connid.
DATA : rt_conn TYPE TABLE OF rty_connid.

DATA: go_container    TYPE REF TO cl_gui_custom_container,
      go_alv          TYPE REF TO cl_gui_alv_grid,
      gs_layout       TYPE lvc_s_layo,
      gt_field        TYPE lvc_t_fcat,
      gs_field        TYPE lvc_s_fcat,
      gs_color        TYPE lvc_s_scol,
      gt_exct         TYPE ui_functions,
      gv_variant      TYPE disvariant,
      gs_stable       TYPE lvc_s_stbl,
      gv_soft_refresh TYPE abap_bool,
      gt_sort         TYPE lvc_t_sort,
      gs_sort         TYPE lvc_s_sort,
      gs_ct           TYPE lvc_s_styl,
      gv_save(1).


DATA : gt_air TYPE TABLE OF sairport,
       gs_air TYPE  sairport.

"event class
INCLUDE zbc405_a21_exam01_class.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-a01.
  SELECT-OPTIONS: so_car FOR ztspfli_a21-carrid,
                  so_con FOR ztspfli_a21-connid.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 2(15) TEXT-t02.
    PARAMETERS pa_lv TYPE disvariant-variant.

    SELECTION-SCREEN COMMENT pos_high(8) TEXT-t01.
    PARAMETERS p_edit AS CHECKBOX.

  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b2.

PARAMETERS p_screen AS CHECKBOX.

INITIALIZATION.

  PERFORM get_variant.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_lv.


  gv_variant-report = sy-cprog.

  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load     = 'F'     "S, F L
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

AT SELECTION-SCREEN ON pa_lv.
*
  CHECK pa_lv IS NOT INITIAL.
  gv_variant-report = sy-cprog.

  gv_variant-variant = pa_lv.
  CALL FUNCTION 'LVC_VARIANT_EXISTENCE_CHECK'
    EXPORTING
      i_save        = 'A'
    CHANGING
      cs_variant    = gv_variant
    EXCEPTIONS
      wrong_input   = 1
      not_found     = 2
      program_error = 3
      OTHERS        = 4.
  IF sy-subrc <> 0.
    MESSAGE e000(zt03_msg) WITH 'Invalid layout variant!'.
  ENDIF.

START-OF-SELECTION.

  SELECT * INTO TABLE gt_air FROM  sairport.

  PERFORM select_form.
  IF p_screen NE 'X'.
*    CLEAR ztspfli_a21.
    CALL SCREEN 100.
  ELSE.
    CALL SCREEN 200.
  ENDIF.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  CLEAR sy-ucomm.

  IF p_edit = 'X'.
    SET PF-STATUS 'S100'.
  ELSE.
    SET PF-STATUS 'S100' EXCLUDING 'SAVE'.
    SET TITLEBAR 'T100' WITH sy-datum sy-uname.

  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.


  DATA : gv_result .

  PERFORM ask_save USING TEXT-001 TEXT-002
            CHANGING gv_result.

  "메모리 정리
  IF gv_result = '1'.
    CALL METHOD go_alv->free.
    CALL METHOD go_container->free.
    FREE : go_alv, go_container.

    LEAVE TO SCREEN 0.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create OUTPUT.

  IF go_container IS INITIAL.

    CREATE OBJECT go_container
      EXPORTING
        container_name              = 'ALV_AREA'
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CREATE OBJECT go_alv
      EXPORTING
        i_parent          = go_container
      EXCEPTIONS
        error_cntl_create = 1
        error_cntl_init   = 2
        error_cntl_link   = 3
        error_dp_create   = 4
        OTHERS            = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    PERFORM layout.
    PERFORM f_catarlog.
    PERFORM exct.
    PERFORM variant.

    CALL METHOD go_alv->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified.

    SET HANDLER lcl_handler=>on_toolbar FOR go_alv.
    SET HANDLER lcl_handler=>on_user_command FOR go_alv.
    SET HANDLER lcl_handler=>on_double_click FOR go_alv.
    SET HANDLER lcl_handler=>on_data_changed FOR go_alv.


    CALL METHOD go_alv->set_toolbar_interactive.
    CALL METHOD go_alv->set_ready_for_input
      EXPORTING
        i_ready_for_input = 1.

    CALL METHOD cl_gui_control=>set_focus
      EXPORTING
        control = go_alv.

    CALL METHOD cl_gui_cfw=>flush.


    CALL METHOD go_alv->set_table_for_first_display
      EXPORTING
*       i_buffer_active               =
*       i_bypassing_buffer            =
*       i_consistency_check           =
        i_structure_name              = 'SPFLI'
        is_variant                    = gv_variant
        i_save                        = 'A'
        i_default                     = 'X'
        is_layout                     = gs_layout
*       is_print                      =
*       it_special_groups             =
        it_toolbar_excluding          = gt_exct
*       it_hyperlink                  =
*       it_alv_graphics               =
*       it_except_qinfo               =
*       ir_salv_adapter               =
      CHANGING
        it_outtab                     = gt_a21
        it_fieldcatalog               = gt_field
        it_sort                       = gt_sort
*       it_filter                     =
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ELSE.

    ON CHANGE OF gt_a21.

      gv_soft_refresh = 'X'.
      gs_stable-row = 'X'.
      gs_stable-col = 'X'.
      CALL METHOD go_alv->refresh_table_display
        EXPORTING
          is_stable      = gs_stable
          i_soft_refresh = gv_soft_refresh
        EXCEPTIONS
          finished       = 1
          OTHERS         = 2.
      IF sy-subrc <> 0.
*     Implement suitable error handling here
      ENDIF.
*    CALL METHOD cl_gui_cfw=>flush.

    ENDON.



  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form SELECT_FORM
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM select_form .

  SELECT *
    FROM ztspfli_a21
    INTO CORRESPONDING FIELDS OF TABLE gt_a21
    WHERE   carrid IN so_car
  AND connid IN so_con.

  LOOP AT gt_a21 INTO gs_a21.

    SELECT SINGLE time_zone
        FROM sairport
        INTO gs_a21-gu_fr_tzone
    WHERE id = gs_a21-airpfrom.

    SELECT SINGLE time_zone
    FROM sairport
    INTO gs_a21-gu_to_tzone
    WHERE id = gs_a21-airpto.



    IF gs_a21-countryfr NE gs_a21-countryto.
      gs_a21-id = 'I'.
    ELSEIF gs_a21-countryfr = gs_a21-countryto.
      gs_a21-id = 'D'.
    ELSE.
    ENDIF.

    IF gs_a21-period > 1.
      gs_a21-light = '1'.

    ELSEIF gs_a21-period = 1.
      gs_a21-light = '2'.

    ELSE.
      gs_a21-light = '3'.
    ENDIF.


    IF gs_a21-fltype = 'X'.
      gs_a21-gu_flght = icon_ws_plane.
    ENDIF.

    IF gs_a21-id = 'I'.
      gs_color-fname = 'ID'.
      gs_color-color-col = col_total.
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_a21-it_color.

    ELSEIF gs_a21-id = 'D'.
      gs_color-fname = 'ID'.
      gs_color-color-col = col_positive.
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_a21-it_color.
    ELSE.

    ENDIF.

    IF gs_a21-fltype = 'X'.
      gs_a21-fltype_icon  = icon_ws_plane.
    ENDIF.



    READ TABLE gt_air INTO gs_air WITH KEY
                 id = gs_a21-airpfrom.

    IF sy-subrc EQ 0.
      gs_a21-timezonefr = gs_air-time_zone.
    ENDIF.

    READ TABLE gt_air INTO gs_air WITH KEY
                 id = gs_a21-airpto.

    IF sy-subrc EQ 0.
      gs_a21-timezoneto = gs_air-time_zone.
    ENDIF.

    MODIFY gt_a21 FROM gs_a21.
  ENDLOOP.
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

  gs_layout-grid_title = 'Flight Schedule Report'.
  gs_layout-excp_fname = 'LIGHT'.
  gs_layout-excp_led   = 'X'.
  gs_layout-zebra = 'X'.
  gs_layout-cwidth_opt = 'X'.
  gs_layout-sel_mode = 'D'.
*  gs_layout-stylefname = 'IT_STYLE'.
  gs_layout-info_fname = 'ROW_COLOR'.
*  gs_layout-ctab_fname = 'IT_COLOR'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_catarlog
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_catarlog .

  CLEAR gs_field.
  gs_field-fieldname = 'ID'.
  gs_field-coltext = 'I&D'.
  gs_field-col_pos   = '4'.
  APPEND gs_field TO gt_field.

  CLEAR gs_field.
  gs_field-fieldname = 'gu_flght'.
  gs_field-coltext = 'FLIGHT'.
  gs_field-col_pos   = '7'.
  APPEND gs_field TO gt_field.

  CLEAR gs_field.
  gs_field-fieldname = 'gu_fr_tzone'.
  gs_field-coltext = 'From TZONE'.
  gs_field-ref_table = 'SAIRPOR'.
  gs_field-ref_field = 'TIME_ZONE'.
  gs_field-col_pos   = '17'.
  APPEND gs_field TO gt_field.

  CLEAR gs_field.
  gs_field-fieldname = 'gu_to_tzone'.
  gs_field-coltext = 'To TZONE'.
  gs_field-ref_table = 'SAIRPOR'.
  gs_field-ref_field = 'TIME_ZONE'.
  gs_field-col_pos   = '18'.
  APPEND gs_field TO gt_field.

  CLEAR gs_field.
  gs_field-fieldname = 'FLTYPE'.
  gs_field-no_out = 'X'.
  APPEND gs_field TO gt_field.

  CLEAR gs_field.
  gs_field-fieldname = 'AIRPTO'.
  gs_field-edit = p_edit.
  APPEND gs_field TO gt_field.

  CLEAR gs_field.
  gs_field-fieldname = 'FLTIME'.
  gs_field-edit = p_edit.
  APPEND gs_field TO gt_field.

  CLEAR gs_field.
  gs_field-fieldname = 'ARRTIME'.
  gs_field-emphasize = 'C700'.
  APPEND gs_field TO gt_field.

  CLEAR gs_field.
  gs_field-fieldname = 'PERIOD'.
  gs_field-emphasize = 'C700'.
  APPEND gs_field TO gt_field.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form exct
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM exct .
  "toolbar delete
  APPEND cl_gui_alv_grid=>mc_fc_loc_cut TO gt_exct.
  APPEND cl_gui_alv_grid=>mc_fc_loc_copy TO gt_exct.
  APPEND cl_gui_alv_grid=>mc_mb_paste TO gt_exct.
  APPEND cl_gui_alv_grid=>mc_fc_loc_append_row TO gt_exct.
  APPEND cl_gui_alv_grid=>mc_fc_loc_insert_row TO gt_exct.
  APPEND cl_gui_alv_grid=>mc_fc_loc_delete_row TO gt_exct.
  APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row TO gt_exct.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form variant
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM variant .

  gv_variant-report = sy-cprog.
  gv_variant-variant = pa_lv.
  gv_save = 'A'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FLTIME_change_part
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&      --> LS_MOD_CELLS
*&---------------------------------------------------------------------*
FORM fltime_change_part USING rr_data_changed TYPE REF TO
                             cl_alv_changed_data_protocol
                             rs_mod_cells TYPE lvc_s_modi.


  DATA : l_fltime TYPE s_fltime.
  DATA : l_deptime TYPE s_dep_time.

  DATA : ev_arrtime TYPE s_arr_time.
  DATA : ev_period TYPE n .


  READ TABLE gt_a21 INTO gs_a21  INDEX rs_mod_cells-row_id.

  CALL METHOD rr_data_changed->get_cell_value
    EXPORTING
      i_row_id    = rs_mod_cells-row_id
      i_fieldname = 'FLTIME'
    IMPORTING
      e_value     = l_fltime.

  CHECK sy-subrc EQ 0.

  CALL METHOD rr_data_changed->get_cell_value
    EXPORTING
      i_row_id    = rs_mod_cells-row_id
      i_fieldname = 'DEPTIME'
    IMPORTING
      e_value     = l_deptime.

  CHECK sy-subrc EQ 0.


  CALL FUNCTION 'ZBC405_CALC_ARRTIME'
    EXPORTING
      iv_fltime       = l_fltime
      iv_deptime      = l_deptime
      iv_utc          = gs_a21-timezonefr
      iv_utc1         = gs_a21-timezoneto
    IMPORTING
      ev_arrival_time = ev_arrtime
      ev_period       = ev_period.


  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = rs_mod_cells-row_id
      i_fieldname = 'ARRTIME'
      i_value     = ev_arrtime.


  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = rs_mod_cells-row_id
      i_fieldname = 'PERIOD'
      i_value     = ev_period.

  gs_a21-period  = ev_period.
  gs_a21-arrtime = ev_arrtime.


  IF gs_a21-period >= 2.
    gs_a21-light = '1'.     "red
  ELSEIF gs_a21-period = 1.
    gs_a21-light  = '2'.   "yellow
  ELSE.
    gs_a21-light  = '3'.   "green
  ENDIF.


  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = rs_mod_cells-row_id
      i_fieldname = 'LIGHT'
      i_value     = gs_a21-light.


  gs_a21-chg = 'X'.              "변경확인
  MODIFY gt_a21 FROM gs_a21 INDEX rs_mod_cells-row_id.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ask_save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> TEXT_001
*&      --> TEXT_002
*&      <-- GV_RESULT
*&---------------------------------------------------------------------*
FORM ask_save  USING pv_text1 pv_text2
              CHANGING cv_result TYPE c.
  "팝업 실행
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar      = pv_text1
      text_question = pv_text2
    IMPORTING
      answer        = cv_result.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  DATA : g_result .


  CASE sy-ucomm.
    WHEN 'SAVE'.

      PERFORM ask_save USING TEXT-003 TEXT-004
                CHANGING g_result.
      IF g_result = '1'.
        PERFORM data_save.
      ENDIF.

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form data_save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM data_save .

  LOOP AT gt_a21 INTO gs_a21 WHERE chg = 'X'.

    UPDATE ztspfli_a21 SET fltime = gs_a21-fltime
                           deptime = gs_a21-deptime
                           arrtime = gs_a21-arrtime
                           period  = gs_a21-period
                     WHERE carrid = gs_a21-carrid
                       AND connid = gs_a21-connid.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.

  IF p_edit = 'X'.
    SET PF-STATUS 'S200'.
  ELSE.
    SET PF-STATUS 'S100' EXCLUDING 'SAVE'.
    SET TITLEBAR 'T200' WITH sy-datum sy-uname.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

  DATA : g_result2 .

  CASE sy-ucomm.
    WHEN 'SAVE'.

      PERFORM ask_save USING TEXT-003 TEXT-004
                CHANGING g_result.
      IF g_result2 = '1'.
        PERFORM data_save.
      ENDIF.

  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  GET_DATA  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_data INPUT.

  CLEAR : rt_conn. REFRESH : rt_conn.
  CLEAR : rt_carr. REFRESH : rt_carr.
  IF ztspfli_a21-carrid IS NOT INITIAL.
    wa_carr-low = ztspfli_a21-carrid.
    wa_carr-option = 'EQ'.
    wa_carr-sign = 'I'.
    APPEND wa_carr TO rt_carr.
  ELSE.
    CLEAR : rt_carr. REFRESH : rt_carr.
  ENDIF.

  IF ztspfli_a21-connid IS NOT INITIAL.
    wa_conn-low = ztspfli_a21-connid.
    wa_conn-option = 'EQ'.
    wa_conn-sign = 'I'.
    APPEND wa_conn TO rt_conn.
  ELSE.
    CLEAR : rt_conn. REFRESH : rt_conn.
  ENDIF.




  SELECT * INTO CORRESPONDING FIELDS OF TABLE gt_a21
                 FROM ztspfli_a21
       WHERE carrid IN rt_carr AND
             connid IN rt_conn.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  DROP_DOWN  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE drop_down INPUT.

  TYPES: BEGIN OF conn_line,
           conn TYPE spfli-connid,
         END OF conn_line.


  DATA conn_list TYPE STANDARD TABLE OF conn_line.


  SELECT connid
              FROM ztspfli_a21
              INTO TABLE conn_list
             WHERE carrid = ztspfli_a21-carrid.



  " F4 기능
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'CONNID'
      value_org       = 'S'
      dynpprog        = sy-repid
      dynpnr          = sy-dynnr
      dynprofield     = 'ZTSPFLI_A21-CONNID'  " 선택한 필드의 값이 입력될 화면의 필드
    TABLES
      value_tab       = conn_list
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form get_variant
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_variant .
  gv_variant-report = sy-cprog.
  CALL FUNCTION 'LVC_VARIANT_DEFAULT_GET'
    EXPORTING
      i_save     = 'A'
    CHANGING
      cs_variant = gv_variant
    EXCEPTIONS
      not_found  = 2.
  IF sy-subrc = 0.
    pa_lv = gv_variant-variant.
  ENDIF.
ENDFORM.
