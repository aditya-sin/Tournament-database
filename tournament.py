#!/usr/bin/env python
#
# tournament.py -- implementation of a Swiss-system tournament
#

import psycopg2


def connect():
    """Connect to the PostgreSQL database.  Returns a database connection."""
    try:
        db = psycopg2.connect("dbname= tournament")
        c = db.cursor()
        return (db, c)
    except:
        print("Could not connect to the database. Try again!")


def deleteMatches():
    """Remove all the match records from the database."""
    (DB, c) = connect()
    c.execute("truncate matches")
    c.execute("update win_num set wins = 0")
    c.execute("update match_num set matches = 0")
    DB.commit()
    DB.close


def deletePlayers():
    """Remove all the player records from the database."""
    DB, c = connect()
    c.execute("truncate win_num ")
    c.execute("truncate match_num")
    c.execute("truncate players cascade")
    c.execute("truncate matches")
    DB.commit()
    DB.close()


def countPlayers():
    """Returns the number of players currently registered."""
    DB, c = connect()
    c.execute("select count(player_id) from players")
    num = c.fetchone()[0]
    DB.close()
    return num


def registerPlayer(name):
    """Adds a player to the tournament database.

    The database assigns a unique serial id number for the player.  (This
    should be handled by your SQL database schema, not in your Python code.)

    Args:
      name: the player's full name (need not be unique).
    """
    DB, c = connect()
    c.execute("insert into players (player_name) values (%s) ", (name,))
    c.execute("select player_id from players order by player_id desc")
    id_val = c.fetchone()
    c.execute("insert into match_num values (%s,0)", (id_val,))
    c.execute("insert into win_num values (%s,0)", (id_val,))
    DB.commit()
    DB.close()


def playerStandings():
    """Returns a list of the players and their win records, sorted by wins.

    The first entry in the list should be the player in first place,
    or a player tied for first place if there is currently a tie.

    Returns:
      A list of tuples, each of which contains (id, name, wins, matches):
        id: the player's unique id (assigned by the database)
        name: the player's full name (as registered)
        wins: the number of matches the player has won
        matches: the number of matches the player has played
    """
    DB, c = connect()
    c.execute("select * from playersstanding")
    rows = c.fetchall()
    DB.close()
    return rows


def reportMatch(winner, loser):
    """Records the outcome of a single match between two players.

    Args:
      winner:  the id number of the player who won
      loser:  the id number of the player who lost
    """
    DB, c = connect()
    c.execute(" insert into matches(winner, loser) values (%s,%s)",
              (winner, loser))
    c.execute(" update match_num set matches = matches+1 where player_id = %s"
              "or player_id = %s", (winner, loser))
    c.execute(" update win_num set wins = wins+1 where player_id = %s",
              (winner,))
    DB.commit()
    DB.close()


def swissPairings():
    """Returns a list of pairs of players for the next round of a match.

    Assuming that there are an even number of players registered, each player
    appears exactly once in the pairings.  Each player is paired with another
    player with an equal or nearly-equal win record, that is, a player adjacent
    to him or her in the standings.

    Returns:
      A list of tuples, each of which contains (id1, name1, id2, name2)
        id1: the first player's unique id
        name1: the first player's name
        id2: the second player's unique id
        name2: the second player's name
    """
    standings = playerStandings()
    pairings = []
    for l in range(0, len(standings), 2):
        pairings.append((standings[l][0], standings[l][1], standings[l+1][0],
                         standings[l+1][1]))

    return pairings
