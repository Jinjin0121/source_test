*&---------------------------------------------------------------------*
*& Report ZBC405_OM_A21
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_om_a21.

TABLES spfli.

SELECT-OPTIONS: so_car FOR spfli-carrid MEMORY ID car,
                so_con FOR spfli-connid MEMORY ID con.

DATA: gt_spfli TYPE TABLE OF spfli,
      gs_spfli TYPE spfli.

DATA: go_alv     TYPE REF TO cl_salv_table,
      go_func    TYPE REF TO cl_salv_functions_list, "클래스 타입은 데이터 선언이 필요하다.
      go_disp    TYPE REF TO cl_salv_display_settings,
      go_columns TYPE REF TO cl_salv_columns_table,
      go_column  TYPE REF TO cl_salv_column_table,
      go_cols    TYPE REF TO cl_salv_column,
      go_layout  TYPE REF TO cl_salv_layout,
      go_selc    TYPE REF TO CL_SALV_SELECTIONS.

START-OF-SELECTION.

  SELECT *
    INTO TABLE gt_spfli
    FROM spfli
    WHERE carrid IN so_car AND
          connid IN so_con.

  TRY. "의도치 않은 덤프를 방지한다.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = '' "IF_SALV_C_BOOL_SAP=>FALSE
*         r_container  =
*         container_name =
        IMPORTING
          r_salv_table = go_alv
        CHANGING
          t_table      = gt_spfli.

    CATCH cx_salv_msg.
  ENDTRY.


* CL_SALV_TABLE의 메소드
  CALL METHOD go_alv->get_functions
    RECEIVING
      value = go_func.

*CALL METHOD go_func->set_sort_asc. "정렬 버튼 가져오기
*
*CALL METHOD go_func->set_sort_desc.

  CALL METHOD go_func->set_all. " 모든 정령을 가져온다



  CALL METHOD go_alv->get_display_settings
    RECEIVING
      value = go_disp.

  CALL METHOD go_disp->set_list_header "타이틀 변경
    EXPORTING
      value = 'SALV DEMO!!'.

  CALL METHOD go_disp->set_striped_pattern "지브라 패턴
    EXPORTING
      value = 'X'.



  CALL METHOD go_alv->get_columns " 컬럼의 정보(이름 생성)
    RECEIVING
      value = go_columns.

* 필드의 간격을 가장 큰 것에 맞춰 조정한다.
* col_opt 기능과 같다.
  CALL METHOD go_columns->set_optimize.
*  EXPORTING
*    value  = IF_SALV_C_BOOL_SAP~TRUE



* 필드를 찾기 위한 클래스, CL_SALV_COLUMNS_TABLE 안에서 가져왔음.
  TRY.
      CALL METHOD go_columns->get_column
        EXPORTING
          columnname = 'MANDT'
        RECEIVING
          value      = go_cols.
    CATCH cx_salv_not_found.
  ENDTRY.

  go_column ?= go_cols. "캐스팅 : 타입이 달라도 부모가 같으면 오류가 나지 않게 만든다.

  CALL METHOD go_column->set_technical
*  EXPORTING
*    value  = IF_SALV_C_BOOL_SAP=>TRUE
    .

  TRY.
      CALL METHOD go_columns->get_column
        EXPORTING
          columnname = 'FLTIME'
        RECEIVING
          value      = go_cols.
    CATCH cx_salv_not_found.
  ENDTRY.

  go_column ?= go_cols.

  DATA  g_color TYPE lvc_s_colo.

  g_color-col = '5'.
  g_color-int = '1'.
  g_color-inv = '0'.

  CALL METHOD go_column->set_color
    EXPORTING
      value = g_color.

  CALL METHOD go_alv->get_layout
    RECEIVING
      value = go_layout.

  DATA g_program TYPE salv_s_layout_key.
  g_program-report = sy-cprog.

  CALL METHOD go_layout->set_key
    EXPORTING
      value = g_program.

  CALL METHOD go_layout->set_save_restriction
    EXPORTING
      value = if_salv_c_layout=>restrict_none.

  CALL METHOD go_layout->set_default
    EXPORTING
      value = 'X'.

*selection methods
CALL METHOD go_alv->get_selections
  RECEIVING
    value = go_selc.

 CALL METHOD go_selc->set_selection_mode
   EXPORTING
     value  = IF_SALV_C_SELECTION_MODE=>ROW_COLUMN.

 CALL METHOD go_selc->set_selection_mode
   EXPORTING
     value  = IF_SALV_C_SELECTION_MODE=>ROW_COLUMN.

  CALL METHOD go_alv->display. " 맨 아래 위치해야 한다.
