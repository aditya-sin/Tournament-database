-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;
\c tournament

--players table - has player id, name number of matches played
-- and number of wins
CREATE TABLE players(
player_id SERIAL PRIMARY KEY,
player_name TEXT
);

-- macthes table stores id of winner and loser of that match
CREATE TABLE matches(
match_id SERIAL PRIMARY KEY,
winner INTEGER REFERENCES players (player_id) ON DELETE CASCADE,
loser INTEGER REFERENCES players (player_id) ON DELETE CASCADE 
CHECK (loser != winner)
);

CREATE VIEW winner_count AS
SELECT players.player_id, players.player_name, 
COUNT(matches.winner) AS total_wins
FROM players LEFT JOIN matches
ON players.player_id = matches.winner
GROUP BY players.player_id;

CREATE VIEW matches_count AS
SELECT players.player_id, players.player_name, 
COUNT(matches) AS total_matches
FROM players LEFT JOIN matches
ON players.player_id = matches.winner 
OR players.player_id = matches.loser
GROUP BY players.player_id;

CREATE VIEW playersstandings AS
SELECT winner_count.player_id, winner_count.player_name,
winner_count.total_wins, matches_count.total_matches
FROM winner_count JOIN matches_count 
ON winner_count.player_id = matches_count.player_id
ORDER BY winner_count.total_wins DESC;