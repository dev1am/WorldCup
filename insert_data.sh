#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS # copy file games.csv and read all data per variables
do

  if [[ $WINNER != "name" && $WINNER != "winner" ]] 
  then
    WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z $WINNER_TEAM_ID ]]
    then
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted winner, $WINNER
      fi
      WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
  fi

  if [[ $OPPONENT != "name" && $OPPONENT != "opponent" ]] 
  then
    OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT' AND name !='opponent'")
    if [[ -z $OPPONENT_TEAM_ID ]]
    then
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted opponent, $OPPONENT
      fi
      OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
  fi

  TEAM_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  TEAM_ID_O=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  if [[ $WINNER != "winner" ]]
  then
    INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
    VALUES($YEAR, '$ROUND', $TEAM_ID_W, $TEAM_ID_O, $WINNER_GOALS, $OPPONENT_GOALS)")
    echo $YEAR - $ROUND --- $TEAM_ID_W - $WINNER $WINNER_GOALS : $OPPONENT_GOALS $OPPONENT - $TEAM_ID_O 
  fi
done
