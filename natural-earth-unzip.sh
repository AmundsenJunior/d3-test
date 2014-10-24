#!/usr/bin/env bash

if [ -d "data/geo/source" ]; then
  mkdir data/geo/shapefile
  echo "Directory created."

  cd data/geo/source
fi

for FILE in *.zip
  do
    FILENAME=${FILE%%.zip}
    echo "Unzipping $FILENAME"
    mkdir ../shapefile/$FILENAME/
    unzip $FILE -d ../shapefile/$FILENAME/
done

