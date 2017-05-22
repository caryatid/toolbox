#!/bin/sh

eval $(ssh-agent -s)
ssh-add "$HOME/.ssh/${2:-id_rsa}"
