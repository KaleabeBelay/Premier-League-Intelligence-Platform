-- Check to see how many match rows are available for machine learning
SELECT COUNT(*) AS total_matches
FROM vw_match_prediction_dataset;


-- Do any ML feature columns have missing values?
SELECT
    SUM(CASE WHEN home_last_5_points IS NULL THEN 1 ELSE 0 END) AS missing_home_points,
    SUM(CASE WHEN away_last_5_points IS NULL THEN 1 ELSE 0 END) AS missing_away_points,
    SUM(CASE WHEN home_last_5_avg_goals_for IS NULL THEN 1 ELSE 0 END) AS missing_home_goals_for,
    SUM(CASE WHEN away_last_5_avg_goals_for IS NULL THEN 1 ELSE 0 END) AS missing_away_goals_for
FROM vw_match_prediction_dataset;


-- Create a machine-learning-ready dataset with no missing feature values
CREATE VIEW vw_match_prediction_dataset_clean AS
SELECT *
FROM vw_match_prediction_dataset
WHERE home_last_5_points IS NOT NULL
  AND away_last_5_points IS NOT NULL
  AND home_last_5_avg_goals_for IS NOT NULL
  AND away_last_5_avg_goals_for IS NOT NULL
  AND home_last_5_avg_goals_against IS NOT NULL
  AND away_last_5_avg_goals_against IS NOT NULL
  AND home_last_5_goal_difference IS NOT NULL
  AND away_last_5_goal_difference IS NOT NULL;
