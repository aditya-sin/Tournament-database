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
player_name TEXT,
matches INTEGER,
wins INTEGER
);

-- macthes table stores id of winner and loser of that match
CREATE TABLE matches(
match_id SERIAL PRIMARY KEY,
winner INTEGER REFERENCES players (player_id) ON DELETE CASCADE,
loser INTEGER REFERENCES players (player_id) ON DELETE CASCADE 
CHECK (loser != winner)
);

CREATE VIEW playersstanding AS 
SELECT player_id, player_name, wins, matches
FROM players
ORDER BY wins DESC;