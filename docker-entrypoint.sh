#!/bin/sh
set -e

if [ -z "$REEVE_API" ]; then
  echo This docker image is a Reeve CI pipeline step and is not intended to be used on its own.
  exit 1
fi

cd /reeve/src/

if [ -z "$HOST" ]; then
  echo No host specified to connect to
  exit 1
fi

if [ -n "$SSH_LOGIN_KEY" ]; then
  mkdir -p ~/.ssh
  chmod 0700 ~/.ssh
  printf "%s\n" "$SSH_LOGIN_KEY" > ~/.ssh/id_ssh
  chmod 0600 ~/.ssh/id_ssh
fi

load-reeve-env >/tmp/ssh-commands
cat $SCRIPT >>/tmp/ssh-commands

COMMAND="ssh $([[ -n "$SSH_LOGIN_KEY" ]] && echo "-i ~/.ssh/id_ssh" ||:) $([[ -n "$SSH_LOGIN_USER" ]] && printf "-o User=%s" "$SSH_LOGIN_USER" ||:) -o StrictHostKeyChecking=accept-new $HOST"

if [ -n "$SSH_LOGIN_PASSWORD" ]; then
  sshpass -eSSH_LOGIN_PASSWORD $COMMAND </tmp/ssh-commands
else
  $COMMAND -o BatchMode=yes </tmp/ssh-commands
fi
