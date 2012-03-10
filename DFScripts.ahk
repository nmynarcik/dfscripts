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

/*
;Variables
Global $Potted = False
Global $PotTimer = -60000

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

*/

;Set the number of rays you have here
num_rays = 7

;Set the number of rays you have here
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

;hotkey to kill script
End::terminate()

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
		sleep, 20
		Send, {LButton}
		
		SetTimer, gCool , -1200

		r_%cur_ray% = 0  
		neg_cur_cool := -cd_%cur_ray%
		SetTimer , %cur_ray% , %neg_cur_cool%
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



#If !isMouseShown() and #If WinActive("Darkfall Online")

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


;****************************************
;
;   Functions

whirlwind()
{
    Send 1
	Send +q ;gsword ww
	Send +d ;disable shot
	Send +e ;knives ww
	Send !^+q ;pole ww
}   ;==>whirlwind


powerAttack()
{
	Send 2
	Send ^+q ;gsword power
	Send ^+e ;knives power
	Send !^+e ;pole power
}   ;==>powerAttack

knockback()
{
	Send 3
	Send !+q ;sword knockback
	Send !+e ;knives knockback
	Send !^+d ;pole knockback
}   ;==>knockback

disableParry()
{
	Send 4
	Send !^+l
}   ;==>disableParry

sword_board()
{
	Send N
	Sleep, 500
	Send O
	TrayTip, DF Scripts, Sword/Board Ready!, 3, 1
}  ;==>sword_board


;Pot functions
drinkPot()
{
	if ($Potted == False){
		TrayTip, DF Scripts, Drinking Pot!, 5, 2
		SoundPlay %A_WorkingDir%\audio\drinkingpot.wma
		$Potted = True
		SetTimer, potReady, %$PotTimer%
		return
	}
	return
}   ;==>drinkPot

;announce pot is ready
potReady:
{
	TrayTip, DF Scripts, Pot Ready!, 5, 2
	SoundPlay, %A_WorkingDir%\audio\potready.wma
	$Potted = False
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
