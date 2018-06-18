Scriptname INYAMCMScript extends  ski_configbase
GlobalVariable Property INYAIndoorOnlyMode auto
GlobalVariable Property INYAScaleMode auto
GlobalVariable Property INYAWeightMode auto
GlobalVariable Property INYADebugMode auto
GlobalVariable Property INYASlotMask auto
;変数の定義
int ToggleWeightID
int ToggleIndoorID
int ToggleScaleID
int SliderDebugID
int[] ToggleSlotID
int[] SlotValue

bool bToggleIndoor = true
bool bToggleScale = true
bool bToggleWeight = true
float fSliderDebug = 1.0
bool[] bToggleSlot

; 初期化
Event OnConfigInit()
    ToggleSlotID = new int[32]
    SlotValue = new int[32]
    bToggleSlot = new Bool[32]
    bToggleSlot[0] = true
    bToggleSlot[1] = true
    bToggleSlot[2] = true
    bToggleSlot[3] = true
    bToggleSlot[4] = true
    bToggleSlot[5] = true
    bToggleSlot[6] = true
    bToggleSlot[7] = true
EndEvent

;ページの設定
Event OnPageReset(string page)
   SetCursorFillMode(TOP_TO_BOTTOM)
   AddHeaderOption("モード設定")
   ToggleIndoorID = AddToggleOption("屋内のみ", bToggleIndoor)
   ToggleScaleID = AddToggleOption("身長の相違", bToggleScale)
   ToggleWeightID = AddToggleOption("体重の相違", bToggleWeight)
   SliderDebugID = AddSliderOption("ルート不可時メッセージ表示", fSliderDebug, "{0}")
   SetCursorPosition(1)
   AddHeaderOption("対象とする装備スロット")
   ToggleSlotID[0] = AddToggleOption("head", bToggleSlot[0])
   ToggleSlotID[1] = AddToggleOption("hair", bToggleSlot[1])
   ToggleSlotID[2] = AddToggleOption("body", bToggleSlot[2])
   ToggleSlotID[3] = AddToggleOption("hands", bToggleSlot[3])
   ToggleSlotID[4] = AddToggleOption("forearms", bToggleSlot[4])
   ToggleSlotID[5] = AddToggleOption("feet", bToggleSlot[5])
   ToggleSlotID[6] = AddToggleOption("calves", bToggleSlot[6])
   ToggleSlotID[7] = AddToggleOption("circlet", bToggleSlot[7])
   
endEvent

int function GetVersion()
	return 1
endFunction

;選択時の設定
Event OnOptionSelect(int option)
   if (option == ToggleIndoorID)
       bToggleIndoor = !bToggleIndoor
       SetToggleOptionValue(ToggleIndoorID, bToggleIndoor)
       If(bToggleIndoor)
         INYAIndoorOnlyMode.SetValue(1)
       Else
         INYAIndoorOnlyMode.SetValue(0)
       EndIf
   elseif (option == ToggleScaleID)
       bToggleScale = !bToggleScale
       SetToggleOptionValue(ToggleScaleID, bToggleScale)
       If(bToggleScale)
         INYAScaleMode.SetValue(1)
       Else
         INYAScaleMode.SetValue(0)
       EndIf
   elseif (option == ToggleWeightID)
       bToggleWeight = !bToggleWeight
       SetToggleOptionValue(ToggleWeightID, bToggleWeight)
       If(bToggleWeight)
         INYAWeightMode.SetValue(1)
       Else
         INYAWeightMode.SetValue(0)
       EndIf
   else
       int iLoop = 0
       int iSlot = INYASlotMask.GetValueInt()
       SlotValue[0] = 0x00000001 ;head
       SlotValue[1] = 0x00000002 ;hair
       SlotValue[2] = 0x00000004 ;body
       SlotValue[3] = 0x00000008 ;hands
       SlotValue[4] = 0x00000010 ;forearms
       SlotValue[5] = 0x00000080 ;feet
       SlotValue[6] = 0x00000100 ;calves
       SlotValue[7] = 0x00001000 ;circlet
       while(iLoop < ToggleSlotID.Length)
           if ( option == ToggleSlotID[iLoop])
               bToggleSlot[iLoop] = !bToggleSlot[iLoop]
               SetToggleOptionValue(ToggleSlotID[iLoop], bToggleSlot[iLoop])
               if (!bToggleSlot[iLoop])
                   iSlot -= SlotValue[iLoop]
               else
                   iSlot += SlotValue[iLoop]
               endif
               INYASlotMask.SetValueInt(iSlot)
           endif
           iLoop += 1
       endWhile
   endIf
endEvent

;スライダー開いた時のイベント・設定
Event OnOptionSliderOpen(int option)
   if (option == SliderDebugID)
       SetSliderDialogStartValue(fSliderDebug)
       SetSliderDialogDefaultValue(1)
       SetSliderDialogRange(0, 2)
       SetSliderDialogInterval(1)
   endIf
EndEvent

Event OnOptionSliderAccept(int option, float value)
   if (option == SliderDebugID)
       fSliderDebug = value
       SetSliderOptionValue(SliderDebugID, fSliderDebug, "{0}")
       INYADebugMode.SetValue(fSliderDebug)
   endIf
EndEvent

;デフォルトの設定(Fキー押した時に呼び出されるイベント)
Event OnOptionDefault(int option)
  If(option == ToggleIndoorID)
      if (!bToggleIndoor)
          bToggleIndoor = true
          SetToggleOptionValue(ToggleIndoorID, bToggleIndoor)
          INYAIndoorOnlyMode.SetValue(1)
      endif
  Elseif(option == ToggleScaleID)
      if (!bToggleScale)
          bToggleScale = true
          SetToggleOptionValue(ToggleScaleID, bToggleScale)
          INYAScaleMode.SetValue(1)
      endif
  Elseif(option == ToggleWeightID)
      if (!bToggleWeight)
          bToggleWeight = true
          SetToggleOptionValue(ToggleWeightID, bToggleWeight)
          INYAWeightMode.SetValue(1)
      endif
  Elseif(option == SliderDebugID)
      fSliderDebug = 1.0
      SetSliderOptionValue(SliderDebugID, fSliderDebug, "{0}")
      INYADebugMode.SetValue(fSliderDebug)
  EndIf
EndEvent

;カーソルが乗った時に下に出るテキストの設定
Event OnOptionHighlight(int option)
  If(option == ToggleIndoorID)
       SetInfoText("有効の場合、野外でのルートに制限が掛かりません")
  Elseif(option == ToggleScaleID)
       SetInfoText("有効の場合、身長差がある死体からルートできなくなります")
  Elseif(option == ToggleWeightID)
       SetInfoText("有効の場合、重量(weight)がプレイヤーと一致しないとルートできません")
  Elseif(option == SliderDebugID)
       SetInfoText("0:無効 1:左上に表示 2:papyrusログに出力")
  EndIf
EndEvent