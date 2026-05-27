--For each team, before/around each match, what does their recent form look like?
CREATE VIEW vw_team_form_features AS
SELECT
    r.match_id,
    r.season,
    r.match_date,
    r.team_id,
    t.team_name,
    r.opponent_id,
    r.venue,
    r.goals_for,
    r.goals_against,
    r.points,
    SUM(r.points) OVER (
        PARTITION BY r.team_id
        ORDER BY r.match_date
        ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
    ) AS rolling_5_match_points,

    AVG(CAST(r.goals_for AS FLOAT)) OVER (
        PARTITION BY r.team_id
        ORDER BY r.match_date
        ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
    ) AS rolling_5_avg_goals_for,

    AVG(CAST(r.goals_against AS FLOAT)) OVER (
        PARTITION BY r.team_id
        ORDER BY r.match_date
        ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
    ) AS rolling_5_avg_goals_against,

    SUM(r.goals_for - r.goals_against) OVER (
        PARTITION BY r.team_id
        ORDER BY r.match_date
        ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
    ) AS rolling_5_goal_difference
FROM vw_team_match_results r
JOIN teams t
    ON r.team_id = t.team_id;

