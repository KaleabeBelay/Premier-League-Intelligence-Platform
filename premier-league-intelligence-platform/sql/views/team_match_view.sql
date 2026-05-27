--For every match, what did each individual team do?
CREATE VIEW vw_team_match_results AS
SELECT
    m.match_id,
    m.season,
    m.match_date,
    m.home_team_id AS team_id,
    m.away_team_id AS opponent_id,
    'Home' AS venue,
    m.home_goals AS goals_for,
    m.away_goals AS goals_against,
    CASE
        WHEN m.result = 'H' THEN 3
        WHEN m.result = 'D' THEN 1
        ELSE 0
    END AS points
FROM matches m
UNION ALL
SELECT
    m.match_id,
    m.season,
    m.match_date,
    m.away_team_id AS team_id,
    m.home_team_id AS opponent_id,
    'Away' AS venue,
    m.away_goals AS goals_for,
    m.home_goals AS goals_against,
    CASE
        WHEN m.result = 'A' THEN 3
        WHEN m.result = 'D' THEN 1
        ELSE 0
    END AS points
FROM matches m;

--Make it readable
SELECT
    r.match_id,
    r.season,
    r.match_date,
    t.team_name,
    o.team_name AS opponent,
    r.venue,
    r.goals_for,
    r.goals_against,
    r.points
FROM vw_team_match_results r
JOIN teams t
    ON r.team_id = t.team_id
JOIN teams o
    ON r.opponent_id = o.team_id
ORDER BY r.match_date;

