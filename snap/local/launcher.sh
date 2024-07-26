#!/bin/sh
# Wrapper to check for custom config $SNAP_COMMON and
# use it otherwise fall back to the included basic config which will at least
# allow mosquitto to run and do something.
# This script will also copy the full example config in to 
# SNAP_COMMON so that people can refer to it.
#

echo "Running epi-mqtt launcher script..."
# Use $SNAP_COMMON for the config files always 
COMMON=$SNAP_COMMON 
CONFIG_FILE="$SNAP/default_config.conf"
CUSTOM_CONFIG="$COMMON/mosquitto.conf"
echo "Searching for a custom config mosquitto.conf in $COMMON"

# Copy the example config if it doesn't exist
if [ ! -e "$COMMON/mosquitto_example.conf" ]
then
  echo "Copying example config to $COMMON/mosquitto_example.conf"
  echo "You can create a custom config by creating a file called $CUSTOM_CONFIG"
  cp $SNAP/mosquitto.conf $COMMON/mosquitto_example.conf
fi


# Does the custom config exist?  If so use it.
if [ -e "$CUSTOM_CONFIG" ]
then
  echo "Found config in $CUSTOM_CONFIG"
  CONFIG_FILE=$CUSTOM_CONFIG
else
  echo "Using default config from $CONFIG_FILE"
fi

# Launch the snap
$SNAP/usr/sbin/mosquitto -c $CONFIG_FILE $@
