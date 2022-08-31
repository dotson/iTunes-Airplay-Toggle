#!/usr/bin/osascript -l AppleScript

on run argv
	
	set workflowFolder to do shell script "pwd"
	set wlib to load script POSIX file (workflowFolder & "/q_workflow.scpt")
	set wf to wlib's new_workflow()
	
	set action to (system attribute "default_action")
	if action is "toggle" then
		set action to "Toggle Each"
	else
		set action to "Select One"
	end if
	
	set icon to "Icons/icon.png"
	set icon_on to "Icons/volume_up.png"
	set icon_off to "Icons/volume_mute.png"

	add_result of wf without isValid given theUid:"", theArg:"", theTitle:"Available AirPlay Devices:", theAutocomplete:"", theSubtitle:"Select to toggle state via default method: " & action, theIcon:icon, theType:"", theQuicklookurl:""
	
	tell application "Music"
		
		set apDevices to (get name of every AirPlay device)
		set apNames to {}
		set apSelectedBool to {}
		set apSelected to {}
		
		repeat with i from 1 to length of apDevices
			set thisDevice to item i of apDevices
			
			set thisName to thisDevice as string
			set the end of apNames to thisName
			set thisBool to selected of AirPlay device thisDevice
			set the end of apSelectedBool to thisBool
			if thisBool is true then
				set thisSel to "On"
				set thisIcon to icon_on
				set the end of apSelected to thisSel
			else
				set thisSel to "Off"
				set thisIcon to icon_off
				set the end of apSelected to thisSel
			end if
			
			add_result of wf with isValid given theUid:"", theArg:thisName, theTitle:thisName, theAutocomplete:"", theSubtitle:"Current State: " & thisSel, theIcon:thisIcon, theType:"", theQuicklookurl:""
			
		end repeat
		
	end tell
	
	wf's to_xml("")
	
end run