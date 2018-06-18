Scriptname INYAMCMScript extends  ski_configbase
GlobalVariable Property INYAIndoorOnlyMode auto
GlobalVariable Property INYAScaleMode auto
GlobalVariable Property INYAWeightMode auto
GlobalVariable Property INYADebugMode auto
GlobalVariable Property INYASlotMask auto
;�ϐ��̒�`
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

; ������
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

;�y�[�W�̐ݒ�
Event OnPageReset(string page)
   SetCursorFillMode(TOP_TO_BOTTOM)
   AddHeaderOption("���[�h�ݒ�")
   ToggleIndoorID = AddToggleOption("�����̂�", bToggleIndoor)
   ToggleScaleID = AddToggleOption("�g���̑���", bToggleScale)
   ToggleWeightID = AddToggleOption("�̏d�̑���", bToggleWeight)
   SliderDebugID = AddSliderOption("���[�g�s�����b�Z�[�W�\��", fSliderDebug, "{0}")
   SetCursorPosition(1)
   AddHeaderOption("�ΏۂƂ��鑕���X���b�g")
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

;�I�����̐ݒ�
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

;�X���C�_�[�J�������̃C�x���g�E�ݒ�
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

;�f�t�H���g�̐ݒ�(F�L�[���������ɌĂяo�����C�x���g)
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

;�J�[�\������������ɉ��ɏo��e�L�X�g�̐ݒ�
Event OnOptionHighlight(int option)
  If(option == ToggleIndoorID)
       SetInfoText("�L���̏ꍇ�A��O�ł̃��[�g�ɐ������|����܂���")
  Elseif(option == ToggleScaleID)
       SetInfoText("�L���̏ꍇ�A�g���������鎀�̂��烋�[�g�ł��Ȃ��Ȃ�܂�")
  Elseif(option == ToggleWeightID)
       SetInfoText("�L���̏ꍇ�A�d��(weight)���v���C���[�ƈ�v���Ȃ��ƃ��[�g�ł��܂���")
  Elseif(option == SliderDebugID)
       SetInfoText("0:���� 1:����ɕ\�� 2:papyrus���O�ɏo��")
  EndIf
EndEvent