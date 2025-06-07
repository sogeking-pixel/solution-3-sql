#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

echo -e "\n~~~ Welcome to the Salon Appointment Scheduler ~~~\n"

# Function to show services
SHOW_SERVICES() {
  echo -e "\nAvailable Services:"
  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id;")
  echo "$SERVICES" | while IFS="|" read ID NAME; do
    echo "$ID) $NAME"
  done
}

# Show services
SHOW_SERVICES

# Ask for service
echo -e "\nPlease select a service by entering the number:"
read SERVICE_ID_SELECTED

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED;")

# Validate service_id
while [[ -z $SERVICE_NAME ]]; do
  echo -e "\nThat service doesn't exist. Please choose again."
  SHOW_SERVICES
  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED;")
done

# Get customer phone
echo -e "\nEnter your phone number:"
read CUSTOMER_PHONE

CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")

# If not found, ask for name and insert
if [[ -z $CUSTOMER_NAME ]]; then
  echo -e "\nYou seem to be a new customer. What is your name?"
  read CUSTOMER_NAME
  INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
fi

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")

# Ask for time
echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME

# Insert appointment
INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")

# Confirm
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
