(*
 *)

set bin_folder to "bin"
set etc_folder to "etc"
set inc_folder to "include"

set root_path to (path to current user folder as string) & "Dropbox:opt:init-os-x" as string
set setup_script to "Setup.sh"
set terminal_name to "Salander"
set terminal_profile to inc_folder & ":" & terminal_name & ".terminal"
set terminal_setup_script to bin_folder & ":Terminal.sh"

try
	-- Skip this step, because the hostname supposes to be set before Dropbox installed.
	(*
	-- Set computer name
	tell application "System Preferences"
		-- In VMware, model will be Mac
		set computer_name to the computer name of the (system info)
		-- Get computer model, like MacBookAir or Macmini.
		set model to paragraphs of (do shell script "system_profiler SPHardwareDataType | grep 'Model Name' | cut -d ':' -f 2 | sed 's/ //g'")

		if computer_name is not "K-" & model then
			activate
			set current pane to pane "com.apple.preferences.sharing"
			tell application "System Events" to tell text field 1 of window "Sharing" of process "System Preferences"
				-- Requires enable access for assistive devices.
				keystroke tab
				keystroke "K-" & model
				keystroke enter
			end tell
		end if

		-- Just to make sure it pops up to the front
		activate
	end tell
	*)
	
	-- Read configuration file to get required files list
	set config_path to POSIX path of (root_path & ":etc:Info.plist")
	tell application "System Events"
		--set config_file to property list file config_path
		set itemNodes to property list items of property list item "RequiredFiles" of property list file config_path
		set msg to "Still downloading:
"
		set quit_flag to false
		
		repeat with i from 1 to number of items in itemNodes
			set itemNode to value of item i of itemNodes as string
			
			-- Check needed files
			tell application "Finder"
				set f to (POSIX path of root_path) & "/" & itemNode
				if not (exists my POSIX file f) then
					set quit_flag to true
					set msg to msg & itemNode & "
"
				end if
			end tell
		end repeat
		
		if quit_flag is true then
			display dialog msg
			return
		end if
	end tell
	
	
	tell application "Terminal"
		set command to "open " & quoted form of (POSIX path of (root_path & ":" & terminal_profile))
		
		if (count of windows) is 0 then
			do script command
		else
			do script command in window 1
		end if
		
		delay 3
		
		repeat (count of windows) times
			do script "exit" in window (count of windows)
			close window (count of windows)
		end repeat
		
		quit
	end tell
	
	delay 1
	
	-- Setup Terminal.app
	tell application "Terminal"
		activate
		set command to "sh " & POSIX path of (root_path & ":" & terminal_setup_script)
		
		if (count of windows) is 0 then
			do script command
		else
			do script command in window 1
		end if
		
		delay 3
		
		repeat (count of windows) times
			do script "exit" in window (count of windows)
			close window (count of windows)
		end repeat
		
		quit
	end tell
	-- End of setup Terminal.app
	
	delay 1
	
	tell application "Terminal" to activate
	set ret to the button returned of (display dialog "Do you want to continue?" buttons {"Cancel", "Continue"} default button 2 with icon caution)
	if ret is "Cancel" then return
	
	tell application "Terminal"
		activate
		
		do script "cd " & POSIX path of (root_path & ":" & bin_folder) in window (count of windows)
		
		do script "sh " & setup_script in window (count of windows)
	end tell
	
	return
	
on error e number n
	log e & n
end try

