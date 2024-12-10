#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

#skip heading

if [[ $YEAR != 'year' ]]
then

#check if team name already exist 

WINNER_EXIST="$($PSQL "SELECT COUNT(*) FROM teams WHERE name = '$WINNER'")"

#insert name if name count = 0

if [[ $WINNER_EXIST -eq 0 ]]
then
echo "$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
fi

#check if team name already exist 
OPPONENT_EXIST="$($PSQL "SELECT COUNT(*) FROM teams WHERE name = '$OPPONENT'")"

#insert name 
if [[ $OPPONENT_EXIST -eq 0 ]]
then
echo "$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
fi

# get team id

WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")"
OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")"

#insert values into games table

echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")"

fi

done