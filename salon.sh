#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
Appointment_Types_ID=(1 2 3 4 5)
Appointment_Types_Name=(cut color perm style trim)

echo -e "\n~~~~~ MY SALON ~~~~~
Welcome to My Salon, how can I help you?"

MAIN_MENU() {
  if [[ $1 ]] # If there is any statement/argument while calling MAIN_MENU function
  then # Then print the statement/argument
    echo -e "\n$1\n"
  fi

  echo -e "1) cut
2) color
3) perm
4) style
5) trim"

  # Read Input/selection of the type of service
  read SERVICE_ID_SELECTED
  
  case $SERVICE_ID_SELECTED in
    1) cut;;
    2) color;;
    3) perm;;
    4) style;;
    5) trim;;
    *) MAIN_MENU "I could not find that service. What would you like today?";;
  esac

} # End of 'MAIN_MENU()'

ASK_PHONE() {
  if [[ ! $1 ]]
  then
    echo -e "\nWhat's your phone number?"
  else
    echo -e "\n$1"
  fi
  read CUSTOMER_PHONE
  if [[ ! $CUSTOMER_PHONE =~ [0-9]{3}-[0-9]{4} ]]
  then
    echo -e "Entered phone number: '$CUSTOMER_PHONE' is invalid"
    ASK_PHONE "Please enter valid phone number, in valid format: \"111-1111\""
  fi # End of 'if [[ ! $CUSTOMER_PHONE =~ [0-9]{3}-[0-9]{4} ]]'

  # Get name of existing phone_numbers in database
  CUSTOMER_NAME_DB=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  # echo -e "\n$CUSTOMER_NAME_DB"
  if [[ -z $CUSTOMER_NAME_DB ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    # Insert name and phone in database
    INSERT_name_INTO_customers=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
    #echo -e "\nWelcome '$CUSTOMER_NAME' to our service!"
    CUSTOMER_NAME_DB=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  fi # End of 'if [[ -z $CUSTOMER_NAME_DB ]]'
} # End of 'ASK_PHONE() {'

SCHEDULE_APPOINTMENT(){
  # Find Name of service requested
  Name_of_Service=${Appointment_Types_Name[$SERVICE_ID_SELECTED-1]}
  echo -e "\nService Requested: '$Name_of_Service', ID entered: '$SERVICE_ID_SELECTED'"

  # Check if appointment already exists
  Appointment_customer_id=$($PSQL "SELECT customer_id FROM appointments WHERE time='$SERVICE_TIME'")
  if [[ -z $Appointment_customer_id ]]
  then
    # Insert appointment into appointments table
    temp_customer_id=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($temp_customer_id,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
    Appointment_customer_id_name=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    # echo "Your $Name_of_Service appoinment is scheduled at $SERVICE_TIME.Thank You $Appointment_customer_id_name"
    #echo "$Appointment_customer_id_name"
    echo -e "\nI have put you down for a $Name_of_Service at $SERVICE_TIME,$Appointment_customer_id_name."
  else
    Appointment_customer_id_name=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    # echo "No worries $Appointment_customer_id_name, your ${Appointment_Types_Name[$SERVICE_ID_SELECTED]} is already scheduled at $SERVICE_TIME"
    #echo "$Appointment_customer_id_name"
    echo -e "\nI have put you down for a $Name_of_Service at $SERVICE_TIME,$Appointment_customer_id_name."
  fi # End of 'if [[ -z $Appointment_customer_id ]]'
}

cut(){
  ASK_PHONE
  echo -e "What time would you like your cut, $CUSTOMER_NAME_DB?"

  read SERVICE_TIME
  SCHEDULE_APPOINTMENT $SERVICE_ID_SELECTED
} # End of 'cut(){'

color(){
  ASK_PHONE
  echo -e "What time would you like your color, $CUSTOMER_NAME_DB?"

  read SERVICE_TIME
  SCHEDULE_APPOINTMENT $SERVICE_ID_SELECTED
} # End of 'color(){'

perm(){
  ASK_PHONE
  echo -e "What time would you like your perm, $CUSTOMER_NAME_DB?"

  read SERVICE_TIME
  SCHEDULE_APPOINTMENT $SERVICE_ID_SELECTED
} # End of 'perm(){'

style(){
  ASK_PHONE
  echo -e "What time would you like your style, $CUSTOMER_NAME_DB?"

  read SERVICE_TIME
  SCHEDULE_APPOINTMENT $SERVICE_ID_SELECTED
} # End of 'style(){'

trim(){
  ASK_PHONE
  echo -e "What time would you like your trim, $CUSTOMER_NAME_DB?"

  read SERVICE_TIME
  SCHEDULE_APPOINTMENT $SERVICE_ID_SELECTED
} # End of 'trim(){'

MAIN_MENU
