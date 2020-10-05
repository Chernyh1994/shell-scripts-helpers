#!/bin/bash

# Variables.
ENV_FILE=$PWD/.env

# A function that checks if data has been entered.
function checkEmpty() {
  while read -r -p "$1" ITEM; do
    ITEM=${ITEM}
    if [[ "$ITEM" =~ ^()$ ]]; then
      continue
    else
      echo "$ITEM"
      break
    fi
  done
}

# A function that checks if words have been entered yes or no
function checkYesNo() {
  while read -r -p "$1" ITEM; do
    ITEM=${ITEM}
    if [[ "$ITEM" =~ ^(yes|y|no|n)$ ]]; then
      echo "$ITEM"
      break
    else
      continue
    fi
  done
}

GENERATE=$(checkEmpty "Do you have generate .env file? [y/N]: ")

if [[ "$GENERATE" =~ ^(yes|y)$ ]]; then
  if [ -f "$ENV_FILE" ]; then
    echo "Start project..."
  else
    echo "We haven't found your .env file. Import .env file by the following pass $PWD and restart a script."
  fi
elif [[ "$GENERATE" =~ ^(no|n)$ ]]; then

  GENERATE_APP_KEY=$(checkYesNo "You are want generate APP_KEY? [y/N] $(tput setaf 1)(required)$(tput sgr0): ")

  if [[ "$GENERATE_APP_KEY" =~ ^(yes|y)$ ]]; then
    APP_KEY=`cd backend && sudo php artisan key:generate --show`
    echo "$APP_KEY"
  elif [[ "$GENERATE_APP_KEY" =~ ^(no|n)$ ]]; then
    APP_KEY=$(checkEmpty "Enter app secret key
      > for example: $(tput setaf 2)base64:***/***/***=$(tput sgr0)
      > $(tput setaf 1)(required)$(tput sgr0): ")
  fi

  TEST_VARIABLE=$(checkEmpty "Enter test variable
    > for example: $(tput setaf 2)***$(tput sgr0)
    > $(tput setaf 1)(required)$(tput sgr0): ")

  cd $PWD && rm -rf .env && touch .env

  if [[ $APP_ENV == 'production' ]]; then
    echo "APP_ENV=$APP_ENV" >> ./.env
  fi

  echo "APP_KEY=$APP_KEY" >> ./.env
  echo "TEST_VARIABLE=$TEST_VARIABLE" >> ./.env

else
  exit 0
fi