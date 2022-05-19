#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
case $1 in
  # if no argument
  '') echo -e "Please provide an element as an argument."
  exit;;
  # if argument is not atomic number
  *[!0-9]*) LOOKUP_ELEMENT_RESULT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements NATURAL JOIN properties NATURAL JOIN types WHERE symbol = '$1' OR name = '$1'") ;;
  # if arguement is atomic number
  *) LOOKUP_ELEMENT_RESULT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements NATURAL JOIN properties NATURAL JOIN types WHERE atomic_number = $1") ;;
esac
if [[ -z $LOOKUP_ELEMENT_RESULT ]]
then
  # if element is not found
  echo -e "I could not find that element in the database."
else
  # if element is found, print information
  echo "$LOOKUP_ELEMENT_RESULT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE
  do
  echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
fi