#!/bin/bash

if [[ $OSTYPE != darwin* ]]; then
    exit
fi

apm stars --install

