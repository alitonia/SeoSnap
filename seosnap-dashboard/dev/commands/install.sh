#!/bin/sh
if [ -f ".env" ]; then
  echo 'Generating new secret key'
  export NEW_SECRET="$(head /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | head -c50)";
  sed -i.bak "s/https\:\/\/miniwebtool.com\/django-secret-key-generator\//${NEW_SECRET}/g" .env;

  echo 'Setting new admin user login'
  read -p 'Username [snaptron]: ' ADMIN_NAME
  read -p 'Email [snaptron@snap.tron]: ' ADMIN_EMAIL
  read -sp 'Password [Sn@ptron1337]: ' ADMIN_PASS
  sed -i.bak "s/snaptron$/${ADMIN_NAME:-snaptron}/g" .env;
  sed -i.bak "s/snaptron@snap.tron/${ADMIN_EMAIL:-snaptron@snap.tron}/g" .env;
  sed -i.bak "s/Sn@ptron1337/${ADMIN_PASS:-Sn@ptron1337}/g" .env;
fi