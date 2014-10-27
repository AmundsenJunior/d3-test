#!/usr/bin/env bash

if [ ! -d "data/geo/geojson" ]; then
  mkdir data/geo/geojson
  echo "geojson directory created"
fi

if [ ! -d "data/geo/topojson" ]; then
  mkdir data/geo/topojson
  echo "topojson directory created."
fi

ogr2ogr \
  -f GeoJSON \
  -where "ADM0_A3 IN ('USA', 'CAN')" \
  data/geo/geojson/subunits.json \
  data/geo/shapefile/ne_10m_admin_0_map_subunits/ne_10m_admin_0_map_subunits.shp

ogr2ogr \
  -f GeoJSON \
  -where "ISO_A2 IN ('US', 'CA') AND SCALERANK < 8" \
  data/geo/geojson/places.json \
  data/geo/shapefile/ne_10m_populated_places/ne_10m_populated_places.shp

topojson \
  -o data/geo/topojson/na.json \
  --id-property SU_A3 \
  --properties name=NAME \
  -- \
  data/geo/geojson/subunits.json \
  data/geo/geojson/places.json


