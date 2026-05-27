CREATE VIEW vw_league_position_progression AS

WITH team_running_stats AS (
    SELECT
        r.season,
        r.match_date,
        r.match_id,
        r.team_id,
        t.team_name,
        ROW_NUMBER() OVER (
            PARTITION BY r.season, r.team_id
            ORDER BY r.match_date, r.match_id
        ) AS matchday,

        SUM(r.points) OVER (
            PARTITION BY r.season, r.team_id
            ORDER BY r.match_date, r.match_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_points,

        SUM(r.goals_for) OVER (
            PARTITION BY r.season, r.team_id
            ORDER BY r.match_date, r.match_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_goals_for,

        SUM(r.goals_against) OVER (
            PARTITION BY r.season, r.team_id
            ORDER BY r.match_date, r.match_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_goals_against,

        SUM(r.goals_for - r.goals_against) OVER (
            PARTITION BY r.season, r.team_id
            ORDER BY r.match_date, r.match_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_goal_difference
    FROM vw_team_match_results r

    JOIN teams t
        ON r.team_id = t.team_id
),

ranked_table AS (
    SELECT
        season,
        match_date,
        match_id,
        team_id,
        team_name,
        matchday,
        cumulative_points,
        cumulative_goals_for,
        cumulative_goals_against,
        cumulative_goal_difference,

        ROW_NUMBER() OVER (
            PARTITION BY season, matchday
            ORDER BY
                cumulative_points DESC,
                cumulative_goal_difference DESC,
                cumulative_goals_for DESC,
                team_name ASC
        ) AS league_position

    FROM team_running_stats
)
SELECT *
FROM ranked_table;