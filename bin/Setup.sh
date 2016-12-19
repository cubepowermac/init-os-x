#!/bin/sh -
#
#   +--------------------------------------------------------------------------------+
#   |                                                                                |
#   |  File name     : bin/Setup.sh                                                  |
#   |  Version       : 1.0.0.0                                                       |
#   |  Author        : Kevin                                                         |
#   |  Modified Date : 2016/12/04 21:21                                              |
#   |                                                                                |
#   +--------------------------------------------------------------------------------+
#   | History                                                                        |
#   +------------+-------------------------------------------------------------------+
#   | 2015/08/12 | Add account picture.                                              |
#   +------------+-------------------------------------------------------------------+
#

DONE="Done"
CONFIG_FILE="`pwd`/${0/Setup.sh/Info.plist}"
CONFIG_FILE=${CONFIG_FILE/bin/etc}
PRINT_SCRIPT="${0/Setup/print}"
SKIP="Skip"


# Set root password
#
if [ "`defaults read $CONFIG_FILE SetRootPassword`" -eq 1 ]; then
	sudo passwd
elif [ "`whoami`" != "root" ]; then
	STR="Set root password"
	sudo printf ""		# Force to key in root password, later won't have to do it again.
	sh $PRINT_SCRIPT "$STR"
	sh $PRINT_SCRIPT ${#STR} $SKIP
fi

# Set user picture
#
if [ "`defaults read $CONFIG_FILE SetUserPicture`" -eq 1 ]; then
	STR="Set user picture"
	sh $PRINT_SCRIPT "$STR"
	dscl . -delete /Users/`whoami` jpegphoto
	dscl . -delete /Users/`whoami` Picture
	sudo dscl . -create /Users/`whoami` Picture "/Users/`whoami`/Library/Mobile Documents/Stormtrooper.jpg"
	sh $PRINT_SCRIPT ${#STR} $DONE
fi

# Software update
# It's a MUST be, because it's almost always good to updating your software.
#
STR="Open App Store"
sh $PRINT_SCRIPT "$STR"
#open /System/Library/CoreServices/Software\ Update.app
# Open App Store and switch to Purchases pane.
osascript <<EOF
tell application "App Store"
	activate
	delay 5
	tell application "System Events"
		key down {command}
		keystroke 4
		key up {command}
	end tell
end tell
EOF
sh $PRINT_SCRIPT ${#STR} $DONE

# Install Sparrow
#
if [ "`defaults read $CONFIG_FILE InstallSparrow`" -eq 1 ]; then
	STR="Install Sparrow"
	sh $PRINT_SCRIPT "$STR"
	if [ ! -d /Applications/Sparrow.app ]; then
		sudo tar -x -C /Applications/ -f ${CONFIG_FILE/etc\/Info.plist/include\/Sparrow.tgz}
		sh $PRINT_SCRIPT ${#STR} $DONE
	else
		sh $PRINT_SCRIPT ${#STR} $SKIP
	fi
fi

