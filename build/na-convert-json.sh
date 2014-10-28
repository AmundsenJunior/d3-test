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
  -where "ADM0_A3 IN ('USA', 'CAN', 'MEX')" \
  data/geo/geojson/subunits.json \
  data/geo/shapefile/ne_10m_admin_0_map_subunits/ne_10m_admin_0_map_subunits.shp

if [ -e "data/geo/geojson/subunits.json" ]; then
  echo "Completed subunits GeoJSON conversion."
fi

ogr2ogr \
  -f GeoJSON \
  -where "iso_a2 IN ('US', 'CA', 'MX')" \
  data/geo/geojson/states_provinces.json \
  data/geo/shapefile/ne_10m_admin_1_states_provinces/ne_10m_admin_1_states_provinces.shp

if [ -e "data/geo/geojson/states_provinces.json" ]; then
  echo "Completed states-provinces GeoJSON conversion."
fi

ogr2ogr \
  -f GeoJSON \
  -where "ISO_A2 IN ('US', 'CA', 'MX') AND SCALERANK < 3" \
  data/geo/geojson/places.json \
  data/geo/shapefile/ne_10m_populated_places/ne_10m_populated_places.shp

if [ -e "data/geo/geojson/places.json" ]; then
  echo "Completed places GeoJSON conversion."
fi

topojson \
  -o data/geo/topojson/na.json \
  --id-property SU_A3 \
  --properties name=NAME \
  -- \
  data/geo/geojson/subunits.json \
  data/geo/geojson/places.json

if [ -e "data/geo/topojson/na.json" ]; then
  echo "Completed TopoJSON conversion."
fi

