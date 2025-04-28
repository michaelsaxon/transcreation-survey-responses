#!/bin/bash

TARGET="/var/www/html/transcreation_annotation/backend/responses/"

touch responses.hash

CONTENT_HASH=$(find $TARGET/* -type f -print0 | sort -z | xargs -0 sha1sum | sha1sum)
# remove spaces
CONTENT_HASH=${CONTENT_HASH%%[[:space:]]*}
OLD_CONTENT_HASH=$(cat responses.hash)
echo $CONTENT_HASH > responses.hash

echo "Current hash: $OLD_CONTENT_HASH"
echo "New hash: $CONTENT_HASH"

if [ "$CONTENT_HASH" = "$OLD_CONTENT_HASH" ]; then
  echo "No change detected."
  exit
fi

# there has been a change, update

rsync $TARGET responses

git add -A
git commit -m "responses updated  $(date)"

git push
