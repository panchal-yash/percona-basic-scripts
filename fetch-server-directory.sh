#!/bin/bash

lftp -e "cls -1 > /tmp/list; exit" "$1"
cat /tmp/list
