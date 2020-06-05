on adb_init(adb)
	if (do shell script adb & "devices -l") does not contain "192.168.0.2" then
		do shell script adb & "tcpip 5555"
		display dialog "Disconnect device" with icon caution
		do shell script adb & "connect 192.168.0.2:5555"
		delay (1)
	end if
end adb_init

on adb_kill(adb)
	do shell script adb & "kill-server"
end adb_kill

on run {input, parameters}
	set adb to "/usr/local/Caskroom/android-platform-tools/28.0.3/platform-tools/adb "
	adb_init(adb)
	display dialog "Ending" with icon caution
	--adb_kill(adb)
	return 0
end run
