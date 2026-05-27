USE premier_league_db;

CREATE TABLE matches (
    match_id INT PRIMARY KEY IDENTITY(1,1),
    match_date DATE,
    season VARCHAR(20),
    home_team_id INT,
    away_team_id INT,
    home_goals INT,
    away_goals INT,
    result VARCHAR(5),

    FOREIGN KEY (home_team_id)
        REFERENCES teams(team_id),

    FOREIGN KEY (away_team_id)
        REFERENCES teams(team_id)
);