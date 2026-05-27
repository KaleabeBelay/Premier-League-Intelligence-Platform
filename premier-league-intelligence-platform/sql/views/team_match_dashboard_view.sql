-- What happened in every match from each team’s perspective?” (CAN SEE OPPINENTS NAME)
CREATE VIEW vw_team_match_dashboard AS
SELECT
    r.match_id,
    r.season,
    r.match_date,
    t.team_name,
    o.team_name AS opponent_name,
    r.venue,
    r.goals_for,
    r.goals_against,
    CASE
        WHEN r.points = 3 THEN 'Win'
        WHEN r.points = 1 THEN 'Draw'
        ELSE 'Loss'
    END AS result
FROM vw_team_match_results r
JOIN teams t
ON r.team_id = t.team_id
JOIN teams o
ON r.opponent_id = o.team_id;