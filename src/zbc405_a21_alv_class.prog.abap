*&---------------------------------------------------------------------*
*& Include          ZBC405_A21_ALV_CLASS
*&---------------------------------------------------------------------*

CLASS lcl_handler DEFINITION. " 클래스 정의

  PUBLIC SECTION.
    CLASS-METHODS : on_doubleclick FOR EVENT double_click "더블클릭 선언
      OF cl_gui_alv_grid
      IMPORTING e_row e_column es_row_no, "필드 위치를 알려준다.

      on_hotspot FOR EVENT hotspot_click "핫스팟 선언
        OF cl_gui_alv_grid
        IMPORTING e_row_id e_column_id es_row_no,

      on_toolbar FOR EVENT toolbar OF cl_gui_alv_grid "버튼생성
        IMPORTING e_object e_interactive,

      on_user_command FOR EVENT user_command
      OF cl_gui_alv_grid IMPORTING e_ucomm, "유저 커멘드를 알려준다.

      on_button_click FOR EVENT button_click "버튼 클릭
      OF cl_gui_alv_grid IMPORTING es_col_id es_row_no,

      on_context_menu_request FOR EVENT context_menu_request
      OF cl_gui_alv_grid IMPORTING e_object, " 우 클릭

      on_before_user_com FOR EVENT before_user_command
      OF cl_gui_alv_grid  IMPORTING e_ucomm. " 비포 유저커멘드

ENDCLASS.

CLASS lcl_handler IMPLEMENTATION. "클래스  구현

  METHOD on_before_user_com.

    CASE e_ucomm.
      WHEN cl_gui_alv_grid=>mc_fc_detail.
        CALL METHOD go_alv_grid->set_user_command
          EXPORTING
            i_ucomm = 'SCHE'. "Flight schedule report
    ENDCASE.

  ENDMETHOD.

  METHOD on_context_menu_request.

* 선택된 셀에 메뉴표시 데이터 선언
    DATA: lv_col_id TYPE lvc_s_col,
          lv_row_id TYPE lvc_s_row.

    CALL METHOD go_alv_grid->get_current_cell
      IMPORTING
*       e_row     =
*       e_value   =
*       e_col     =
        es_row_id = lv_row_id
        es_col_id = lv_col_id.

    IF lv_col_id-fieldname = 'CARRID'.

** 스크린에 있는 메뉴를 가져온다.
*    CALL METHOD cl_ctmenu=>load_gui_status
*      EXPORTING
*        program    = sy-cprog
*        status     = 'CT_MENU'
**       disable    =
*        menu       = e_object
*      EXCEPTIONS
*        read_error = 1
*        OTHERS     = 2.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.

      CALL METHOD e_object->add_separator. " 구분선

      CALL METHOD e_object->add_function
        EXPORTING
          fcode = 'CARRID_INFO'
          text  = 'Display airline'
*         icon  =
*         ftype =
*         disabled          =
*         hidden            =
*         checked           =
*         accelerator       =
*         insert_at_the_top = SPACE
        .

    ENDIF.
  ENDMETHOD.

  METHOD on_button_click.
    READ TABLE gt_flt INTO gs_flt
    INDEX es_row_no-row_id.

    IF ( gs_flt-seatsmax NE gs_flt-seatsocc ) OR ( gs_flt-seatsmax_f NE gs_flt-seatsocc_f ).
      MESSAGE i000(zt03_msg) WITH '다른 등급의 좌석을 예약하세요!'.
    ELSE.
      MESSAGE i000(zt03_msg) WITH '모든 좌석이 예약이 된 상태입니다.'.
    ENDIF.
  ENDMETHOD.



  METHOD on_user_command.

    DATA : lv_occp     TYPE i,
           lv_capa     TYPE i,
           lv_perct    TYPE p LENGTH 8 DECIMALS 1,
           lv_text(20).

    DATA lt_rows TYPE lvc_t_roid.
    DATA ls_rows TYPE lvc_s_roid.

    DATA : lv_col_id TYPE lvc_s_col,
           lv_row_id TYPE lvc_s_row.

    CALL METHOD go_alv_grid->get_current_cell
      IMPORTING
*       e_row     =
*       e_value   =
*       e_col     =
        es_row_id = lv_row_id
        es_col_id = lv_col_id.

    CASE e_ucomm.
      WHEN 'PERCENTAGE'.
        LOOP AT gt_flt INTO gs_flt.
          lv_occp = lv_occp + gs_flt-seatsocc.
          lv_capa = lv_capa + gs_flt-seatsmax.
        ENDLOOP.

        lv_perct = lv_occp / lv_capa * 100.
        lv_text = lv_perct.
        CONDENSE lv_text.

        MESSAGE i000(zt03_msg) WITH
            'Percentage of occupied seats (%):' lv_text.

      WHEN 'PERCENTAGE_MARKED'.
        CALL METHOD go_alv_grid->get_selected_rows
          IMPORTING
