# Introduction

This is a script to automate the creation of Garmin maps from OSM data using Mkgmap.

# Installation:
* Install a java JRE
* Download the latest mkgmap release from [its website](https://www.mkgmap.org.uk/download/mkgmap.html) and unzip it into a directory called mkgmap
* Download the latest splitter release from [its website](https://www.mkgmap.org.uk/download/splitter.html) and unzip it into a directory called mkgmap
* Download a boundary file (bounds-latest.zip) from [the Mkgmap website](https://www.mkgmap.org.uk/download/mkgmap.html) and unzip it into a the input/bounds directory
* Download a sea file (sea-latest.zip) from [the Mkgmap website](https://www.mkgmap.org.uk/download/mkgmap.html) and unzip it into a the input/sea directory

# Maps:
* Download the maps you need from [Geofabrik](https://download.geofabrik.de/index.html), in .osm.pbf format, and place them in the input directory

# Usage:
./gen_maps.sh

