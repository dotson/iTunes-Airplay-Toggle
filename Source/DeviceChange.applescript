#!/usr/bin/osascript -l AppleScript

on run argv
	
	set query to argv as string
	
	set workflowFolder to do shell script "pwd"
	set wlib to load script POSIX file (workflowFolder & "/q_workflow.scpt")
	set wf to wlib's new_workflow()
	
	set action to (system attribute "default_action")
	set alt to (system attribute "alt")
	
	if alt is "true" then
		if action is "toggle" then set action to "select"
	else if action is "select" then
		set action to "toggle"
	end if
	
	tell application "Music"
		
		set apDevices to (get name of every AirPlay device)
		
		-- Toggle Action
		if action is "toggle" then
			
			repeat with i from 1 to length of apDevices
				set thisDevice to (item i of apDevices) as string
				
				if thisDevice is query then
					set oldState to selected of AirPlay device thisDevice
					set newState to (not oldState)
					set selected of AirPlay device thisDevice to newState
					if newState is true then
						set newState to "On"
					else
						set newState to "Off"
					end if
					
					return thisDevice & ": " & newState
					
				end if
			end repeat
		end if
		
		-- Select Action
		if action is "select" then
			
			-- Two loops needed. Turn the chosen device ON then turn off all remaining devices
			repeat with i from 1 to length of apDevices
				set thisDevice to (item i of apDevices) as string
				if thisDevice is query then
					set selected of AirPlay device thisDevice to true
				end if
			end repeat
			
			repeat with i from 1 to length of apDevices
				set thisDevice to (item i of apDevices) as string
				if thisDevice is not query then
					set selected of AirPlay device thisDevice to false
				end if
			end repeat
			
			return query & " is now selected."
		end if
		
	end tell
	
end run