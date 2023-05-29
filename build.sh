#!/bin/bash

# Make bash exit when an error occurs
set -euo pipefail
set -x

# Extract the version number from 'info.json'
VERSION="$(jq -r '.version' src/info.json)"

# convert the svg chess set to png files
inkscape --export-type=png -w 128 -h 128 ./assets/cburnett/*.svg

# clean our output directory
rm -rf ./out

# output directory
OUT=./out/chess_$VERSION
mkdir -p $OUT

cp -r LICENSE src/* locale assets $OUT
rm ./assets/cburnett/*.png $OUT/assets/cburnett/*.svg

# Generate the thumbnail
inkscape -o $OUT/thumbnail.png -w 144 -h 144 ./assets/cburnett/wN.svg

# Package the mod for factorio.com
cd ./out
zip -r "chess_$VERSION.zip" chess_$VERSION

echo
echo "Done!"
echo "Mod zip can be found at: ./out/chess_$VERSION.zip"
