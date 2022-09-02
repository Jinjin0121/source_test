*&---------------------------------------------------------------------*
*& Report ZBC401_A21_MAIN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc401_a21_main.

"타입 그룹을 호출
TYPE-POOLS : icon.

"클래스 생성
CLASS lcl_airplane DEFINITION.

  PUBLIC SECTION.
    "이름과 기종을 넘긴다.

    METHODS : constructor IMPORTING  iv_name      TYPE string
                                     iv_planetype TYPE saplane-planetype

                          EXCEPTIONS wrong_planetype.


    METHODS : set_attributes IMPORTING iv_name      TYPE string
                                       iv_planetype TYPE saplane-planetype,

      display_attributes.
*스태틱은 클래스에서만 접근이 가능하지만 퍼블릭안에 있으면 인스턴스로도 접근이 가능하다.
    CLASS-METHODS : display_n_o_airplanes. "스태틱 메소드 선언

    CLASS-METHODS get_n_o_airplanes RETURNING VALUE(rv_count) TYPE i.

    CLASS-METHODS : class_constructor.


  PRIVATE SECTION.
    DATA : mv_name      TYPE string,
           mv_planetype TYPE saplane-planetype,
           mv_weight    TYPE saplane-weight,
           mv_tankcap   TYPE saplane-tankcap.

    TYPES : ty_planetype TYPE TABLE OF saplane.

    CLASS-DATA : gv_n_o_airplanes TYPE i. "스태틱 프라이빗 어트리버트

    "스태틱은 스태틱끼리 연결되어 스태틱 테이블이 필요하여 선언한다.
    CLASS-DATA : gv_planetypes TYPE ty_planetype.

    CONSTANTS : c_pos_i TYPE i VALUE 30. "출력하는 위치 지정

    CLASS-METHODS : get_technical_attributes
      IMPORTING
        iv_type    TYPE saplane-planetype
      EXPORTING
        ev_weight  TYPE saplane-weight
        ev_tankcap TYPE saplane-tankcap
      EXCEPTIONS
        wrong_planetype.

ENDCLASS.

CLASS lcl_airplane IMPLEMENTATION.

  METHOD get_technical_attributes.

    DATA : ls_planetype TYPE saplane.

    READ TABLE gv_planetypes INTO ls_planetype
    WITH KEY planetype = iv_type.
    IF sy-subrc EQ 0.
      ev_weight = ls_planetype-weight.
      ev_tankcap = ls_planetype-tankcap.
    ELSE.
      RAISE wrong_planetype.
    ENDIF.
  ENDMETHOD.

  METHOD class_constructor.

*프로그램 실행 시 한번만 실행
    SELECT *
      FROM saplane
      INTO TABLE gv_planetypes.

  ENDMETHOD.

  METHOD constructor.

    DATA : ls_planetype TYPE saplane.
    mv_name = iv_name.
    mv_planetype = iv_planetype.

*      SELECT SINGLE *
*       INTO ls_planetype
*        FROM saplane WHERE planetype = iv_planetype.
*      IF sy-subrc NE 0.
*        RAISE wrong_planetype.
*      ELSE.
*        mv_weight = ls_planetype-weight.
*        mv_tankcap = ls_planetype-tankcap.

    CALL METHOD get_technical_attributes
      EXPORTING
        iv_type         = iv_planetype
      IMPORTING
        ev_weight       = mv_weight
        ev_tankcap      = mv_tankcap
      EXCEPTIONS
        wrong_planetype = 1.
    IF sy-subrc EQ 0.
      gv_n_o_airplanes = gv_n_o_airplanes + 1.
    ELSE.
      RAISE
      wrong_planetype.
    ENDIF.

*      ENDIF.

  ENDMETHOD.


  METHOD get_n_o_airplanes.
    rv_count = gv_n_o_airplanes.
  ENDMETHOD.

  METHOD set_attributes.
    mv_name = iv_name.
    mv_planetype = iv_planetype.

    "카운팅한다.
    gv_n_o_airplanes = gv_n_o_airplanes + 1.

  ENDMETHOD.

  METHOD display_attributes.

    WRITE :/ icon_ws_plane AS ICON,
           / 'Name of airplane', AT c_pos_i mv_name,
           / 'Type of airplane', AT c_pos_i mv_planetype,
           / 'Weight / Tank capacity', AT c_pos_i mv_weight, mv_tankcap.

  ENDMETHOD.

  METHOD display_n_o_airplanes.

    WRITE : / 'Number of Airplanes', AT c_pos_i gv_n_o_airplanes.

  ENDMETHOD.

ENDCLASS.

"클래스 타입의 변수 선언
DATA : go_airplane TYPE REF TO lcl_airplane,
       gt_airplane TYPE TABLE OF REF TO lcl_airplane.

START-OF-SELECTION.

  "매소드 호출의 두가지 방식
  CALL METHOD lcl_airplane=>display_n_o_airplanes.

*  lcl_airplane=>display_n_o_airplanes( ).

  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'LH Berlin'
      iv_planetype    = 'A321'
    EXCEPTIONS
      wrong_planetype = 1.
  IF sy-subrc EQ 0.
    APPEND go_airplane TO gt_airplane.
  ENDIF.

  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'AA New York'
      iv_planetype    = '747-400'
    EXCEPTIONS
      wrong_planetype = 1.
  IF sy-subrc EQ 0.
    APPEND go_airplane TO gt_airplane.
  ENDIF.
  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'US Herculs'
      iv_planetype    = '747-200F'
    EXCEPTIONS
      wrong_planetype = 1.

  IF sy-subrc EQ 0.
    APPEND go_airplane TO gt_airplane.
  ENDIF.

  "객체 생성
*  CREATE OBJECT go_airplane.

  "비행기 체크
*  CALL METHOD go_airplane->set_attributes
*    EXPORTING
*      iv_name      = 'LH Berlin'
*      iv_planetype = 'A321'.
*
*  APPEND go_airplane TO gt_airplane.
*
*
*  CREATE OBJECT go_airplane.
*  APPEND go_airplane TO gt_airplane.
*
*  CALL METHOD go_airplane->set_attributes
*    EXPORTING
*      iv_name      = 'AA NEW York'
*      iv_planetype = '747-400'.
*
*
*  CREATE OBJECT go_airplane.
*  APPEND go_airplane TO gt_airplane.
*
*
*  CALL METHOD go_airplane->set_attributes
*    EXPORTING
*      iv_name      = 'US Herculs'
*      iv_planetype = '747-200F'.
*
**  CREATE OBJECT go_airplane.
**  APPEND go_airplane TO gt_airplane.
*

  LOOP AT gt_airplane INTO go_airplane.

    CALL METHOD go_airplane->display_attributes.

  ENDLOOP.

  DATA gv_count TYPE i.

  gv_count = lcl_airplane=>get_n_o_airplanes( ).
  WRITE : / 'Number of airplane', gv_count.
