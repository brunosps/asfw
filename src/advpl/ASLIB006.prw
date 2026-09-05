	
#INCLUDE "TOTVS.CH"
#INCLUDE "TRYEXCEPTION.CH"
#INCLUDE "TOPCONN.CH"

User Function AsMarkBrw()
	Local oNewMark := AsMarkBrw():New("SC9", "Pedidos SC9")
	
	oNewMark:SetFieldMark( "C9_OK" )  
	
	oNewMark:Activate()
Return(Nil)

Class AsMarkBrw From AsBrowse

	Method New(cAlias, cDescription) Constructor
	
	Method SetFieldMark( cCampo )
	Method SetbVldMark(bValid)
	Method SetAfterMark(bAfterMark)
	
	Method SetbBackColor(bColor)
	Method Refresh()

	Method IsMark(cMark)
	Method Mark(cMark)
	Method MarkRec(lExecAfter)
	Method GoTo(nReg)
	Method CanMark(cMark)
	
	Method GetMarkReg()
	Method ResetMark()
	Method AddFilter(cFilter,  cExpAdvPL,  lNoCheck,  lSelected,  cAlias,  lFilterAsk,  aFilParser,  cID)
EndClass

Method AddFilter(cFilter,  cExpAdvPL,  lNoCheck,  lSelected,  cAlias,  lFilterAsk,  aFilParser,  cID) Class AsMarkBrw
	self:oBrowse:oBrowse:AddFilter(cFilter,  cExpAdvPL,  lNoCheck,  lSelected,  cAlias,  lFilterAsk,  aFilParser,  cID)
Return(Nil)

Method ResetMark() Class AsMarkBrw
	Local lRet := .T.
	Local aMarkReg := self:GetMarkReg()
	Local nI := 1 
	Local cAlias := self:oBrowse:oBrowse:Alias()
	Local nTMark := TamSx3(self:oBrowse:cFieldMark)[1]
		
	DbSelectArea(cAlias)
		
	For nI := 1 To Len(aMarkReg)
		(cAlias)->( DbGoTo(aMarkReg[nI]) )
				
		RecLock(cAlias, .F.)
			(cAlias)->( &(self:oBrowse:cFieldMark) ) := Space(nTMark)
		(cAlias)->(MsUnLock())
	Next
	
	self:Refresh()	
Return(lRet)

Method GetMarkReg() Class AsMarkBrw
	Local aArea := GetArea()
	Local cSql := ""
	Local cAlias := self:oBrowse:oBrowse:Alias()
	Local cPrefix := PrefixoCpo(cAlias)
	Local aRet := {}
		
	cSql += " SELECT R_E_C_N_O_ REG "
	cSql += "   FROM " + RetSqlName(cAlias)
	cSql += "  WHERE " + cPrefix + "_FILIAL = '" + xFilial(cAlias) + "' AND D_E_L_E_T_ <> '*' "
	cSql += "    AND " + self:oBrowse:cFieldMark + " = '" + self:Mark() + "' "
	
	TcQuery cSql New Alias 'AsMarkBrw'
	
	While AsMarkBrw->(!Eof())
		aAdd(aRet, AsMarkBrw->REG)
				
		AsMarkBrw->(DbSkip())
	EndDo
	
	AsMarkBrw->(DbCloseArea())
		
	RestArea(aArea)
Return(aRet)

Method CanMark(cMark) Class AsMarkBrw
Return(Self:oBrowse:CanMark(cMark))	

Method GoTo(nReg) Class AsMarkBrw
Return(self:oBrowse:oBrowse:GoTo(nReg))

Method IsMark(cMark) Class AsMarkBrw
Return(self:oBrowse:IsMark(cMark))

Method Mark(cMark) Class AsMarkBrw
Return(self:oBrowse:Mark(cMark))

Method MarkRec(lExecAfter) Class AsMarkBrw  
	Local bBkpAfter := self:oBrowse:bAfterMark
	Local xRet := Nil
	
	Default lExecAfter := .T.
	
	If !lExecAfter
		self:oBrowse:bAfterMark	:= { || .T. } 
	EndIf
	
	xRet := self:oBrowse:MarkRec()
	
	If !lExecAfter
		self:oBrowse:bAfterMark	:= bBkpAfter
	EndIf	
Return(xRet)

Method Refresh() Class AsMarkBrw
	self:oBrowse:Refresh()
Return(self)

Method New(cAlias, cDescription) Class AsMarkBrw
	
	Default cDescription := ""
	
	_Super:New(cAlias, cDescription)
	 
	self:oBrowse := FWMarkBrowse():New()
	self:oBrowse:oBrowse:oData := FWBrwTable():New()//UBrwTable():New()
	self:oBrowse:SetAlias( cAlias )	
	//self:oBrowse:SetDescription( cDescription )
	self:oBrowse:DisableDetails()
	self:lMark := .T.
			
Return( self )

Method SetFieldMark( cCampo ) Class AsMarkBrw
	self:oBrowse:SetFieldMark( cCampo )
Return( Self )

Method SetbVldMark(bValid) Class AsMarkBrw
	self:oBrowse:SetValid(bValid)
Return( Self )

Method SetAfterMark(bAfterMark) Class AsMarkBrw
	self:oBrowse:SetAfterMark(bAfterMark)
Return( Self )

Method SetbBackColor(bColor) Class AsMarkBrw
	self:oBrowse:oBrowse:SetBlkBackColor(bColor)
Return( Self )
