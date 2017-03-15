# Tournament-database

### How to get it
This project can be downloaded from github. In the command prompt after going into desired directory type
'https://github.com/aditya-sin/Tournament-database.git'

### What it contains
Is is a part of Udacity Full Stack Web Development Nanodegree Program.
This project implements a game tournament that uses Swiss system for pairing of players. It uses PostgreSQL database
to keep track of players and matches in the tournament.
It also has a test file which checks the code in tournament.py against a fixed dataset.

### How to use it
PostgreSQL command line interface is required to run the project. It can also be run on virtual machine, for example using vagrant. 
* After going into the directory, go into postgresql console using psql command. 
> /tournament/$ psql
* To create the databae and the tables as defined in .sql file, run the following command
> vagrant=> \i tournament.sql
* From another command line interface, go to the tournament directory and  run the test file or it can be done from same cli by exiting psql console using \q
> python tournament_test.py

There are 10 tests in the above file. If the tournament.py passes all the tests, it will be displayed followed by the message - 
> Success! All tests pass! 