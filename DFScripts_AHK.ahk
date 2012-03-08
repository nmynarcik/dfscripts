/*
----------------------------------------------------------------------------

 AutoHotKey transition from AutoIt
 Author:         RedSeal

 Script Function:
	Darkfall Scripts converted from AutoIt script.

----------------------------------------------------------------------------- 
*/

destination = %A_WorkingDir%\images\splash.jpg

SplashImage, %destination%, , , , DFScripts
SoundPlay, %A_WorkingDir%\audio\WATER.WAV
Sleep, 3000
SplashImage, Off

;Variables
Global $Potted = False
Global $PotTimer := -60000

Global $PM = 0, $IM = 0, $IS = 0, $UC = 0, $DB = 0, $FB = 0, $LB = 0
Global $PMTime, $IMTime, $ISTime, $UCTime, $DBTime, $FBTime, $LBTime
Global $RayCasted = 0, $RayCastTime

; Quick Loot Setup
IniRead, xdest, %iniFile%, Loot, 1425   ; x destination used for quick looter
IniRead, ydest, %iniFile%, Loot, 627    ; y destination

;****************************************
; Quick loot
; Alt+Right Click - sets the location
; Alt+Left Click - moves item under cursor to set location
;
$!Lbutton:: 
	MouseGetPos, x1, y1
	MouseClickDrag, left, x1, y1, xdest, ydest, 0 	;0 is mouse speed, 0 is instant
	MouseMove, x1, y1, 0 							;0 is mouse speed, 0 is instant
Return

;Loot destination setup
$!Rbutton:: 
	MouseGetPos, xdest, ydest
	IniWrite, %xdest%, %iniFile%, Loot, xdest
	IniWrite, %ydest%, %iniFile%, Loot, ydest
Return

;hotkey to kill script
End::terminate()

#If !isMouseShown() and #If WinActive("Darkfall Online")

1::whirlwind()
2::powerAttack()
3::knockback()
4::disableParry()

6::
7::
8::
drinkPot()
return
	
~*v::sword_board()
/*
HotKeySet("{NUMPAD4}", "RayCast")
*/

;Binds are set here
	k_1 = {RShift Down}7{RShift Up}   	;Pungent Mist
	k_2 = {RShift Down}1{RShift Up}		;Dragon's Breath
    k_3 = {RShift Down}3{RShift Up}		;Impale
	k_4 = {RShift Down}4{RShift Up}		;Insect Swarm
    k_5 = {RShift Down}2{RShift Up}		;Unholy Caress   
    k_6 = {RShift Down}5{RShift Up}		;Frost Bite    
    k_7 = {RShift Down}6{RShift Up}		;Lightning Bolt
     
    ;Cooldowns are set here
	cd_1 = 16000  ;Pungent Mist
	cd_2 = 14000  ;Dragon's Breath
    cd_3 = 6500   ;Impale
	cd_4 = 13000  ;Insect Swarm
    cd_5 = 14000  ;Unholy Caress
    cd_6 = 9500   ;Frost Bite
    cd_7 = 9000   ;Lightning Bolt
     
    ;Ray priority is set here
	p_1 = 1			;Pungent Mist
    p_2 = 2      	;Impale
    p_3 = 3      	;Unholy Caress
    p_4 = 4      	;Dragon's Breath
    p_5 = 5       	;Frost Bite
    p_6 = 6       	;Insect Swarm
    p_7 = 7       	;Lightning Bolt
     
    ;Initializes ray availability array to 1 (off cooldown)
    While A_Index <= 7
    {
         a_%A_Index% = 1
    }
    While A_Index <= 7
    {
         a_f_%A_Index% = 1
    }
    ~rbutton::
    cur_ray := RayCheck(cur_ray)
    KeySend(cur_ray)
    Hotkey , ~LButton , TimerStart , On
    Return
     
    TimerStart:
    Hotkey , ~LButton , TimerStart , Off
    TimerCreate(cur_ray)
    Return
     
    ;Subroutine group to reset ray cds
    1:=
    2:=
    3:=
    4:=
    5:=
    6:=
	7:=
    a_%A_ThisLabel% = 1
    Return
           
    /*Assigns the value of cur_ray to the first available
    ray according to priority
    */
    RayCheck(cur_ray)
    {
            global
           
            /*Initiates cur_ray to your highest priority ray
            in the case of all rays being off cooldown
            */
            cur_ray := p_1
     
            While A_Index <= 6
        {
        ray_number := p_%A_Index%
            if (a_%ray_number% = 1)
            {
                    cur_ray := ray_number
                    Break
                    }
            }
            Return cur_ray
    }
     
    ;Sends the key of the current ray
    KeySend(cur_ray)
    {      
            global
           
            SendInput , % k_%cur_ray%
            Return
    }
     
    ;Creates a timer to reset the ray cooldown
    TimerCreate(cur_ray)
    {
            global
           
            a_%cur_ray% = 0
            SetTimer , %cur_ray% , % -cd_%cur_ray%
            Return
    }  


