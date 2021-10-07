# Kinobi Title Editor

## Download Patch Source

This is a tool to download custom Patch Definitions from a Patch External Source, for import into Title Editor.

## Using This Script

Populate the configuration variables with the required information.

SRC_HOST is as the hostname is configured within Jamf Pro, i.e. it sometimes has the trailing /v1 or /v1.php

SRC_SIGN is set to '0' if code signing is not enabled on the patch source, '1' if it is

IDS is an optional subset of patch ID values to download, if not set everything will be  downloaded.

Once the variables have been set, simply run the script.

The script will create a folder in the same directory as the script, which contains the JSON files for all downloaded definitions which may be imported into Title Editor.
