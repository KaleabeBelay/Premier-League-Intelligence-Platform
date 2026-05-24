# Premier League Intelligence Platform

A full end-to-end data engineering and machine learning project
built on five seasons of real Premier League match data.

**5 seasons  |  1,862 matches  |  27 clubs  |  50.7% model accuracy**

---

## Project Overview

This platform ingests raw match data, loads it into a relational
SQL Server database, builds a 7-layer analytics view system using
window functions and CTEs, trains match outcome prediction models,
and visualises results in Power BI.

---

## Tech Stack

| Tool              | Role                                     |
|-------------------|------------------------------------------|
| Python / pandas   | ETL pipeline and ML modelling            |
| SQL Server        | Relational database and analytics layer  |
| scikit-learn      | Logistic Regression and Random Forest    |
| Power BI          | Interactive dashboards                   |
| Jupyter Notebooks | Exploration, ETL, and modelling          |

---

## Architecture

```
Raw CSVs (football-data.co.uk)
     |
     v
Python ETL (pandas + SQLAlchemy)
     |
     v
SQL Server (teams + matches tables)
     |
     v
SQL Views (7 layers: form stats, pre-match features, ML dataset)
     |
     v
scikit-learn ML Models (Logistic Regression + Random Forest)
     |
     v
Power BI Dashboard (predictions + form + standings)
```

---

## Results

| Model               | Accuracy |
|---------------------|----------|
| Logistic Regression | 50.7%    |
| Random Forest       | ~51-52%  |
| Naive baseline*     | 43.9%    |

*Always predicting Home Win (most common class)

The model predicts Home Wins with 78.7% accuracy.
Draws are the hardest outcome to predict (0.4% recall)
due to their inherently random nature.

---

## Database Schema

**Tables (2)**
- `teams`: team_id (PK), team_name
- `matches`: match_id (PK), match_date, season,
  home/away team IDs (FK), goals, result

**Views (7)**
- `vw_team_match_results` — UNION ALL: one row per team per match
- `vw_team_form_features` — rolling 5-match stats (current match included)
- `vw_team_pre_match_features` — rolling stats BEFORE each match (for ML)
- `vw_team_match_dashboard` — human-readable display view
- `vw_league_position_progression` — running league table per matchday
- `vw_match_prediction_dataset` — assembled ML feature set
- `vw_match_prediction_dataset_clean` — null-filtered ML-ready view

---

## ML Features (8 pre-match form indicators)

All features computed in SQL from the previous 5 matches:
- Points earned (home team)
- Points earned (away team)
- Average goals scored — home and away
- Average goals conceded — home and away
- Goal difference — home and away

Target: match result — H (Home Win) / D (Draw) / A (Away Win)

---

## Key SQL Skills Demonstrated

- Relational schema design with primary and foreign keys
- UNION ALL for data perspective transformation
- Window functions: ROW_NUMBER, LAG, SUM OVER, AVG OVER
- Rolling window frames: ROWS BETWEEN N PRECEDING AND ...
- Common Table Expressions (CTEs)
- PIVOT pattern with MAX + CASE WHEN
- Multi-layer views (views referencing other views)
- Pre-match vs post-match feature separation

## Key Python Skills Demonstrated

- pandas: read_csv, concat, map, to_datetime, to_sql, read_sql
- SQLAlchemy for database connectivity
- scikit-learn: train_test_split, LogisticRegression,
  RandomForestClassifier, accuracy_score, confusion_matrix,
  classification_report, predict_proba, feature_importances_
- matplotlib + seaborn: heatmaps, bar charts, model comparison
- Data export for BI consumption (CSV to Power BI)

---

## Data Source

Match data: football-data.co.uk (free, publicly available)
Seasons: 2021/22, 2022/23, 2023/24, 2024/25, 2025/26
