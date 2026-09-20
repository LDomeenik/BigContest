# 2026 빅콘테스트 데이터 분석 프로젝트

2026 빅콘테스트 제공 데이터를 활용한 데이터 분석 프로젝트입니다.

현재 프로젝트는 MySQL을 이용해 `RAW → STG` 구조로 데이터를 적재한 뒤,
Python에서 전처리 및 분석을 수행하는 방식으로 구성되어 있습니다.

## 프로젝트 구조

```text
project/
├── 00_data/
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

```text
project/
└── 00_data/
    └── 대회 제공 데이터
```

`00_data`의 원본 데이터는 GitHub에 포함되지 않습니다.

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
```

### 5. MySQL Server 실행

Notebook 실행 전에 로컬 MySQL Server를 실행합니다.

데이터베이스와 테이블은 Notebook 실행 과정에서 자동으로 생성됩니다.

### 6. RAW 데이터 적재

다음 Notebook을 실행합니다.

```text
src/01_raw_load.ipynb
```

원본 데이터를 MySQL `bigcontest_raw` 데이터베이스에 적재합니다.

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

## 실행 순서

```text
00_data에 원본 데이터 저장
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
