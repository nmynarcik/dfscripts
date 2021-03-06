/*
----------------------------------------------------------------------------

 AutoHotKey transition from AutoIt
 Author:         RedSeal

 Script Function:
	Darkfall Scripts converted from AutoIt script.

----------------------------------------------------------------------------- 
*/
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


destination = %A_WorkingDir%\images\splash.jpg

SplashImage, %destination%, , , , DFScripts
SoundPlay, %A_WorkingDir%\audio\WATER.WAV
Sleep, 3000
SplashImage, Off

;Set the number of rays you have here
num_rays = 7

;Variables
potted := false
$PotTimer = -60000
g_cool = false

k_1 = {RShift Down}7{RShift Up}   	;Pungent Mist
k_2 = {RShift Down}1{RShift Up}		;Dragon's Breath
k_3 = {RShift Down}3{RShift Up}		;Impale
k_4 = {RShift Down}4{RShift Up}		;Insect Swarm
k_5 = {RShift Down}2{RShift Up}		;Unholy Caress   
k_6 = {RShift Down}5{RShift Up}		;Frost Bite    
k_7 = {RShift Down}6{RShift Up}		;Lightning Bolt

;Tweak cooldowns here
cd_1 = 16000  ;Pungent Mist
cd_2 = 14000  ;Dragon's Breath
cd_3 = 6500   ;Impale
cd_4 = 13000  ;Insect Swarm
cd_5 = 14000  ;Unholy Caress
cd_6 = 9500   ;Frost Bite
cd_7 = 9000   ;Lightning Bolt

r_1 = 1	 ;Pungent Mist
r_2 = 1	 ;Dragon's Breath
r_3 = 1  ;Impale
r_4 = 1	 ;Insect Swarm
r_5 = 1  ;Unholy Caress
r_6 = 1	 ;Frost Bite
r_7 = 1  ;Lightning Bolt

gCool:
g_cool = false
return

;Subroutine group to reset ray cds
1:
2:
3:
4:
5:
6:
7:
r_%A_ThisLabel% = 1
Return

; Quick Loot Setup
IniRead, xdest, %iniFile%, Loot, 1425   ; x destination used for quick looter
IniRead, ydest, %iniFile%, Loot, 627    ; y destination

;****************************************
; Quick loot
; Alt+Right Click - sets the location
; Alt+Left Click - moves item under cursor to set location
;
~$!Lbutton:: 
	MouseGetPos, x1, y1
	MouseClickDrag, left, x1, y1, xdest, ydest, 0 	;0 is mouse speed, 0 is instant
	MouseMove, x1, y1, 0 							;0 is mouse speed, 0 is instant
Return

;Loot destination setup
~$!Rbutton:: 
	MouseGetPos, xdest, ydest
	IniWrite, %xdest%, %iniFile%, Loot, xdest
	IniWrite, %ydest%, %iniFile%, Loot, ydest
Return

;hotkey to kill script
End::terminate()

#If !isMouseShown() and #If WinActive("Darkfall Online")

;Set your ray HotKey here (currently set to Mid Mouse Button)
Numpad4::
SetCapsLockState, Off
;Set heavy staff here, if you don't want to use that remove the next send/sleep lines, change sleep suit ping

;MsgBox,,%g_cool%

if g_cool = false
{
       
	cur_ray := RayLogic()
	if cur_ray > 0
	{
		
		g_cool = true
		KeySend(cur_ray)
		sleep, 30
		SendInput {LButton}
		
		SetTimer, gCool , -1200

		r_%cur_ray% = 0  
		neg_cur_cool := -cd_%cur_ray%
		SetTimer , %cur_ray% , %neg_cur_cool%
	}else{
		SendInput +{Numpad9}
		Sleep, 20
		SendInput {LButton}
	}
}

Return

;Sends the key of the current ray
KeySend(cur_ray)
{
        global
 
        SendInput , % k_%cur_ray%
        Return
}


RayLogic()
{
	global
	
	num = 0
	; find the first available ray off cooldown
	Loop, 6
    {
		if (r_%A_Index% = 1)
		{
		num = %A_Index%
		break
		}
	}
	Return num
}

1::whirlwind()
2::powerAttack()
3::knockback()
4::disableParry()
~6::
~7::
~8::
	drinkPot()
return
	
~*v::sword_board()

;****************************************
;  Sprint Toggle
;
~*w::F10 ;supposedly this should work

;your gui mode key
~Escape::
	GetKeyState, state, F10
	if(state == "D") {
		Sleep, 100
		SendInput {F10 up}
		SendInput {F10 down}
	}
return

;your autorun key
~UP::
	SendInput {F10 down}
return


;****************************************
;
;   Functions

whirlwind()
{
    SendInput 1
	SendInput +q ;gsword ww
	SendInput +d ;disable shot
	SendInput +e ;knives ww
	SendInput !^+q ;pole ww
}   ;==>whirlwind


powerAttack()
{
	SendInput 2
	SendInput ^+q ;gsword power
	SendInput ^+e ;knives power
	SendInput !^+e ;pole power
}   ;==>powerAttack

knockback()
{
	SendInput 3
	SendInput !+q ;sword knockback
	SendInput !+e ;knives knockback
	SendInput !^+d ;pole knockback
}   ;==>knockback

disableParry()
{
	SendInput 4
	SendInput !^+l
}   ;==>disableParry

sword_board()
{
	SendInput N
	Sleep, 550
	SendInput O
	TrayTip, DF Scripts, Sword/Board Ready!, 3, 1
}  ;==>sword_board


;Pot functions
drinkPot()
{
	global
	if (potted = false){
		TrayTip, DF Scripts, Drinking Pot!, 5, 2
		SoundPlay %A_WorkingDir%\audio\drinkingpot.wma
		potted = true
		SetTimer, potReady, %$PotTimer%
	}
}   ;==>drinkPot

;announce pot is ready
potReady:
{
	TrayTip, DF Scripts, Pot Ready!, 5, 2
	SoundPlay, %A_WorkingDir%\audio\potready.wma
	potted := false
	return
}   ;==>potReady

; GUI check in game
isMouseShown()
{
	StructSize := A_PtrSize + 16
	VarSetCapacity(InfoStruct, StructSize)
	NumPut(StructSize, InfoStruct)
	DllCall("GetCursorInfo", UInt, &InfoStruct)
	Result := NumGet(InfoStruct, 8)

	if Result
	return 1
	else
	return 0
} 

;end the script
terminate()
{
	SoundPlay, %A_WorkingDir%\audio\soft_whoosh10.wav, WAIT
	ExitApp
} ;==>terminate
