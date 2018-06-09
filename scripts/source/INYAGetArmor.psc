Scriptname INYAGetArmor extends ReferenceAlias  

Event OnItemAdded(Form akBaseItem, Int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer) 
	if (INYAIndoorOnlyMode.GetValue() == 1 && !akSourceContainer.IsInInterior())
		return
	endif
	
	Actor act = akSourceContainer as Actor
	
	if (act && act.IsDead())
		Armor amr = akBaseItem as Armor
		if (amr && amr.HasKeyWord(ArmorCuirass) || amr.HasKeyWord(ClothingBody))
			Actor selfact = self.GetActorRef()
			ActorBase selfbase = selfact.GetActorBase()
			ActorBase srcbase = act.GetActorBase()
			
			if (selfbase.GetSex() != srcbase.GetSex())
				self.returnitem(selfact, akBaseItem, akSourceContainer)
				self.log("It's not fit for you : Gender")
			elseif (INYAWeightMode.GetValue() == 1)
				float selfweight = selfbase.GetWeight()
				float srcweight = srcbase.GetWeight()
				if (selfweight != srcweight)
					self.returnitem(selfact, akBaseItem, akSourceContainer)
					self.log("It's not fit for you : Weight : " + selfweight as int + " and " + srcweight as int)
				endif
			elseif (INYAScaleMode.GetValue() == 1)
				float selfheight = selfbase.GetHeight() * self.GetRef().GetScale()
				float srcheight = srcbase.GetHeight() * akSourceContainer.GetScale()
				if (selfheight != srcheight)
					self.returnitem(selfact, akBaseItem, akSourceContainer)
					self.log("It's not fit for you : Height : " + selfheight as int + " and " + srcheight as int)
				endif
			endif
		endif
	endif
EndEvent

Function returnItem(Actor selfact, Form akBaseItem, ObjectReference akSourceContainer)
	selfact.RemoveItem(akBaseItem, 1, true, akSourceContainer)
EndFunction

Function log(String msg)
	float debugmode = INYADebugMode.GetValue()
	if (debugmode == 0)
		; nope
	elseif (debugmode == 1)
		debug.notification("[INYA] " + msg)
	elseif (debugmode == 2)
		debug.trace("[INYA] " + msg)
	endif
EndFunction

GlobalVariable Property INYAIndoorOnlyMode  Auto  
GlobalVariable Property INYAScaleMode  Auto  
GlobalVariable Property INYAWeightMode  Auto  
GlobalVariable Property INYADebugMode  Auto  
Keyword Property ArmorCuirass  Auto  
Keyword Property ClothingBody  Auto  

