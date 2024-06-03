#!/bin/sh
set -e

if [ -z "$REEVE_API" ]; then
  echo This docker image is a Reeve CI pipeline step and is not intended to be used on its own.
  exit 1
fi

cd /reeve/src/

if [ -z "$SSH_HOST" ]; then
  echo Missing SSH host
  exit 1
fi

if [ -n "$SSH_LOGIN_KEY" ]; then
  mkdir -p ~/.ssh
  chmod 0700 ~/.ssh
  printf "%s\n" "$SSH_LOGIN_KEY" > ~/.ssh/id_ssh
  chmod 0600 ~/.ssh/id_ssh
fi

load-reeve-env >/tmp/ssh-commands
cat >>/tmp/ssh-commands

COMMAND="ssh $([[ -n "$SSH_LOGIN_KEY" ]] && echo "-i ~/.ssh/id_ssh" ||:) -o StrictHostKeyChecking=accept-new -l ${SSH_LOGIN_USER:-$(whoami)} $SSH_HOST"

if [ -n "$SSH_LOGIN_PASSWORD" ]; then
  sshpass -eSSH_LOGIN_PASSWORD $COMMAND </tmp/ssh-commands
else
  $COMMAND -o BatchMode=yes </tmp/ssh-commands
fi
