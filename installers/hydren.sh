#!/bin/bash

# Check if Node.js, npm, and git are installed
if ! command -v git &> /dev/null
then
    echo "Git is not installed. Installing Git..."
    sudo apt update && sudo apt install -y git
fi

if ! command -v fnm &> /dev/null
then
    echo "Node.js is not installed.. (Installing Nodejs 20x)"
    sudo apt update
    sudo apt install -y curl software-properties-common
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install nodejs -y 
fi

# Clone the repository
echo "Cloning HydrenDashboard repository..."
git clone https://github.com/hydren-dev/HydrenDashboard.git
cd HydrenDashboard

# Install dependencies
echo "Installing dependencies..."
npm i

# Rename .env_example to .env
mv .env_example .env

# Prompt user for configuration
read -p "Skyport_URL: " SKYPORT_URL
read -p "Skyport_API_key: " SKYPORT_KEY
read -p "DISCORD_SERVER: " DISCORD_SERVER
read -p "DISCORD_CLIENT_ID: " DISCORD_CLIENT_ID
read -p "DISCORD_CLIENT_SECRET: " DISCORD_CLIENT_SECRET
read -p "DISCORD_CALLBACK_URL: " DISCORD_CALLBACK_URL
read -p "DISCORD_NOTIFICATIONS_ENABLED (true/false): " DISCORD_NOTIFICATIONS_ENABLED

if [ "$DISCORD_NOTIFICATIONS_ENABLED" = "true" ]; then
    read -p "DISCORD_WEBHOOK_URL: " DISCORD_WEBHOOK_URL
    read -p "EMBED_THUMBNAIL_URL: " EMBED_THUMBNAIL_URL
else
    DISCORD_WEBHOOK_URL="YOUR_DISCORD_WEBHOOK_URL"
    EMBED_THUMBNAIL_URL="https://your-thumbnail-url.com/image.png"
fi

read -p "APP_NAME: " APP_NAME
read -p "ADMIN_USERS: " ADMIN_USERS
read -p "APP_PORT: " APP_PORT

read -p "HYDREN_API_KEY: (Dont SET The Skyport API Key You can set it any for example : hydren_key_1234567890)" API_KEY

# Write to .env file
cat <<EOL > .env
# SKYPORT settings
SKYPORT_URL=$SKYPORT_URL
SKYPORT_KEY=$SKYPORT_KEY

# Auth 
DISCORD_SERVER=$DISCORD_SERVER
DISCORD_CLIENT_ID=$DISCORD_CLIENT_ID
DISCORD_CLIENT_SECRET=$DISCORD_CLIENT_SECRET
DISCORD_CALLBACK_URL=$DISCORD_CALLBACK_URL
PASSWORD_LENGTH=10

#proxycheck.io API key
PROXYCHECK_KEY=0000000000000000000000000000

# Webhook
DISCORD_WEBHOOK_URL=$DISCORD_WEBHOOK_URL
DISCORD_NOTIFICATIONS_ENABLED=$DISCORD_NOTIFICATIONS_ENABLED
EMBED_THUMBNAIL_URL=$EMBED_THUMBNAIL_URL

# Session
SESSION_SECRET=examplesecret

# AFK
AFK_TIME=60

APP_NAME=$APP_NAME
APP_URL=http://127.0.0.1
APP_PORT=$APP_PORT

# Admin
ADMIN_USERS=$ADMIN_USERS

# Api
API_KEY=$API_KEY

# Logs
LOGS_PATH=./storage/logs/services.log
LOGS_ERROR_PATH=./storage/logs/errors.log

# Basic plan 
DEFAULT_PLAN=BASIC

# Cost store resources
CPU_COST=750
RAM_COST=500
DISK_COST=400
BACKUP_COST=250
DATABASE_COST=250
ALLOCATION_COST=500

# Developer
VERSION=5.0
EOL

echo "Configuration complete. The .env file has been updated."

echo "Starting HydrenDashboard with pm2"
npm i -g pm2
pm2 start index.js
echo "Started HydrenDashboard with pm2 Successfully"
