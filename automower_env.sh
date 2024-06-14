#!/bin/sh

export AUTOMOWER_CLIENTID="$(cat "${CREDENTIALS_DIRECTORY:-.}/.automower-clientid")"
export AUTOMOWER_CLIENTSECRET="$(cat "${CREDENTIALS_DIRECTORY:-.}/.automower-clientsecret")"
