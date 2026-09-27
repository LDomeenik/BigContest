# 2026 빅콘테스트 데이터 분석 프로젝트

2026 빅콘테스트 제공 데이터를 활용한 데이터 분석 프로젝트입니다.

현재 프로젝트는 MySQL을 이용해 `RAW → STG` 구조로 데이터를 적재한 뒤,
Python에서 전처리 및 분석을 수행하는 방식으로 구성되어 있습니다.

기상 데이터는 기상청 API Hub를 통해 별도로 수집하며,
수집된 원본 파일은 `00_data/weather/`에 저장한 뒤 기존 RAW 적재 파이프라인에 포함합니다.

## 프로젝트 구조

```text
project/
├── 00_data/
│   ├── weather/
│   │   ├── weather_daily_202507_202512.csv
│   │   └── weather_minute_202507_202512.csv
│   └── 대회 제공 원본 데이터
├── src/
│   ├── 01_raw_load.ipynb
│   ├── 02_stg_load.ipynb
│   └── 03_preprocessing.ipynb
├── sql/
│   ├── 01_raw_create_table.sql
│   └── 02_stg_create_load.sql
├── .env.example
├── .gitignore
├── requirements.txt
└── README.md
```

## 실행 방법

### 1. 데이터 준비

프로젝트 최상위 경로에 `00_data` 폴더를 생성하고,
대회에서 제공된 원본 데이터를 해당 폴더에 저장합니다.

기상 데이터는 다른 원본 데이터와 구분하기 위해 `00_data/weather` 폴더에 별도로 저장합니다.

```text
project/
└── 00_data/
    ├── weather/
    │   ├── weather_daily_202507_202512.csv
    │   └── weather_minute_202507_202512.csv
    └── 대회 제공 원본 데이터
```

`00_data`의 원본 데이터는 GitHub에 포함되지 않습니다.

#### 기상 데이터 준비

기상 데이터는 기상청 API Hub를 이용하여 2025년 7월부터 12월까지
서울 강남구와 강원 춘천시의 관측자료를 수집합니다.

현재 사용하는 기상 원본 파일은 다음과 같습니다.

- `weather_daily_202507_202512.csv`: 일별 기상 데이터
- `weather_minute_202507_202512.csv`: AWS 매분자료

AWS 매분자료는 수집량이 많고 API 요청 횟수가 많아 전체 수집에 상당한 시간이 소요될 수 있습니다.
따라서 이미 수집이 완료된 파일이 있다면 다른 PC에서 API를 다시 호출하기보다는
`00_data/weather/` 폴더를 생성한 뒤 두 CSV 파일을 직접 복사하여 사용하는 것을 권장합니다.

```text
00_data/
└── weather/
    ├── weather_daily_202507_202512.csv
    └── weather_minute_202507_202512.csv
```

기상 데이터 파일이 없는 경우에는 기상 데이터 수집 Notebook을 실행하여 다시 생성할 수 있습니다.
API 응답 안정성을 위해 AWS 매분자료는 하루를 6시간 단위로 분할하여 수집하며,
수집 후 관측소·날짜·시간구간별 누락 여부를 검증합니다.

최종 수집 기준 데이터 규모는 다음과 같습니다.

- 일별 기상 데이터: 1,839행
- AWS 매분자료: 529,920행

### 2. 가상환경 생성

```bash
python -m venv .venv
```

Windows:

```bash
.venv\Scripts\activate
```

macOS / Linux:

```bash
source .venv/bin/activate
```

### 3. 패키지 설치

```bash
pip install -r requirements.txt
```

### 4. 환경변수 설정

`.env.example`을 참고하여 프로젝트 최상위 경로에 `.env` 파일을 생성합니다.

```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=bigcontest_raw
KMA_API_KEY=your_kma_api_key
```

`KMA_API_KEY`는 기상 데이터를 새로 수집할 때 사용합니다.
이미 수집된 기상 CSV 파일을 사용하는 경우에는 기상 데이터 재수집이 필요하지 않습니다.

`.env` 파일에는 실제 DB 비밀번호와 API Key가 포함되므로 GitHub에 업로드하지 않습니다.

### 5. MySQL Server 실행

Notebook 실행 전에 로컬 MySQL Server를 실행합니다.

데이터베이스와 테이블은 Notebook 실행 과정에서 자동으로 생성됩니다.

### 6. RAW 데이터 적재

다음 Notebook을 실행합니다.

```text
src/01_raw_load.ipynb
```

`00_data`에 준비한 대회 제공 원본 데이터와 기상 데이터를
MySQL `bigcontest_raw` 데이터베이스에 적재합니다.

기상 데이터 역시 다른 데이터와 동일하게 원본 상태로 RAW에 적재하고,
데이터 타입 변환 및 결측값 처리는 이후 단계에서 수행합니다.

### 7. STG 데이터 적재

다음 Notebook을 실행합니다.

```text
src/02_stg_load.ipynb
```

RAW 데이터를 기반으로 기본 데이터 타입을 정리하여
`bigcontest_stg` 데이터베이스에 적재합니다.

### 8. 전처리 시작

다음 Notebook을 실행합니다.

```text
src/03_preprocessing.ipynb
```

`bigcontest_stg`의 데이터를 Python DataFrame으로 불러온 뒤
전처리 및 분석을 진행합니다.

기상 데이터의 특수 결측값 처리, 시간대 집계 및 카드 데이터와의 결합 역시
전처리 단계에서 수행합니다.

## 다른 PC에서 프로젝트 이어서 작업하기

저장소가 이미 Clone되어 있다면 최신 코드는 다음 명령으로 가져옵니다.

```bash
git pull origin master
```

GitHub에는 원본 데이터를 포함하지 않으므로 `git pull`만으로 `00_data`의 데이터 파일이 생성되지는 않습니다.
다른 PC에서 작업할 때는 다음 항목을 별도로 준비해야 합니다.

- 대회 제공 원본 데이터
- `00_data/weather/`의 기상 데이터 CSV 2개
- `.env` 파일의 DB 설정
- 기상 데이터를 다시 수집하는 경우 `KMA_API_KEY`

특히 AWS 매분자료는 재수집 시간이 오래 걸리므로,
가능하면 이미 수집한 `weather_minute_202507_202512.csv` 파일을 직접 복사하여 사용하는 것을 권장합니다.

## 실행 순서

```text
00_data에 대회 제공 원본 데이터 저장
        ↓
00_data/weather에 기상 데이터 저장
(기존 CSV 복사 또는 기상 데이터 수집 Notebook 실행)
        ↓
.venv 생성 및 활성화
        ↓
requirements.txt 설치
        ↓
.env 생성
        ↓
MySQL Server 실행
        ↓
01_raw_load.ipynb
        ↓
02_stg_load.ipynb
        ↓
03_preprocessing.ipynb
        ↓
전처리 및 분석
```

## GitHub 관리 기준

다음 파일은 GitHub에 포함하지 않습니다.

```text
.env
00_data/
```

코드, Notebook, SQL, README, `.env.example` 등 재현에 필요한 파일만 Git으로 관리합니다.
