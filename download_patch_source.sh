#!/bin/sh

# Copyright 2021 JAMF Software, LLC
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of this 
# software and associated documentation files (the "Software"), to deal in the Software 
# without restriction, including without limitation the rights to use, copy, modify, 
# merge, publish, distribute, sublicense, and/or sell copies of the Software, and to 
# permit persons to whom the Software is furnished to do so, subject to the following 
# conditions:
# 
# The above copyright notice and this permission notice shall be included in all copies 
# or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
# CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR 
# THE USE OR OTHER DEALINGS IN THE SOFTWARE.


# USING THIS SCRIPT
#
# Populate the configuration variables below with the required information
# SRC_HOST is as the hostname is configured within Jamf Pro, i.e. it sometimes has the 
# trailing /v1
# SRC_SIGN is set to '0' if code signing is not enabled on the patch source, '1' if it is
# IDS is an optional subset of patch ID values to download, if not set everything will be 
# downloaded
#
# Once the variables have been set, simply run the script


# Configuration
SRC_HOST="my_host.kinobicloud.io"    # Hostname of patch source to get definitions from
SRC_SIGN=0		                     # 0 if not code-signed, 1 if code-signing is enabled

# IDS=( 20A 115 310 2C1 )            # Un-comment and populate with selected IDs to 
                                     # migrate only selected titles


PROGRAM=$(basename "${0}")

WD="$(dirname "${0}")"

mkdir -p "${WD}/${SRC_HOST}/patch"

if [ ${#IDS[@]} -eq 0 ]; then
	echo "Generating patch ID list"
	IFS=$'\n'
	IDS=( $(curl -s -X GET "https://${SRC_HOST}/software" -H "Accept: application/json" --output - | grep '"id":' | cut -d \" -f 4) )
	unset IFS
fi

echo "${#IDS[@]} to download"

for ID in "${IDS[@]}" ; do
	echo "Downloading: ${ID}"
	if [ ${SRC_SIGN} -ne 0 ] ; then
		curl -s -L -X GET "https://${SRC_HOST}/patch/${ID}" -H "Accept: application/json" --output - | security cms -D > "${WD}/${SRC_HOST}/patch/${ID}.json"
	else
		curl -s -L -X GET "https://${SRC_HOST}/patch/${ID}" -H "Accept: application/json" --output - > "${WD}/${SRC_HOST}/patch/${ID}.json"
	fi
done

echo "Download complete"
open "${WD}/${SRC_HOST}/patch"

exit 0