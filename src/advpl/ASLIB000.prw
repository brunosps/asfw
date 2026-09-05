
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
	000 - ASHASH
	001 - ASCUSTOMTABLE
	002 - AsCustomView		
*/

User Function ASLIB000()

Return(Nil)

class ASHASH From LongClassName
	data aKeys
	data aValues

	method new(cHash, cChar) constructor
	method load(aMaps) constructor
	method puts(aMaps)
	method put(cKey, oValue)
	method getIndex(nIndex)
	method getObj(cKey)
	method getStr(cKey)
	method getNum(cKey)
	method exists(cKeys)
	method addUnless(cKey, oValue)
	method getIndexOf(cKey)

	method initialize()

	method varialize()

	method rmIndex(nIndex)
	method rmObj(cKey)

	method substract(oHComp)
	method getKeys()
	method getIndKey(nIndex)
	method join(cChar, cPrefix, cSufix)
	method joinKeys(cChar, cPrefix, cSufix)
	method isEmpty()
	method getValues()
	method getEntry()
	method to_s()
	method getSize()

	Method ToJson(nNivel, lStr) 
endclass

method getEntry() class ASHASH
	Local aRet := {}
	Local nFor := 0

	For nFor := 1 To Len(::aValues)
		aAdd(aRet, {::aKeys[nFor], ::aValues[nFor]})
	Next

return(aRet)

method to_s(cChar) class ASHASH
	Local oRet := ASHASH():New()
	Local nI := ""

	Default cChar := ";"

	For nI := 1 To Len(self:aKeys)
		oRet:put(nI, ConvType(self:aKeys[nI]) + "||" + ConvType(self:aValues[nI])+"||"+ValType(self:aValues[nI]))
	Next
return(oRet:join(cChar))

Static Function ConvType(xValor,nTam,nDec)

	Local cNovo := ""
	DEFAULT nDec := 0
	Do Case
		Case ValType(xValor)=="N"
			If xValor <> 0
				cNovo := AllTrim(Str(xValor,nTam,nDec))
			Else
				cNovo := "0"
			EndIf
		Case ValType(xValor)=="D"
			cNovo := FsDateConv(xValor,"YYYYMMDD")
			cNovo := SubStr(cNovo,1,4)+"-"+SubStr(cNovo,5,2)+"-"+SubStr(cNovo,7)
		Case ValType(xValor)=="C"
			If nTam==Nil
				xValor := AllTrim(xValor)
			EndIf
			DEFAULT nTam := 60
			cNovo := AllTrim(EnCodeUtf8(NoAcento(SubStr(xValor,1,nTam))))
	EndCase
Return(cNovo)

method getValues() class ASHASH
return(::aValues)

method isEmpty()	class ASHASH
return(Empty(::getKeys()))

method join(cChar, cPrefix, cSufix) class ASHASH
	Local cRet := ""
	Local nI := 0

	Default cChar   := ""
	Default cPrefix := ""
	Default cSufix  := ""

	For nI := 1 To Len(::aValues)
		cRet += IIF(nI == 1,"",cChar) + cPrefix + ::aValues[nI] + cSufix
	Next

return(cRet)

method joinKeys(cChar, cPrefix, cSufix) class ASHASH
	Local cRet := ""
	Local nI := 0

	Default cChar   := ""
	Default cPrefix := ""
	Default cSufix  := ""

	For nI := 1 To Len(::aKeys)
		cRet += IIF(Empty(cRet),"",cChar) + cPrefix + ::aKeys[nI] + cSufix
	Next

return(cRet)

method getIndKey(nIndex) class ASHASH
	If nIndex <> nil .And. nIndex > 0
		Return(::aKeys[nIndex])
	EndIf
return(Nil)

method getKeys() class ASHASH
return(::aKeys)

method substract(oHComp) class ASHASH
	Local nI := 1

	For nI := 1 To Len(oHComp:getKeys())
		If ::getIndexOf(oHComp:getIndKey(nI)) > 0
			::rmObj(oHComp:getIndKey(nI))
		EndIf
	Next

