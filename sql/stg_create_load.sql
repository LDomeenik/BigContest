/* =========================================================
   STG Database 생성 및 RAW → STG 적재
   =========================================================

   [파일 설명]
   이 파일은 bigcontest_raw 데이터베이스에 적재된 원본 데이터를
   분석에 사용할 수 있는 기본 데이터 타입으로 변환하여
   bigcontest_stg 데이터베이스에 적재합니다.

   STG 단계에서는 데이터의 의미를 변경하는 전처리를 수행하지 않으며,
   원본 구조와 값을 최대한 유지합니다.

   [주요 내용]
   1. bigcontest_stg 데이터베이스 생성
   2. STG 테이블 초기화 및 생성
   3. RAW → STG 데이터 적재
   4. 카드 데이터의 기본 타입 변환
      - TA_YMD : VARCHAR → DATE
      - TS_AT  : VARCHAR → BIGINT
      - USE_CNT: VARCHAR → BIGINT
   5. RAW 데이터 추적을 위한 메타데이터 유지

   [STG에서 수행하지 않는 작업]
   - 중복 제거
   - 결측치 처리
   - 이상치 처리
   - 범주값 표준화
   - 법인 데이터 처리
   - wide → long 변환
   - 파생변수 생성

   [결과]
   bigcontest_stg 데이터베이스에 다음 테이블을 생성합니다.

   - flow_age
   - flow_time
   - flow_wkdy
   - card_topic1

   모든 STG 데이터는 raw_id를 통해 원본 RAW 행을 추적할 수 있습니다.
   ========================================================= */


/* =========================================================
   1. STG Database 생성
   ========================================================= */

CREATE DATABASE IF NOT EXISTS bigcontest_stg
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE bigcontest_stg;


/* =========================================================
   2. 기존 STG 테이블 초기화
   ---------------------------------------------------------
   STG는 RAW에서 언제든 재생성 가능한 계층이므로
   SQL 재실행 시 기존 테이블을 삭제한 뒤 다시 생성합니다.
   ========================================================= */

DROP TABLE IF EXISTS flow_age;
DROP TABLE IF EXISTS flow_time;
DROP TABLE IF EXISTS flow_wkdy;
DROP TABLE IF EXISTS card_topic1;


/* =========================================================
   3. 성·연령별 유동인구 STG 테이블 생성
   ========================================================= */

