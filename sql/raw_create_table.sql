/* =========================================================
   2026 Big Contest
   RAW Database 생성
   ========================================================= */

CREATE DATABASE IF NOT EXISTS bigcontest_raw
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE bigcontest_raw;


/* =========================================================
   1. 성연령별 유동인구
   원본: flow_age_pop_YYYYMM.csv
   ========================================================= */

CREATE TABLE IF NOT EXISTS flow_age (
    raw_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    -- 원본 컬럼
    STD_YM VARCHAR(6),
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

    -- RAW 적재 관리용 메타데이터
    source_file VARCHAR(255) NOT NULL,
    source_row_num BIGINT UNSIGNED,
    loaded_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;


/* =========================================================
   2. 시간대별 유동인구
   원본: flow_time_pop_YYYYMM.csv
   ========================================================= */

CREATE TABLE IF NOT EXISTS flow_time (
    raw_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    -- 원본 컬럼
    STD_YM VARCHAR(6),
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

    -- RAW 적재 관리용 메타데이터
    source_file VARCHAR(255) NOT NULL,
    source_row_num BIGINT UNSIGNED,
    loaded_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;


/* =========================================================
   3. 요일별 유동인구
   원본: flow_wkdy_pop_YYYYMM.csv

   주의:
   FLOW_POP_CNT_TUS는 정의서의 원본 컬럼명을 그대로 사용.
   STG 단계에서 필요하면 TUE로 표준화.
   ========================================================= */

CREATE TABLE IF NOT EXISTS flow_wkdy (
    raw_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    -- 원본 컬럼
    STD_YM VARCHAR(6),
    BLOCK_CD VARCHAR(20),
    X_COORD DECIMAL(38,8),
    Y_COORD DECIMAL(38,8),

    FLOW_POP_CNT_MON DECIMAL(18,2),
    FLOW_POP_CNT_TUS DECIMAL(18,2),
    FLOW_POP_CNT_WED DECIMAL(18,2),
    FLOW_POP_CNT_THU DECIMAL(18,2),
    FLOW_POP_CNT_FRI DECIMAL(18,2),
    FLOW_POP_CNT_SAT DECIMAL(18,2),
    FLOW_POP_CNT_SUN DECIMAL(18,2),

    -- RAW 적재 관리용 메타데이터
    source_file VARCHAR(255) NOT NULL,
    source_row_num BIGINT UNSIGNED,
    loaded_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;


/* =========================================================
   4. 카드 결제 정보 - 주제1
   원본: 신한카드_빅콘테스트2026_데이터1.txt

   RAW에서는 정의서 기준 VARCHAR 형태 유지.
   날짜/금액/건수 변환은 STG에서 처리.
   ========================================================= */

CREATE TABLE IF NOT EXISTS card_topic1 (
    raw_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    -- 원본 컬럼
    TA_YMD VARCHAR(20),
    TIME_GB VARCHAR(20),
    MCT_SGG_CD VARCHAR(100),
    MCT_RY_CD VARCHAR(100),
    SEX_CCD VARCHAR(50),
    AGE_CCD VARCHAR(50),
    TS_AT VARCHAR(50),
    USE_CNT VARCHAR(50),

    -- RAW 적재 관리용 메타데이터
    source_file VARCHAR(255) NOT NULL,
    source_row_num BIGINT UNSIGNED,
    loaded_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;


/* =========================================================
   생성 확인
   ========================================================= */

SHOW TABLES;


/* =========================================================
   테이블 구조 확인
   ========================================================= */

DESC flow_age;
DESC flow_time;
DESC flow_wkdy;
DESC card_topic1;