Return(self)

method New(cHash, cChar) class ASHASH
	Local cAux := "", cKey := "", cValue
	Local nPos := 0

	Default cHash := ""
	Default cChar := ";"

	self:aKeys := {}
	self:aValues := {}

	If !Empty(cHash)

		While (nPos := aT(cChar, cHash)) > 0
			cAux := SubStr(cHash, 1, nPos - 1)

			cKey := SubStr(cAux, 1, At("||", cAux) - 1)
			cAux := SubStr(cAux,  At("||", cAux) + 2)
			cValue := SubStr(cAux, 1, At("||", cAux) - 1)
			cAux := SubStr(cAux,  At("||", cAux) + 2)
			If AllTrim(cAux) <> "C"
				If AllTrim(cAux) == "N"
					cValue := Val(cValue)
				ElseIf AllTrim(cAux) == "D"
					cValue := StoD(cValue)
				EndIf
			EndIf

			self:put(cKey, cValue)

			cHash := SubStr(cHash,nPos + 1)
		EndDo

		cAux := AllTrim(cHash)

		cKey := SubStr(cAux, 1, At("||", cAux) - 1)
		cAux := SubStr(cAux,  At("||", cAux) + 2)
		cValue := SubStr(cAux, 1, At("||", cAux) - 1)
		cAux := SubStr(cAux,  At("||", cAux) + 2)
		If AllTrim(cAux) <> "C"
			If AllTrim(cAux) == "N"
				cValue := Val(cValue)
			ElseIf AllTrim(cAux) == "D"
				cValue := StoD(cValue)
			EndIf
		EndIf

		self:put(cKey, cValue)

	EndIf

return(self)

method Load(aMaps) class ASHASH
	::aKeys	:= {}
	::aValues := {}
	::puts(aMaps)
return(self)

method puts(aMaps) class ASHASH
	Local nI := 1
	::aKeys	:= {}
	::aValues := {}

	For nI := 1 To Len(aMaps)
		::put(aMaps[nI, 1],aMaps[nI, 2])
	Next

Return(Len(::aKeys))

method put(cKey, oValue) class ASHASH
	Local nIndex := ::GetIndexOf(cKey)
	If nIndex == 0
		aAdd(::aKeys  , cKey)
		aAdd(::aValues, oValue)
		nIndex := Len(::aKeys)
	Else
		::aValues[nIndex] := oValue
	EndIf
Return(nIndex)

method addUnless(cKey, oValue) class ASHASH
	Local lRet := .F.

	If lRet := (::GetIndexOf(cKey) == 0)
		aAdd(::aKeys  , cKey)
		aAdd(::aValues, oValue)
	EndIF

Return(lRet)

method getIndex(nIndex) class ASHASH
	If nIndex <> nil .And. nIndex > 0
		Return(::aValues[nIndex])
	EndIf
Return(Nil)

method getObj(cKey) 	class ASHASH
Return(::getIndex( ::getIndexOf(cKey) )  )

method getStr(cKey) 	class ASHASH
	Local uObj := ::getIndex( ::getIndexOf(cKey) )

	If valType(uObj) <> 'C'
		If      valType(uObj) == 'N'
			uObj := AllTrim(uObj)
		ElseIf  valType(uObj) == 'D'
			uObj := DtoS(uObj)
		EndIf
	EndIf

Return(uObj)

method getNum(cKey) class ASHASH
	Local uObj := ::getIndex( ::getIndexOf(cKey) )

	If valType(uObj) <> 'N'
		If      valType(uObj) == 'C'
			uObj := Val(uObj)
		EndIf
	EndIf

Return(uObj)

method rmIndex(nIndex)	class ASHASH
	If nIndex <> 0
		aDel(::aKeys, nIndex)
		aSize(::aKeys, Len(::aKeys) - 1)

		aDel(::aValues, nIndex)
		aSize(::aValues, Len(::aValues) - 1)
	EndIf
Return(nIndex)

