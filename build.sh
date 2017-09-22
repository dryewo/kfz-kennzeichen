#!/usr/bin/env bash

mkdir -p output
elm-make src/Main.elm --output output/main.js
