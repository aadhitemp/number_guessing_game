#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
echo "Enter your username:"
SEC=$(($RANDOM % 1000))
read USERNAME
DBUSER=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")


if [[ -z $DBUSER ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  USER_INS_RES=$($PSQL "INSERT INTO users(username) VALUES ('$USERNAME')")
  GAMES_PLAYED=1
else
    GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME'")
    BEST_SCORE=$($PSQL "SELECT best_score FROM users WHERE username='$USERNAME'")
      echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_SCORE guesses."
    GAMES_PLAYED=$(($GAMES_PLAYED + 1))
fi


echo "Guess the secret number between 1 and 1000:"
read GUESS
NO_OF_TRIES=1
while (( $GUESS != $SEC ))
do
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
  echo "That is not an integer, guess again:"
  elif [[ $GUESS -gt $SEC ]]
  then
  echo "It's lower than that, guess again:"
  else
  echo "It's higher than that, guess again:"
  fi
 read GUESS
 NO_OF_TRIES=$(( $NO_OF_TRIES + 1 ))
done

BEST_SCORE=20000
if [[ $BEST_SCORE == 20000 ]]
then
 BEST_SCORE=$NO_OF_TRIES
fi



if [[ $NO_OF_TRIES -lt  $BEST_SCORE ]] 
then  
  echo $NO_OF_TRIES and $BEST_SCORE
  BEST_SCORE=$NO_OF_TRIES
fi


UPDATE_USER_RES=$($PSQL "UPDATE users SET best_score = $BEST_SCORE, games_played = $GAMES_PLAYED WHERE username= '$USERNAME'")
echo "You guessed it in $NO_OF_TRIES tries. The secret number was $SEC. Nice job!"