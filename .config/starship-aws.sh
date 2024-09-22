#!/usr/bin/env bash

if [[ "${AWS_ACCESS_KEY_ID:-}" != "" ]]; then
  echo -n "☀️  aws"
  if [[ "${AWS_REGION:-}" != "" ]]; then
    echo -n " (${AWS_REGION:-${AWS_DEFAULT_REGION}})"
  fi
else
  # echo "⛈  aws"
  return 0
fi
