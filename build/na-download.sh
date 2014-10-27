#!/usr/bin/env bash

if [ ! -d "data" ]; then
  mkdir data
  mkdir data/geo
  mkdir data/geo/source
fi

echo "Directories created."

cd data/geo/source
pwd

echo "Downloading Sovereign States and subunits:"
wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_map_subunits.zip

echo "Downloading State and Provinces"
wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_1_states_provinces.zip

echo "Downloading Populated Places"
wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_populated_places.zip

echo "Downloading Urban Areas"
wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_urban_areas.zip

echo "Downloading Coastline"
wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_coastline.zip

echo "Downloading Rivers and Lake centerlines"
wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_rivers_lake_centerlines.zip

echo "Downloading Lakes and Reservoirs"
wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_lakes.zip
