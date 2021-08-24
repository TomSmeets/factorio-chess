#!/bin/bash

set -euo pipefail

VERSION="$(jq -r '.version' info.json)"
echo "version = $VERSION"

rm -rf   ./out
mkdir -p ./out

mkdir out/chess
mkdir out/chess/assets
cp ./info.json         ./out/chess
cp ./LICENSE           ./out/chess
cp ./data.lua          ./out/chess
cp ./assets/black.png  ./out/chess/assets
cp ./assets/white.png  ./out/chess/assets

mkdir -p ./out/chess/assets/cburnett
inkscape --export-type=png -w 128 -h 128 ./assets/cburnett/*.svg
mv ./assets/cburnett/*.png ./out/chess/assets/cburnett/

# Thumbnail
inkscape -o ./out/chess/thumbnail.png -w 144 -h 144 ./assets/cburnett/wN.svg

cd ./out
zip -r "chess_$VERSION.zip" chess

echo
echo "Done!"
echo "Mod zip can be found at: ./out/chess_$VERSION.zip"
