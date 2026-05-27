CREATE VIEW vw_match_prediction_dataset AS
SELECT
    m.match_id,
    m.season,
    m.match_date,

    ht.team_name AS home_team,
    at.team_name AS away_team,

    home.last_5_points AS home_last_5_points,
    away.last_5_points AS away_last_5_points,

    home.last_5_avg_goals_for AS home_last_5_avg_goals_for,
    away.last_5_avg_goals_for AS away_last_5_avg_goals_for,

    home.last_5_avg_goals_against AS home_last_5_avg_goals_against,
    away.last_5_avg_goals_against AS away_last_5_avg_goals_against,

    home.last_5_goal_difference AS home_last_5_goal_difference,
    away.last_5_goal_difference AS away_last_5_goal_difference,

    m.result AS target_result
FROM matches m

JOIN teams ht
    ON m.home_team_id = ht.team_id

JOIN teams at
    ON m.away_team_id = at.team_id

JOIN vw_team_pre_match_features home
    ON m.match_id = home.match_id
    AND m.home_team_id = home.team_id

JOIN vw_team_pre_match_features away
    ON m.match_id = away.match_id
    AND m.away_team_id = away.team_id;