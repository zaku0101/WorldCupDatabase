#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi


# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games,teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
if [[ $YEAR != "year" ]] 
then


#get winner id
W_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

if [[ -z $W_ID ]]
then
#insert winner
INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

W_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
fi
echo $W_ID;
INSERT_WINNER_ID=$($PSQL "INSERT INTO games(winner_id) VALUES($W_ID)")
#get opponent id
O_ID=$($PSQL"SELECT team_id FROM teams WHERE name='$OPPONENT'")

if [[ -z $O_ID ]]
then
#insert opponent
INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

O_ID=$($PSQL"SELECT team_id FROM teams WHERE name='$OPPONENT'")
fi
echo $O_ID;
#insert data
INSERT_GAME=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$W_ID,$O_ID,$WGOALS,$OGOALS)")
fi
done 