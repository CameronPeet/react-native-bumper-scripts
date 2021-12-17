#!/bin/bash

# exit if a command fails
set -e
echo "========== Executing Android Sync ==================== "

echo $1
# Set the path to your ios project here
PATH_TO_PLIST="../ios/$2/Info.plist"

# Set the path to your AndroidManifest here
manifest_file="../android/app/src/main/AndroidManifest.xml"
gradle_file="../android/app/build.gradle"

version_code=`grep -C 2 CFBundleVersion $PATH_TO_PLIST | grep string | grep '>' | sed 's/\///g' | sed "s/<string>//g" | awk '{print $1;}'`
version_name=`grep -C 2 CFBundleShortVersionString $PATH_TO_PLIST | sed -n '/CFBundleShortVersionString/,/string>/p' | sed -n '/<string>/,/<\/string>/p' | grep '>' | sed 's/\///g' | sed "s/<string>//g" | awk '{print $1;}'`
#
# Required parameters
if [ -z "${gradle_file}" ] ; then
  echo " [!] Missing required input: gradle_file"
  exit 1
fi
if [ ! -f "${gradle_file}" ] ; then
  echo " [!] File doesn't exist at specified gradle_file path: ${gradle_file}"
  exit 1
fi

if [ -z "${version_code}" ] ; then
  echo " [!] No version_code specified!"
  exit 1
fi

# ---------------------
# --- Configs:

echo " (i) Provided Gradle File path: ${gradle_file}"
echo " (i) Version Code: ${version_code}"
if ! [ -z "${version_name}" ] ; then
  echo " (i) Version Name: ${version_name}"
fi


VERSIONCODE=`grep versionCode ${gradle_file} | head -n1 | awk '{print $2;}'`
VERSIONNAME=`grep versionName ${gradle_file} | head -n1 | awk '{print $2;}'`

if [ -z "${VERSIONCODE}" ] ; then
  echo " [!] Could not find current Version Code!"
  exit 1
fi

echo "Version code detected: ${VERSIONCODE}"
if [ ! -z "${version_code_offset}" ] ; then
  echo " (i) Version code offset: ${version_code_offset}"

  CONFIG_new_version_code=$((${version_code} + ${version_code_offset}))
else
  CONFIG_new_version_code=${version_code}
fi

echo " (i) Version code: ${CONFIG_new_version_code}"


if [ -z "${VERSIONNAME}" ] ; then
  echo " [!] Could not find current Version Name!"
  exit 1
fi
echo "Version name detected: ${VERSIONNAME}"

# set -v
# ---- Set Build Version Code:
sed -i '' "s/versionCode ${VERSIONCODE}/versionCode ${version_code}/" ${gradle_file}

echo "versionName ${VERSIONNAME}"

# ---- Set Build Version Code if it was specified:
sed -i "" "s/versionName ${VERSIONNAME}/versionName "\"${version_name}\""/" ${gradle_file}


# ---- Remove backup:
rm -f ${manifest_file}.bak

# ==> Build Version changed

echo "========== Android Sync Complete ==================== "
