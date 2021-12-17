#!/usr/bin/env bash

echo "========== Executing xcode-build-bump ==================== "
PATH_TO_PLIST="../ios/$2/Info.plist"

echo $1
newVersion=$1
echo "================ BUILD NUMBER ====================="
buildNumber=`grep -C 2 CFBundleVersion $PATH_TO_PLIST | grep string | grep '>' | sed 's/\///g' | sed "s/<string>//g" | awk '{print $1;}'`
echo "Current build number: $buildNumber"
increment=$(($buildNumber + 1))
echo "Next build number: $buildNumber"

echo "==================== BUILD VERSION ===================="
versionString=`grep -C 2 CFBundleShortVersionString $PATH_TO_PLIST | sed -n '/CFBundleShortVersionString/,/string>/p' | sed -n '/<string>/,/<\/string>/p' | grep '>' | sed 's/\///g' | sed "s/<string>//g" | awk '{print $1;}'`
echo "Current build version: $versionString"
echo "Next build version: $newVersion"

echo "==================== SED Substitution ===================="
sed -i "" "s/<string>$buildNumber<\/string>/<string>$increment<\/string>/g" ${PATH_TO_PLIST}
sed -i "" "s/<string>${versionString}<\/string>/<string>$newVersion<\/string>/g" ${PATH_TO_PLIST}
echo "====================  IOS Completed   ===================="

