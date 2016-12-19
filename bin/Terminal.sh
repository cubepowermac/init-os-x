#!/bin/bash

TARGET="Salander"

if [ $TARGET != "`defaults read com.apple.Terminal 'Default Window Settings'`" ] ; then
	echo "[Terminal] Set Default Window Settings"
	defaults write com.apple.Terminal "Default Window Settings" -string $TARGET
fi
if [ $TARGET != "`defaults read com.apple.Terminal 'Startup Window Settings'`" ]; then
	echo "[Terminal] Set Startup Window Settings"
	defaults write com.apple.Terminal "Startup Window Settings" -string $TARGET
fi