;****************************************
;  Sprint Toggle
;
~*w::F12 ;supposedly this should work
/*
~*w::
 send {f12 down}
 keywait w
 send {f12 up}
return
*/

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

/*
Func RayReset()
	if (TimerDiff($PMTime) > 16000) Then
		$PM = 0
	EndIf
	if (TimerDiff($IMTime) > 6000) Then
		$IM = 0
	EndIf
	if (TimerDiff($ISTime) > 13000) Then
		$IS = 0
	EndIf
	if (TimerDiff($DBTime) > 14000) Then
		$DB = 0
	EndIf
	if (TimerDiff($UCTime) > 14000) Then
		$UC = 0
	EndIf
	if (TimerDiff($FBTime) > 8000) Then
		$FB = 0
	EndIf
	if (TimerDiff($LBTime) > 8000) Then
		$LB = 0
	EndIf
	if (TimerDiff($RayCastTime) > 500) Then
		$RayCasted = 0
	EndIf
EndFunc   ;==>RayReset

Func RayCast()
	;Send("{LSHIFT DOWN}{NUMPAD2}{LSHIFT UP}")
	Sleep(100)
	If ($RayCasted = 0) Then
		If ($PM = 0) Then ;pungent mist
			Send("{RShift Down}7{RShift Up}")
			Sleep(10)
			MouseClick("Left")
			$PMTime = TimerInit()
			$PM = 1
			$RayCastTime = TimerInit()
			$RayCasted = 1
			Return
		EndIf
		If ($DB = 0) Then ;dragon breathe
			Send("{RShift Down}1{RShift Up}")
			Sleep(10)
			MouseClick("Left")
			$DBTime = TimerInit()
			$DB = 1
			$RayCastTime = TimerInit()
			$RayCasted = 1
			Return
		EndIf
		If ($IM = 0) Then ;impale
			Send("{RShift Down}3{RShift Up}")
			Sleep(10)
			MouseClick("Left")
			$IMTime = TimerInit()
			$IM = 1
			$RayCastTime = TimerInit()
			$RayCasted = 1
			Return
		EndIf
		If ($IS = 0) Then ;insect swarm
			Send("{RShift Down}4{RShift Up}")
			Sleep(10)
			MouseClick("Left")
			$ISTime = TimerInit()
			$IS = 1
			$RayCastTime = TimerInit()
			$RayCasted = 1
			Return
		EndIf
		If ($UC = 0) Then ;unholy caress
			Send("{RShift Down}2{RShift Up}")
			Sleep(10)
			MouseClick("Left")
			$UCTime = TimerInit()
			$UC = 1
			$RayCastTime = TimerInit()
			$RayCasted = 1
			Return
		EndIf
		If ($FB = 0) Then ;frostbite
			Send("{RShift Down}5{RShift Up}")
			Sleep(10)
			MouseClick("Left")
			$FBTime = TimerInit()
			$FB = 1
			$RayCastTime = TimerInit()
			$RayCasted = 1
			Return
		EndIf
		If ($LB = 0) Then ;lightning bolt
			Send("{RShift Down}6{RShift Up}")
			Sleep(10)
			MouseClick("Left")
			$LBTime = TimerInit()
			$LB = 1
			$RayCastTime = TimerInit()
			$RayCasted = 1
			Return
		EndIf
	EndIf
EndFunc   ;==>RayCast
*/

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