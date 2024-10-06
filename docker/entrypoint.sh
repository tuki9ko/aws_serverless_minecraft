#!/bin/bash

function graceful_shutdown {
  echo "Received SIGTERM, notifying users and saving data..."

  rcon-cli say "サーバーが停止します。30秒以内にログアウトしてください。"
  sleep 30

  rcon-cli kick @a
  rcon-cli save-all
  rcon-cli stop
  sleep 10

  exit 0
}

trap graceful_shutdown SIGTERM

/start