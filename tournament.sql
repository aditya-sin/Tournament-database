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

--players table - has player id and name
create table players(
player_id serial primary key,
player_name text
);
-- match_num table - matches stores number of matches played by player 
create table match_num(
player_id serial references players,
matches integer
);
-- win_num table - matches stores number of matches won by player 
create table win_num(
player_id serial references players,
wins integer
);
-- macthes table stores id of winner and loser of that match
create table matches(
match_id serial primary key,
winner integer references players (player_id),
loser integer references players (player_id)
);

create view playersstanding as select players.player_id, 
	players.player_name, win_num.wins,
	match_num.matches from players, win_num, match_num 
	where players.player_id = match_num.player_id and 
	players.player_id = win_num.player_id 
	order by win_num.wins desc