--Before each match, what was this team’s form over its previous 5 matches?
CREATE VIEW vw_team_pre_match_features AS
SELECT
    r.match_id,
    r.season,
    r.match_date,
    r.team_id,
    t.team_name,
    r.opponent_id,
    r.venue,

    SUM(r.points) OVER (
        PARTITION BY r.team_id
        ORDER BY r.match_date
        ROWS BETWEEN 5 PRECEDING AND 1 PRECEDING
    ) AS last_5_points,

    AVG(CAST(r.goals_for AS FLOAT)) OVER (
        PARTITION BY r.team_id
        ORDER BY r.match_date
        ROWS BETWEEN 5 PRECEDING AND 1 PRECEDING
    ) AS last_5_avg_goals_for,

    AVG(CAST(r.goals_against AS FLOAT)) OVER (
        PARTITION BY r.team_id
        ORDER BY r.match_date
        ROWS BETWEEN 5 PRECEDING AND 1 PRECEDING
    ) AS last_5_avg_goals_against,

    SUM(r.goals_for - r.goals_against) OVER (
        PARTITION BY r.team_id
        ORDER BY r.match_date
        ROWS BETWEEN 5 PRECEDING AND 1 PRECEDING
    ) AS last_5_goal_difference
FROM vw_team_match_results r
JOIN teams t
    ON r.team_id = t.team_id;