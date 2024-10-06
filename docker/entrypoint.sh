#!/bin/bash

function graceful_shutdown {
  echo "Received SIGTERM, notifying users and saving data..."

  screen -S minecraft -p 0 -X stuff "say サーバーが停止します。30秒以内にログアウトしてください。$(printf '\r')"
  sleep 30

  screen -S minecraft -p 0 -X stuff "kick @a$(printf '\r')"
  screen -S minecraft -p 0 -X stuff "save-all$(printf '\r')"
  screen -S minecraft -p 0 -X stuff "stop$(printf '\r')"
  sleep 10

  exit 0
}

trap graceful_shutdown SIGTERM

/start