CREATE TABLE flow_age (
    -- RAW 데이터 추적용 Key
    raw_id BIGINT UNSIGNED PRIMARY KEY,

    -- 기본 데이터
    STD_YM CHAR(6),
    BLOCK_CD VARCHAR(20),
    X_COORD DECIMAL(38,8),
    Y_COORD DECIMAL(38,8),

    MAN_FLOW_POP_CNT_10G DECIMAL(18,2),
    MAN_FLOW_POP_CNT_20G DECIMAL(18,2),
    MAN_FLOW_POP_CNT_30G DECIMAL(18,2),
    MAN_FLOW_POP_CNT_40G DECIMAL(18,2),
    MAN_FLOW_POP_CNT_50G DECIMAL(18,2),
    MAN_FLOW_POP_CNT_60GU DECIMAL(18,2),

    WMAN_FLOW_POP_CNT_10G DECIMAL(18,2),
    WMAN_FLOW_POP_CNT_20G DECIMAL(18,2),
    WMAN_FLOW_POP_CNT_30G DECIMAL(18,2),
    WMAN_FLOW_POP_CNT_40G DECIMAL(18,2),
    WMAN_FLOW_POP_CNT_50G DECIMAL(18,2),
    WMAN_FLOW_POP_CNT_60GU DECIMAL(18,2),

    -- 원본 추적용 메타데이터
    source_file VARCHAR(255) NOT NULL,
    source_row_num BIGINT UNSIGNED,
    raw_loaded_at DATETIME,

    -- STG 적재 시각
    stg_loaded_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;


/* =========================================================
   4. 시간대별 유동인구 STG 테이블 생성
   ========================================================= */

CREATE TABLE flow_time (
    -- RAW 데이터 추적용 Key
    raw_id BIGINT UNSIGNED PRIMARY KEY,

    -- 기본 데이터
    STD_YM CHAR(6),
    BLOCK_CD VARCHAR(20),
    X_COORD DECIMAL(38,8),
    Y_COORD DECIMAL(38,8),

    TMST_00 DECIMAL(18,2),
    TMST_01 DECIMAL(18,2),
    TMST_02 DECIMAL(18,2),
    TMST_03 DECIMAL(18,2),
    TMST_04 DECIMAL(18,2),
    TMST_05 DECIMAL(18,2),
    TMST_06 DECIMAL(18,2),
    TMST_07 DECIMAL(18,2),
    TMST_08 DECIMAL(18,2),
    TMST_09 DECIMAL(18,2),
    TMST_10 DECIMAL(18,2),
    TMST_11 DECIMAL(18,2),
    TMST_12 DECIMAL(18,2),
    TMST_13 DECIMAL(18,2),
    TMST_14 DECIMAL(18,2),
    TMST_15 DECIMAL(18,2),
    TMST_16 DECIMAL(18,2),
    TMST_17 DECIMAL(18,2),
    TMST_18 DECIMAL(18,2),
    TMST_19 DECIMAL(18,2),
    TMST_20 DECIMAL(18,2),
    TMST_21 DECIMAL(18,2),
    TMST_22 DECIMAL(18,2),
    TMST_23 DECIMAL(18,2),

    -- 원본 추적용 메타데이터
    source_file VARCHAR(255) NOT NULL,
    source_row_num BIGINT UNSIGNED,
    raw_loaded_at DATETIME,

    -- STG 적재 시각
    stg_loaded_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;


/* =========================================================
   5. 요일별 유동인구 STG 테이블 생성
   ========================================================= */

CREATE TABLE flow_wkdy (
    -- RAW 데이터 추적용 Key
    raw_id BIGINT UNSIGNED PRIMARY KEY,

    -- 기본 데이터
    STD_YM CHAR(6),
    BLOCK_CD VARCHAR(20),
    X_COORD DECIMAL(38,8),
    Y_COORD DECIMAL(38,8),

    -- RAW 컬럼명을 그대로 유지
    FLOW_POP_CNT_MON DECIMAL(18,2),
    FLOW_POP_CNT_TUS DECIMAL(18,2),
    FLOW_POP_CNT_WED DECIMAL(18,2),
    FLOW_POP_CNT_THU DECIMAL(18,2),
    FLOW_POP_CNT_FRI DECIMAL(18,2),
    FLOW_POP_CNT_SAT DECIMAL(18,2),
    FLOW_POP_CNT_SUN DECIMAL(18,2),

    -- 원본 추적용 메타데이터
    source_file VARCHAR(255) NOT NULL,
    source_row_num BIGINT UNSIGNED,
    raw_loaded_at DATETIME,

    -- STG 적재 시각
    stg_loaded_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;


/* =========================================================
   6. 카드 결제 데이터 STG 테이블 생성
   ---------------------------------------------------------
   RAW에서는 모든 컬럼을 VARCHAR로 보존했으므로,
   STG에서 날짜/금액/건수의 기본 타입을 변환합니다.
   ========================================================= */

CREATE TABLE card_topic1 (
    -- RAW 데이터 추적용 Key
    raw_id BIGINT UNSIGNED PRIMARY KEY,

    -- 기준일자
    TA_YMD DATE,

    -- 범주형 데이터
    TIME_GB VARCHAR(20),
    MCT_SGG_CD VARCHAR(100),
    MCT_RY_CD VARCHAR(100),
    SEX_CCD VARCHAR(50),
    AGE_CCD VARCHAR(50),

    -- 수치형 데이터
    TS_AT BIGINT,
    USE_CNT BIGINT,

    -- 원본 추적용 메타데이터
    source_file VARCHAR(255) NOT NULL,
    source_row_num BIGINT UNSIGNED,
    raw_loaded_at DATETIME,

    -- STG 적재 시각
    stg_loaded_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;


/* =========================================================
   7. RAW → STG : 성·연령별 유동인구
   ========================================================= */

INSERT INTO bigcontest_stg.flow_age (
    raw_id,
    STD_YM,
    BLOCK_CD,
    X_COORD,
    Y_COORD,

    MAN_FLOW_POP_CNT_10G,
    MAN_FLOW_POP_CNT_20G,
    MAN_FLOW_POP_CNT_30G,
    MAN_FLOW_POP_CNT_40G,
    MAN_FLOW_POP_CNT_50G,
    MAN_FLOW_POP_CNT_60GU,

    WMAN_FLOW_POP_CNT_10G,
    WMAN_FLOW_POP_CNT_20G,
    WMAN_FLOW_POP_CNT_30G,
    WMAN_FLOW_POP_CNT_40G,
    WMAN_FLOW_POP_CNT_50G,
    WMAN_FLOW_POP_CNT_60GU,

    source_file,
    source_row_num,
    raw_loaded_at
)
SELECT
    raw_id,
    STD_YM,
    BLOCK_CD,
    X_COORD,
    Y_COORD,

    MAN_FLOW_POP_CNT_10G,
    MAN_FLOW_POP_CNT_20G,
    MAN_FLOW_POP_CNT_30G,
    MAN_FLOW_POP_CNT_40G,
    MAN_FLOW_POP_CNT_50G,
    MAN_FLOW_POP_CNT_60GU,

    WMAN_FLOW_POP_CNT_10G,
    WMAN_FLOW_POP_CNT_20G,
    WMAN_FLOW_POP_CNT_30G,
    WMAN_FLOW_POP_CNT_40G,
    WMAN_FLOW_POP_CNT_50G,
    WMAN_FLOW_POP_CNT_60GU,

    source_file,
    source_row_num,
    loaded_at

FROM bigcontest_raw.flow_age;


/* =========================================================
   8. RAW → STG : 시간대별 유동인구
   ========================================================= */

INSERT INTO bigcontest_stg.flow_time (
    raw_id,
    STD_YM,
    BLOCK_CD,
    X_COORD,
    Y_COORD,

    TMST_00,
    TMST_01,
    TMST_02,
    TMST_03,
    TMST_04,
    TMST_05,
    TMST_06,
    TMST_07,
    TMST_08,
    TMST_09,
    TMST_10,
    TMST_11,
    TMST_12,
    TMST_13,
    TMST_14,
    TMST_15,
    TMST_16,
    TMST_17,
    TMST_18,
    TMST_19,
    TMST_20,
    TMST_21,
    TMST_22,
    TMST_23,

    source_file,
    source_row_num,
    raw_loaded_at
)
SELECT
    raw_id,
    STD_YM,
    BLOCK_CD,
    X_COORD,
    Y_COORD,

    TMST_00,
    TMST_01,
    TMST_02,
    TMST_03,
    TMST_04,
    TMST_05,
    TMST_06,
    TMST_07,
    TMST_08,
    TMST_09,
    TMST_10,
    TMST_11,
    TMST_12,
    TMST_13,
    TMST_14,
    TMST_15,
    TMST_16,
    TMST_17,
    TMST_18,
    TMST_19,
    TMST_20,
    TMST_21,
    TMST_22,
    TMST_23,

    source_file,
    source_row_num,
    loaded_at

FROM bigcontest_raw.flow_time;


/* =========================================================
   9. RAW → STG : 요일별 유동인구
   ========================================================= */

INSERT INTO bigcontest_stg.flow_wkdy (
    raw_id,
    STD_YM,
    BLOCK_CD,
    X_COORD,
    Y_COORD,

    FLOW_POP_CNT_MON,
    FLOW_POP_CNT_TUS,
    FLOW_POP_CNT_WED,
    FLOW_POP_CNT_THU,
    FLOW_POP_CNT_FRI,
    FLOW_POP_CNT_SAT,
    FLOW_POP_CNT_SUN,

    source_file,
    source_row_num,
    raw_loaded_at
)
SELECT
    raw_id,
    STD_YM,
    BLOCK_CD,
    X_COORD,
    Y_COORD,

    FLOW_POP_CNT_MON,
    FLOW_POP_CNT_TUS,
    FLOW_POP_CNT_WED,
    FLOW_POP_CNT_THU,
    FLOW_POP_CNT_FRI,
    FLOW_POP_CNT_SAT,
    FLOW_POP_CNT_SUN,

    source_file,
    source_row_num,
    loaded_at

FROM bigcontest_raw.flow_wkdy;


/* =========================================================
   10. RAW → STG : 카드 결제 데이터
   ---------------------------------------------------------
   기본 타입 변환만 수행하며 원본 범주값은 변경하지 않습니다.

   TA_YMD  : YYYYMMDD 문자열 → DATE
   TS_AT   : VARCHAR → BIGINT
   USE_CNT : VARCHAR → BIGINT
   ========================================================= */

INSERT INTO bigcontest_stg.card_topic1 (
    raw_id,
    TA_YMD,
    TIME_GB,
    MCT_SGG_CD,
    MCT_RY_CD,
    SEX_CCD,
    AGE_CCD,
    TS_AT,
    USE_CNT,

    source_file,
    source_row_num,
    raw_loaded_at
)
SELECT
    raw_id,

    STR_TO_DATE(
        NULLIF(TA_YMD, ''),
        '%Y%m%d'
    ),

    TIME_GB,
    MCT_SGG_CD,
    MCT_RY_CD,
    SEX_CCD,
    AGE_CCD,

    CAST(
        NULLIF(TS_AT, '')
        AS SIGNED
    ),

    CAST(
        NULLIF(USE_CNT, '')
        AS SIGNED
    ),

    source_file,
    source_row_num,
    loaded_at

FROM bigcontest_raw.card_topic1;