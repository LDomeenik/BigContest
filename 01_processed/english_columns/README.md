# 영문 컬럼명 전처리 파일 안내

이 폴더에는 `../`에 있는 Parquet 파일 16개의 **컬럼명만 알아보기 쉬운 영어로 바꾼 사본**이 로컬에서 생성됩니다. 파일명, 행 순서, 값, 자료형은 원본과 같습니다. 기존 Parquet는 `../`에 그대로 보관합니다.

Parquet 데이터 파일은 GitHub에 올리지 않습니다. GitHub에는 전처리 코드와 컬럼명 대응표만 포함됩니다. [03_preprocessing.ipynb](../../src/03_preprocessing.ipynb)의 전처리 셀은 기존 컬럼명을 사용하므로, 이 폴더의 사본을 읽을 때는 바뀐 컬럼명을 사용하세요.

모든 컬럼명의 변경 내역은 [column_mapping.csv](column_mapping.csv)에서 파일별로 확인할 수 있습니다. 자주 쓰는 컬럼의 예시는 다음과 같습니다.

| 기존 컬럼명 | 변경한 영문 컬럼명 | 의미 |
|---|---|---|
| `TA_YMD` | `payment_date` | 카드 결제일 |
| `STD_YM` | `year_month` | 기준 연월(YYYYMM) |
| `MCT_SGG_CD` | `merchant_region` | 가맹점 지역 |
| `MCT_RY_CD` | `merchant_industry` | 가맹점 업종 |
| `CLN_SGG_CD` | `customer_residence_region` | 카드 이용자의 거주 지역 |
| `TS_AT` | `total_payment_amount` | 결제금액 합계 |
| `USE_CNT` | `payment_count` | 결제건수 합계 |
| `BLOCK_CD` | `small_area_code` | 원본의 소지역 코드 |
| `REGION_CANDIDATE` | `candidate_region` | 코드 앞자리를 기준으로 분류한 잠정 지역 |
| `FLOW_POP_DAILY_AVG` | `avg_daily_flow_population` | 월별 일평균 유동인구 |

## 해석할 때 주의할 점

- `candidate_region`은 제공 자료에 공식 소지역·시군구 대응표가 없어 만든 **잠정 분류**입니다.
- 유동인구 값은 월별 일평균입니다. 카드 결제일 하루의 실제 관측치로 해석하지 마세요.
- `october_grid_discrepancy_flag`는 10월 연령·성별 자료의 격자 차이를 표시합니다. 원본 값을 보정했다는 뜻은 아닙니다.
- 카드 데이터1과 데이터2는 같은 결제를 서로 다른 기준에서 본 자료이므로 두 자료의 금액이나 건수를 더하지 마세요.

영문 컬럼명 변환은 [03_preprocessing.ipynb](../../src/03_preprocessing.ipynb)에 정의되어 있습니다. 저장한 사본 16개는 다시 읽어 원본과 값·자료형이 같은지 확인했습니다.
