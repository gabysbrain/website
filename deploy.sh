#!/bin/sh

DIR=$(nix-build --no-out-link)
SERVER="tom@tomtorsneyweir.com"

rsync -avr --progress --delete $DIR/ ${SERVER}:site/

