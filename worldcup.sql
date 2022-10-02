CREATE TABLE teams (
	team_id SERIAL PRIMARY KEY,
	name VARCHAR(100) UNIQUE
);


CREATE TABLE games (
  game_id SERIAL PRIMARY KEY,
  year INT NOT NULL,
  round VARCHAR(50) NOT NULL,
	winner_id INT NOT NULL,
	opponent_id INT NOT NULL,
	winner_goals INT NOT NULL,
	opponent_goals INT NOT NULL,
  FOREIGN KEY (winner_id)
      REFERENCES team (team_id)
  FOREIGN KEY (opponent_id)
      REFERENCES team (team_id)
);

CREATE TABLE teams_games (
	game_id INT NOT NULL,
	team_id INT NOT NULL,
	PRIMARY KEY game_id, team_id
);