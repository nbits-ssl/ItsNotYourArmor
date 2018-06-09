Scriptname INYAInit extends Quest  

Event OnInit()
	if (!ItsNotYourArmor.IsRunning())
		ItsNotYourArmor.Start()
	endif
	self.Stop()
EndEvent 

Quest Property ItsNotYourArmor  Auto  
