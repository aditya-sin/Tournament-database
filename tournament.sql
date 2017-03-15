-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

drop table if exists matches cascade;
drop table if exists match_num cascade;
drop table if exists win_num cascade;
drop table if exists players cascade;

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