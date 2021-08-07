#!/bin/bash

export SELECT_FILE_CONDITION="999"
export SHOW_SOLUTION="999"
export ENABLE_PDF_EXPORT=0

mode="docker"

while getopts ":dvc:s:" opt; do
  case ${opt} in
    d ) mode="docker"
      ;;
    v ) mode="venv"
      ;;
    c ) SELECT_FILE_CONDITION=$OPTARG
      ;;
    s ) SHOW_SOLUTION=$OPTARG
      ;;
    \? )
      echo "Usage: serve [-d] [-v] [-c condition] [-s solution]" 1>&2
      exit 1
      ;;
    : )
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      exit 2
      ;;
  esac
done

if [[ $mode = "venv" ]]; then
  echo "Serving using local venv"
  ./venv/bin/mkdocs serve
else
  echo "Serving using docker. Please, connnect to http://127.0.0.1:8000"
  docker run --rm \
    --mount "type=bind,src=$(pwd),dst=/site" \
    --workdir "/site" \
    --env "SELECT_FILE_CONDITION" \
    --env "SHOW_SOLUTION" \
    --env "ENABLE_PDF_EXPORT" \
    --publish "8000:8000" \
    ghcr.io/heiafr-isc/mkdocs-edu-builder:latest serve -a 0.0.0.0:8000
fi