(*
on adb_scrcpy_init()
	set adb to "/usr/local/Caskroom/android-platform-tools/28.0.3/platform-tools/adb "
	if (do shell script adb & "devices -l") does not contain "192.168.0.2" then
		do shell script adb & "tcpip 5555"
		display dialog "Disconnect device" with icon caution
		do shell script adb & "connect 192.168.0.2:5555"
		delay (1)
	end if
	do shell script "PATH=/usr/local/Caskroom/android-platform-tools/28.0.3/platform-tools:$PATH
		/usr/local/Cellar/scrcpy/1.12.1/bin/scrcpy -b2M -m600"
end adb_scrcpy_init
*)

global c, tap, cast, spam

on set_global()
	set c to "/usr/local/Cellar/cliclick/4.0.1/bin/cliclick -r c:" & "145,40 w:" & "100 c:"
	set tap to 0.5
	set cast to 2.9
	set spam to 5
	--set dc to "/usr/local/Cellar/cliclick/4.0.1/bin/cliclick -r c:" & "145,40 w:" & "500 dc:"
end set_global

on adb_kill()
	display dialog "Ending?" with icon caution
	set adb to "/usr/local/Caskroom/android-platform-tools/28.0.3/platform-tools/adb "
	do shell script adb & "kill-server"
end adb_kill

on scrcpy_init()
	delay 5
	tell application "Terminal"
		do script "scrcpy -b2M -m600"
	end tell
	beep
	delay 5
	scrcpy_move()
end scrcpy_init

on scrcpy_move()
	say (do shell script "ls /usr/local/Cellar/cliclick/4.0.1/bin")
	do shell script "/usr/local/Cellar/cliclick/4.0.1/bin/cliclick -r dd:" & "705,140 du:" & "125,35"
end scrcpy_move

on open_tab(type)
	set open_skills to "205,580"
	set open_items to "205,620"
	if type is "skill" then
		do shell script c & open_skills
		delay tap + (random number from 0.0 to 0.2)
	else if type is "pot" then
		do shell script c & open_items
		delay tap + (random number from 0.0 to 0.5)
	end if
end open_tab

on close_tab()
	set close_button to "140,620"
	delay 0.1
	do shell script c & close_button
	--focus_chrome()
end close_tab

on do_delay(action)
	--activity, parameter, timer
	set type to item 4 of action
	
	if type is "dancer" or type is "omni" then
		repeat item 5 of action times
			open_tab("skill")
			do shell script item 1 of action & item 2 of action
			--close_tab()
			delay (item 3 of action) + (random number from 0.0 to 0.5)
		end repeat
	else
		open_tab(type)
		do shell script item 1 of action & item 2 of action
		--close_tab()
		delay (item 3 of action) + (random number from 0.0 to 0.5)
	end if
end do_delay

on focus_chrome()
	tell application "Google Chrome"
		activate
	end tell
end focus_chrome

on run {input, parameters}
	choose from list {"Start Mirror", "Buff", "Just Spam", "With Omni", "Kill adb"} with title "Orna Options" with prompt "Choose options" OK button name "OK" cancel button name "Cancel" default items {"Just Spam"} with multiple selections allowed
	set options to the result
	
	delay 3
	beep
	set_global()
	if options contains "Start Mirror" then scrcpy_init()
	
	set res to {c, "205,505", cast, "skill"}
	set def to {c, "75,505", cast, "skill"}
	set bear to {c, "75,455", cast, "skill"}
	set fire to {c, "205,455", cast, "skill"}
	
	set att_pot to {c, "205,295", cast, "pot"}
	set res_pot to {c, "75,145", cast, "pot"}
	set def_pot to {c, "75,245", cast, "pot"}
	set mana to {c, "75,440", cast, "pot"}
	--set mana_pot to {c, "45,490", cast, ""}
	
	set omni to {c, "205,400", cast, "omni", 3}
	set dance to {c, "76,400", cast, "skill"}
	set dancer to {c, "76,400", cast, "dancer", 7}
	
	set buffs to {}
	set attacks to {}
	if options contains "Buff" then
		set buffs to {res, def, res, def, bear, bear, fire, res_pot, att_pot, mana}
	end if
	if options contains "With Omni" then
		set attacks to {omni, mana, omni, mana, omni, mana, omni, mana, dancer, mana, dancer, mana, dancer, mana, dancer, mana, dancer, mana, dancer, mana, dancer, mana, dancer, mana, dancer, mana, dancer}
	else if options contains "Just Spam" then
		set attacks to {dancer, mana, dancer, mana, dancer, mana, dancer, mana, dancer, mana, dancer, mana, dancer, mana, dancer, mana, dancer, mana, dancer}
	end if
	
	set actions to buffs & attacks
	repeat with action in actions
		do_delay(action)
	end repeat
	
	if options contains "Kill adb" then
		adb_kill()
	end if
	return input
end run
