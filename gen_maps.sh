#!/bin/bash
set -x

STYLES=( "default" "quad" )

# Map IDs must be unique within all installed maps on the device. Garmin maps are identified by an 8 digit number.
MAP_NUM=63250010


BASE_DIR=$(pwd)
cd "$BASE_DIR"

mkdir -p "$BASE_DIR"/output

# For every map in the input directory
for FILENAME in ./input/*.osm.pbf; do
	# Strip only the map name
	MAP_NAME=$(echo $FILENAME | sed -e 's/.\/input\///' -e 's/.osm.pbf//g' -e 's/-latest//g')
	echo "Now processing map $MAP_NAME"

	# Set the name and abbreviation for known countries
	COUNTRYARGS=""
	if [ "$MAP_NAME" == "spain" ]; then
		COUNTRYARGS=" --country-name=Spain --country-abbr=ES "
	elif [ "$MAP_NAME" == "andorra" ]; then
		COUNTRYARGS=" --country-name=Andorra --country-abbr=AND "
	elif [ "$MAP_NAME" == "france" ]; then
		COUNTRYARGS=" --country-name=France --country-abbr=FR "
	elif [ "$MAP_NAME" == "morocco" ]; then
		COUNTRYARGS=" --country-name=Morocco --country-abbr=MAR "
	fi

	# For each style to be generated
	for STYLE in ${STYLES[@]}; do
		echo "Creating map in style $STYLE"
		# Increment the MAP ID so every map has a different number

		MAP_NUM=$(expr $MAP_NUM + 1000)
		echo "Map ID is $MAP_NUM"

		# Put the split map into a new temporary directory
		rm -rf ./work/processed_map
		mkdir -p ./work/processed_map
		java -Xms8g -Xmx16g -jar ./splitter/splitter.jar $FILENAME --output-dir=./work/processed_map --mapid=$MAP_NUM


		WORK_DIR="${BASE_DIR}/work/${MAP_NAME}_${STYLE}"
		mkdir "$WORK_DIR"
		cd "$WORK_DIR"
		FULL_MAP_NAME="OSM_${MAP_NAME}_${STYLE}"
		java -Xms8g -Xmx16g -jar $BASE_DIR/mkgmap/mkgmap.jar \
			--style-file=$BASE_DIR/styles \
			--style=$STYLE \
			--route \
			--index \
			--split-name-index \
			--housenumbers \
			--add-pois-to-areas \
			--improve-overview \
			--bounds=$BASE_DIR/input/bounds \
			--precomp-sea=$BASE_DIR/input/sea \
			--generate-sea \
			--output-dir=$WORK_DIR \
			--family-name=${FULL_MAP_NAME} \
			--description=${FULL_MAP_NAME} \
		       	${COUNTRYARGS} \
			-c $BASE_DIR/work/processed_map/template.args \
			--gmapsupp 
		cd "$BASE_DIR"
		mv $WORK_DIR/gmapsupp.img ./output/${MAP_NAME}_${STYLE}.img
		rm -rf $WORK_DIR
	done
done