method rmObj(cKey) class ASHASH
	::rmIndex( ::getIndexOf(cKey) )
Return(cKey)

method getIndexOf(cKey) class ASHASH
Return(aScan(::aKeys, { |aVet| aVet == cKey }))

method getSize() class ASHASH
return(Len(::aKeys))

method varialize() class ASHASH
	Local nI := 0

	For nI := 1 To Len(::aKeys)
//		ConOut("H_"+::aKeys[nI])

		_SetOwnerPrvt("H_"+::aKeys[nI], ::aValues[nI])
	Next

Return(.T.)

method exists(cKeys) class ASHASH
	Local aRet := {}
	Local nI   := {}

	aKeys := SepCampos(cKeys + IIF(Substr(cKeys, Len(cKeys), 1) == "/","","/"))

	For nI := 1 To Len(aKeys)
		If ::getIndexOf(aKeys[nI]) == 0
			aAdd(aRet, aKeys[nI])
		EndIF
	Next
Return(aRet)

method initialize() class ASHASH
	self:aKeys := {}
	self:aValues := {}
return

Method ToJson(nNivel, lStr) class ASHASH
    Local oRet   := ASHASH():New()
    Local cRet   := ""
    Local aKeys  := self:getKeys()
    Local nI     := 1
    Local xValue := Nil
    Local nX     := 1
    Local aAux   :=  {}
    Local nAux   :=  0 
    Local cAux   := ""

    Default nNivel := 0
    Default lStr := .T.

    For nI := 1 to Len(aKeys)
        xValue := self:getIndex(nI)

        cRet += IIF(nI == 1, "", ", ")

        If ValType(xValue) == "O"
            cRet += '"' + aKeys[nI] + '": ' + xValue:ToJson(nNivel + 1)
        Else
            If ValType(xValue) == "A"
				aAux := {}
                For nX := 1 To Len(xValue)
                    If ValType(xValue[nX]) == "O"
                        aAdd(aAux, {xValue[nX]:ToJson(nNivel + 1), .F.})
                    Else
                        If ValType(xValue[nX]) == "N"
                            xValue[nX] := AllTrim(Str(xValue[nX]))
                        EndIf

                        aAdd(aAux, {xValue[nX], .T.})
                    EndIf
                Next

                cAux := "["  
                For nAux := 1 To Len(aAux)					
                    cAux += IIF(nAux == 1, "", ",")
                    cAux += IIF(aAux[nAux, 2], '"', "") + aAux[nAux, 1] + IIF(aAux[nAux, 2], '"', "")
                Next
                cAux += "]"
                cRet += '"' + aKeys[nI] + '": ' + cAux
            Else
				If ValType(xValue) == "N"
					xValue := AllTrim(Str(xValue))
				EndIf

                cRet += '"' + aKeys[nI] + '": "' + xValue + '"'
            EndIf
        EndIf
    Next
    cRet := "{" + cRet + "}"
Return(IIF(nNivel==0 .And. !lStr, ConvObj(cRet), cRet))

Static Function ConvObj(cJson)
    Local oJson := Nil

	If ValType( cJson ) <> "C"
		cJson := ""
	EndIf

	cRet := Upper(FwNoAccent(cJson))

    If !FWJsonDeserialize(cJson, @oJson)
		oJson := Nil
	EndIf

Return(oJson)

Static Function SepCampos(cLinha,cSep1)

	Local nPos, aDadosLin := {}

	Default cSep1 := "/"

	cLinha := alltrim(cLinha)

	while len(alltrim(cLinha)) <> 0
		nPos := at(cSep1,cLinha)  // Posicao do separador1
		if nPos<>0  // Nao e´ ultimo campo
			aadd(aDadosLin,alltrim(substr(cLinha,1,nPos-1)))
		else // ultimo campo
			aadd(aDadosLin,alltrim(cLinha))
			exit
		endIf
		cLinha := substr(cLinha,nPos+1,len(cLinha)-nPos)
	end
Return(aDadosLin)