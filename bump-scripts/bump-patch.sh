#!/usr/bin/env bash

PROJECT_NAME='<YOUR_PROJECT_NAME_IOS>'
echo "==================== Expected Execution from project root e.g ls contains ./package.json"
ls



echo "==================== Bumping patch number in package.json ===================="
# E.g npm version patch --no-git-tag-version
yarn bump-patch-only


echo "==================== Extracting new version from package.json ==================== "
# Grep package version out of the 
PACKAGE_VERSION=$(cat package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g' \
  | tr -d '[[:space:]]')

echo "New package version/tag is: "
echo $PACKAGE_VERSION

cd bump-scripts

source ./xcode-build-bump.sh $PACKAGE_VERSION $PROJECT_NAME
source ./sync-android-version-build-numbers.sh $PACKAGE_VERSION $PROJECT_NAME