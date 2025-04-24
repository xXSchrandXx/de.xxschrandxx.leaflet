#!/bin/bash

PACKAGE_NAME="de.xxschrandxx.leaflet"
PACKAGE_TYPES=("files" "templates")

npm install

npx tsc

# Kopiere leaflet
mkdir -p ./files/js/3rdParty/leaflet
cp ./node_modules/leaflet/dist/leaflet.js ./files/js/3rdParty/leaflet/
cp ./node_modules/leaflet/dist/leaflet.js.map ./files/js/3rdParty/leaflet/
cp ./node_modules/leaflet/dist/leaflet.css ./files/js/3rdParty/leaflet/
mkdir -p ./files/js/3rdParty/leaflet/images
cp ./node_modules/leaflet/dist/images/*.png ./files/js/3rdParty/leaflet/images/
cp ./node_modules/leaflet/LICENSE ./files/js/3rdParty/leaflet/

for i in "${PACKAGE_TYPES[@]}"; do
    rm -f ./$i.tar
    7z a -ttar -mx=9 ./$i.tar ./$i/*
done

rm -f $PACKAGE_NAME.tar
rm -f $PACKAGE_NAME.tar.gz
7z a -ttar -mx=9 $PACKAGE_NAME.tar ./ -x!acptemplates -x!files -x!files_wcf -x!templates -x!$PACKAGE_NAME.tar -x!$PACKAGE_NAME.tar.gz -x!.git -x!.gitignore -x!.gitattributes -x!make.sh -x!make.bat -x!.github -x!php_cs.dist -x!.phpcs.xml -x!Readme.md -x!pictures -x!node_modules -x!package-lock.json -x!package.json -x!tsconfig.json -x!ts -x!constants.php -x!composer.json -x!composer.lock -x!.editorConfig
7z a $PACKAGE_NAME.tar.gz $PACKAGE_NAME.tar
rm -f "./$PACKAGE_NAME.tar"

for i in "${PACKAGE_TYPES[@]}"; do
    rm -f ./$i.tar
done

rm -rf ./files/js/
