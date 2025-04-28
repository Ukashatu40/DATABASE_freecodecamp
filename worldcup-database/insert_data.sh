#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != winner && $OPPONENT != opponent ]]
  then
     INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
     INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
     if [[ $INSERT_WINNER == "INSERT 0 1" ]]
     then
        echo Inserted into teams, $WINNER
     else
        echo $WINNER Already exists in teams
     fi

     if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
     then
        echo Inserted into teams, $OPPONENT
     else
        echo $OPPONENT Already exists in teams
     fi  
  fi

  if [[ $YEAR != year && $ROUND != round && $WINNER != winner && $OPPONENT != opponent && $WINNER_GOALS != winner_goals && $OPPONENT_GOALS != opponent_goals ]]
  then
     WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

     OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

     INSERT_INTO_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
     if [[ $INSERT_INTO_GAMES == "INSERT 0 1" ]]
     then
        echo Record added
     fi     
  fi

done