'Alarm program Copyright Jamie Siviter 2015 All Rights Reserved

let b1 = 0
'Input definitions:
symbol IN_LIGHT_SWITCH = pinC.0
symbol IN_KEY_SWITCH = pinC.1
symbol IN_TRIGGER = pinC.2
symbol IN_LOCK_RELEASE = pinC.6
'Output definitions:
symbol OUT_LIGHT = 7
symbol OUT_ALARM = 6
symbol OUT_LOCK_RELEASE = 5
	
main:
	gosub setup	'Inititiate startup procedure

setup:
	gosub setLow
	'Set all outputs off
	if IN_KEY_SWITCH = 1 then : goto armed : else : goto unarmed : endif

setLow:			'This subroutine sets all outputs low.
	low 0			'It is called at the start of the program,
	low 1			'and whenever an output is set.
	low 2			
	low 3
	low 4
	low 5
	low 6
	low 7

armed:			'This procedure is used when the device is armed
	do			'If the keyswitch is on, then wait for trigger
		if IN_TRIGGER = 1 then : high OUT_ALARM : endif		'If trigger is activated, put the alarm high
	loop while IN_KEY_SWITCH = 1

unarmed:
	low OUT_ALARM
	do
		if IN_LIGHT_SWITCH = 1 then			'If light button pressed then
			gosub lightCycle				'Go to lightCycle subroutine to increment light state
		else if IN_LOCK_RELEASE: = 1 then		'If lock release button pressed then
			gosub lockRelease				'Go to lockRelease subroutine to release lock
		endif
		if b1 = 2 then					'See below, if variable is in 'flashing mode'
			toggle OUT_LIGHT				'Toggle light every loop
			pause 500					'Wait half a second
		endif
	loop while IN_KEY_SWITCH = 0				'Loop above subroutine


lightCycle:
	if b1 = 0 then		'If light is off then
		inc b1		'tell variable that light is in 'on' mode
		high OUT_LIGHT	'Turn light on
	else if b1 = 1 then	'If light is on steady then
		inc b1		'tell variable that light is in 'flashing' mode
					'See above: if b1 = 2 then
					'			toggle OUT_LIGHT
	else				'Otherwise
		b1 = 0		'tell variable that light in in 'off' mode
		low OUT_LIGHT	'turn light off
	endif

lockRelease:
	high OUT_LOCK_RELEASE	'Power solenoid to unlock
	sleep 3			'Wait 3 seconds
	low OUT_LOCK_RELEASE	'reactivate lock
