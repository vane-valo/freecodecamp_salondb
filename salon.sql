#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Salon Appointment Scheduler ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo "Choose a service:" 
  echo -e "\n1) Haircut\n2) Hair dye\n3) Makeup"
  read SERVICE_ID_SELECTED
  
  #get service
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")

  if [[ -z $SERVICE_NAME ]]
    then
      MAIN_MENU "That service doesn't exist"
    else

      #get customer info
      echo -e "\nWhat's your phone number?"
      read CUSTOMER_PHONE
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers
      WHERE phone = '$CUSTOMER_PHONE';")

      #if customer doesn't exist
      if [[ -z $CUSTOMER_NAME ]]
      then
        
        #get new customer name
        echo -e "\nWhat's your name?"
        read CUSTOMER_NAME
        
        #insert new customer
        INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name)
        VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
      fi

      # get customer_id
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")

      # get service_time
      echo -e "\nInsert service time:"
      read SERVICE_TIME

      #insert appointment
      INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time)
      VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")

      # get service info
      SERVICE_INFO=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")

      echo -e "\nI have put you down for a $SERVICE_INFO at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')." 
  fi
}

MAIN_MENU
