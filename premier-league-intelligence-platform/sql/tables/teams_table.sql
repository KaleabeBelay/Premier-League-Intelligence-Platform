USE premier_league_db;

CREATE TABLE teams (
    team_id INT PRIMARY KEY IDENTITY(1,1),
    team_name VARCHAR(100) UNIQUE
);