*           et_index_rows =
            et_row_no = lt_rows. "선택한 레코드 정보 취득

        IF lines( lt_rows ) > 0. "lt_row 의 라인 갯수를 알려준다. 선택을 안하면 메세지가 뜬다.
          LOOP AT lt_rows INTO ls_rows.

            READ TABLE gt_flt INTO gs_flt INDEX ls_rows-row_id.
            IF sy-subrc EQ 0.
              lv_occp = lv_occp + gs_flt-seatsocc.
              lv_capa = lv_capa + gs_flt-seatsmax.
            ENDIF.
          ENDLOOP.

          lv_perct = lv_occp / lv_capa * 100.
          lv_text = lv_perct.
          CONDENSE lv_text.

          MESSAGE i000(zt03_msg) WITH
           'Percentage of Marked occupied seats (%):' lv_text.

        ELSE.
          MESSAGE i000(zt03_msg) WITH 'Please select at least one line!'.

        ENDIF.

      WHEN 'SCHE'.      "goto flight schedule report.
        READ TABLE gt_flt INTO gs_flt INDEX lv_row_id-index.
        IF sy-subrc EQ 0.
          SUBMIT bc405_event_d4 AND RETURN
                WITH so_car EQ gs_flt-carrid
                WITH so_con EQ gs_flt-connid.
        ENDIF.

      WHEN 'CARRID_INFO'.
        IF  lv_col_id-fieldname = 'CARRID'.

          READ TABLE gt_flt INTO gs_flt INDEX lv_row_id-index.
          IF sy-subrc EQ 0.
            CLEAR : lv_text.

            SELECT SINGLE carrname
              INTO lv_text
              FROM scarr
              WHERE carrid = gs_flt-carrid.

            IF sy-subrc EQ 0.
              MESSAGE i000(zt03_msg) WITH lv_text.

            ELSE.
              MESSAGE i000(zt03_msg) WITH 'No found!'.
            ENDIF.
          ENDIF.

        ELSE.
          MESSAGE i000(zt03_msg) WITH '항공사를 선택하세요'.
          EXIT.
        ENDIF.
    ENDCASE.

  ENDMETHOD.


  METHOD on_toolbar. "버튼 기능 추가
    DATA : ls_button TYPE stb_button.

    CLEAR : ls_button .
    ls_button-function = 'PERCENTAGE'.
*     ls_button-icon = ?
    ls_button-quickinfo = 'Occupied Total Percentage'.
    ls_button-butn_type = '0'.    "normal button
    ls_button-text = 'Percentage'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

    CLEAR : ls_button.
    ls_button-butn_type = '3'. "구분선 버튼 생성
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

    CLEAR : ls_button.
    ls_button-function = 'PERCENTAGE_MARKED'.
*    ls_button-icon = 'PERCT'.
    ls_button-quickinfo = 'Occupied Marked Percentage'.
    ls_button-butn_type = '0'.
    ls_button-text = 'Marked Percentage'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

    CLEAR : ls_button.
    ls_button-butn_type = '3'. "구분선 버튼 생성
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

    CLEAR : ls_button.
    ls_button-function = 'CARRID_INFO'.
*    ls_button-icon = 'PERCT'.
    ls_button-quickinfo = 'Occupied Info Percentage'.
    ls_button-butn_type = '0'.
    ls_button-text = 'CARRID_INFO'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

  ENDMETHOD.

  METHOD on_hotspot. "핫스팟 기능 추가

    DATA : carr_name TYPE scarr-carrname.

    CASE e_column_id-fieldname.
      WHEN 'CARRID'.
        READ TABLE gt_flt INTO gs_flt INDEX es_row_no-row_id.
        IF sy-subrc EQ 0.
          SELECT SINGLE carrname INTO carr_name FROM scarr
                   WHERE carrid = gs_flt-carrid.
          IF sy-subrc EQ 0.
            MESSAGE i000(zt03_msg) WITH carr_name.
          ELSE.
            MESSAGE i000(zt03_msg) WITH 'No found!'.
          ENDIF.

        ELSE.
          MESSAGE i075(bc405_408).
          EXIT.
        ENDIF.

    ENDCASE.

  ENDMETHOD.

  METHOD on_doubleclick. " 더블클릭 기능 추가
    DATA: total_occ       TYPE i,
          total_occ_c(10) TYPE c.
    CASE e_column-fieldname.
      WHEN 'CHANGES_POSSIBLE'.

        READ TABLE gt_flt INTO gs_flt INDEX es_row_no-row_id.
        IF sy-subrc EQ 0.
          total_occ = gs_flt-seatsocc +
                      gs_flt-seatsocc_b +
                      gs_flt-seatsocc_f.

          total_occ_c = total_occ.
          CONDENSE total_occ_c. "문자를 오른쪽 정렬시킨다.(기본적으로 문자는 왼쪽시작 숫자는 오른쪽 시작)
          MESSAGE i000(zt03_msg) WITH 'Total number of bookings: ' total_occ_c.
        ELSE.
          MESSAGE i075(bc405_408). "인터널에러 메세지
          EXIT.
        ENDIF.
    ENDCASE.

  ENDMETHOD.


ENDCLASS.
