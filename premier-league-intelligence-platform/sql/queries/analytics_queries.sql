-- COUNT MATCHES PER SEASON
SELECT
    season,
    COUNT(*) AS total_matches
FROM matches
GROUP BY season
ORDER BY season;



-- COUNT HOW MANY HOME WINS
SELECT
    COUNT(*) AS home_wins
FROM matches
WHERE result = 'H';



-- COUNT HOW MANY HOME WINS PER TEAM
SELECT
    t.team_name,
    COUNT(*) AS home_wins
FROM matches m
JOIN teams t
ON m.home_team_id = t.team_id
WHERE m.result = 'H'
GROUP BY t.team_name
ORDER BY home_wins DESC;



-- RANK ALL THE TEAMS BY TOTAL HOME GOALS SCORED FROM HIGHEST TO LOWEST
SELECT
    t.team_name,
    SUM(m.home_goals) AS total_home_goals
FROM matches m
JOIN teams t
ON m.home_team_id = t.team_id
GROUP BY t.team_name
ORDER BY total_home_goals DESC;



-- SEPERATE TOP 6 CLUBS VS REGULAR CLUBS.
SELECT
    team_name,
    CASE
        WHEN team_name IN ('Arsenal', 'Chelsea', 'Liverpool', 'Man City', 'Man United', 'Tottenham')
        THEN 'Top 6 CLub'

        ELSE 'Other Club'
    END AS club_category
FROM teams;



--BUILD LEGAUE TABLE BASED OFF LAST FIVE SEASONS
SELECT
    t.team_name,
    COUNT(*) AS games_played,

    SUM(
        CASE
            WHEN m.result = 'H'
            THEN 3
            ELSE 0
        END
    ) AS points
FROM matches m
JOIN teams t
ON m.home_team_id = t.team_id
GROUP BY t.team_name
ORDER BY points DESC;



--HOW MANY TOTAL HOME GOALS HAS EACH TEAM SCORED?
WITH home_goals_cte AS (
    SELECT
        t.team_name,
        SUM(m.home_goals) AS goals
    FROM matches m
    JOIN teams t
    ON m.home_team_id = t.team_id
    GROUP BY t.team_name
)
SELECT *
FROM home_goals_cte;



--WHAT IS THE WIN RATE FOR EACH TEAM?
SELECT
    t.team_name,
    COUNT(*) AS total_games,
    SUM(
        CASE
            WHEN m.result = 'H'
            THEN 1
            ELSE 0
        END
    ) AS wins,
    CAST(
        SUM(
            CASE
                WHEN m.result = 'H'
                THEN 1
                ELSE 0
            END
        ) AS FLOAT
    ) / COUNT(*) AS win_rate
FROM matches m
JOIN teams t
ON m.home_team_id = t.team_id
GROUP BY t.team_name
ORDER BY win_rate DESC;



----------------------------------------------------------------- CREATE FIRST WINDOW FUNCTION QUERY---------------------------------------------------------------------------

--What order did matches happen within each season?
SELECT
    match_id,
    season,
    match_date,
    ROW_NUMBER() OVER (
        PARTITION BY season
        ORDER BY match_date
    ) AS match_order
FROM matches;



--What is the average number of home goals over the last 5 matches in the season?
SELECT
    match_id,
    season,
    match_date,
    home_goals,
    AVG(home_goals) OVER (
        PARTITION BY season
        ORDER BY match_date
        ROWS BETWEEN 4 PRECEDING
        AND CURRENT ROW
    ) AS rolling_avg_home_goals
FROM matches;



--How many total home goals were scored across the last 5 matches?
SELECT
    match_id,
    season,
    match_date,
    home_goals,
    SUM(home_goals) OVER (
        PARTITION BY season
        ORDER BY match_date
        ROWS BETWEEN 4 PRECEDING
        AND CURRENT ROW
    ) AS rolling_5_match_goals
FROM matches;



--How many goals did the home team score in their previous match?
SELECT
    match_id,
    season,
    match_date,
    home_team_id,
    home_goals,
    LAG(home_goals) OVER (
        PARTITION BY season
        ORDER BY match_date
    ) AS prev_home_goals
FROM matches;



--Did the team improve or decline compared to last match?
SELECT
    match_id,
    season,
    match_date,
    home_goals,
    LAG(home_goals) OVER (
        PARTITION BY season
        ORDER BY match_date
    ) AS prev_home_goals,
    home_goals -
    LAG(home_goals) OVER (
        PARTITION BY season
        ORDER BY match_date
    ) AS goal_difference_from_last_match
FROM matches;



-- Create win streak feature
SELECT
    match_id,
    season,
    match_date,
    result,
    CASE
        WHEN result = LAG(result) OVER (
            PARTITION BY season
            ORDER BY match_date
        )
        THEN 1
        ELSE 0
    END AS same_result_as_last_match
FROM matches;



--How many points has each team earned across their last 5 matches?
SELECT
    r.match_id,
    r.match_date,
    t.team_name,
    r.points,
    SUM(r.points) OVER (
        PARTITION BY r.team_id
        ORDER BY r.match_date
        ROWS BETWEEN 4 PRECEDING
        AND CURRENT ROW
    ) AS rolling_5_match_points
FROM vw_team_match_results r
JOIN teams t
ON r.team_id = t.team_id
ORDER BY
    t.team_name,
    r.match_date;



--How dominant has a team been over its last 5 matches?
SELECT
    r.match_id,
    r.match_date,
    t.team_name,
    r.goals_for,
    r.goals_against,
    r.goals_for - r.goals_against
        AS goal_difference,
    SUM(
        r.goals_for - r.goals_against
    ) OVER (
        PARTITION BY r.team_id
        ORDER BY r.match_date
        ROWS BETWEEN 4 PRECEDING
        AND CURRENT ROW
    ) AS rolling_goal_difference
FROM vw_team_match_results r
JOIN teams t
ON r.team_id = t.team_id
ORDER BY
    t.team_name,
    r.match_date;