--For each team, what are their home and away performance numbers?
SELECT
    t.team_name,
    r.venue,
    COUNT(*) AS matches_played,
    SUM(r.points) AS total_points,
    AVG(CAST(r.points AS FLOAT)) AS avg_points_per_match,
    SUM(r.goals_for) AS goals_scored,
    SUM(r.goals_against) AS goals_conceded,
    AVG(CAST(r.goals_for AS FLOAT)) AS avg_goals_scored,
    AVG(CAST(r.goals_against AS FLOAT)) AS avg_goals_conceded
FROM vw_team_match_results r
JOIN teams t
    ON r.team_id = t.team_id
GROUP BY
    t.team_name,
    r.venue
ORDER BY
    t.team_name,
    r.venue;



--Which teams gain the biggest performance boost at home?
WITH venue_strength AS (
    SELECT
        t.team_name,
        r.venue,
        AVG(CAST(r.points AS FLOAT)) AS avg_points_per_match
    FROM vw_team_match_results r
    JOIN teams t
        ON r.team_id = t.team_id
    GROUP BY
        t.team_name,
        r.venue
)
SELECT
    team_name,
    MAX(CASE WHEN venue = 'Home' THEN avg_points_per_match END) AS home_ppm,
    MAX(CASE WHEN venue = 'Away' THEN avg_points_per_match END) AS away_ppm,
    MAX(CASE WHEN venue = 'Home' THEN avg_points_per_match END)
    -
    MAX(CASE WHEN venue = 'Away' THEN avg_points_per_match END)
        AS home_advantage_score
FROM venue_strength
GROUP BY team_name
ORDER BY home_advantage_score DESC;