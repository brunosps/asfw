#INCLUDE "Totvs.ch"

User Function AsLib013(cSerie, cNota, cDirDest)
	Local aArea := GetArea()
	Local aDeleta  := {}
	Local cURL   := GetMv("MV_SPEDURL",,"http://")
	Local dDataDe   := CtoD("01/01/07")
	Local dDataAte  := CtoD("31/12/39")
	Local cCnpjDIni := Space(14)
	Local cCnpjDFim := Replicate("Z", 14)
	Local nX        := 0
	Local cDrive    := ""
    Local cDestino  := ""
	Local cNFes     := ""
    Local cIdEnt    := u_AsGetIdEnt()

	MakeDir(cDirDest)

	SplitPath(cDirDest,@cDrive,@cDestino,"","")
	cDestino := cDrive+cDestino

	oWS:= WSNFeSBRA():New()
	oWS:cUSERTOKEN        := "TOTVS"
	oWS:cID_ENT           := cIdEnt
	oWS:_URL              := AllTrim(cURL)+"/NFeSBRA.apw"
	oWS:cIdInicial        := cSerie+cNota
	oWS:cIdFinal          := cSerie+cNota
	oWS:dDataDe           := dDataDe
	oWS:dDataAte          := dDataAte
	oWS:cCNPJDESTInicial  := cCnpjDIni
	oWS:cCNPJDESTFinal    := cCnpjDFim
	oWS:nDiasparaExclusao := 0

	lOk:= oWS:RETORNAFX()
	oRetorno := oWS:oWsRetornaFxResult

	If lOk
		
		For nX := 1 To Len(oRetorno:OWSNOTAS:OWSNFES3)
			//Ponto de Entrada para permitir filtrar as NF
			If ExistBlock("SPDNFE01")
				If !ExecBlock("SPDNFE01",.f.,.f.,{oRetorno:OWSNOTAS:OWSNFES3[nX]})
					loop
				Endif
			Endif
			oXml    := oRetorno:OWSNOTAS:OWSNFES3[nX]
			oXmlExp := XmlParser(oRetorno:OWSNOTAS:OWSNFES3[nX]:OWSNFE:CXML,"","","")
			cXML	:= ""
			If Type("oXmlExp:_NFE:_INFNFE:_DEST:_CNPJ")<>"U"
				cCNPJDEST := AllTrim(oXmlExp:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
			ElseIF Type("oXmlExp:_NFE:_INFNFE:_DEST:_CPF")<>"U"
				cCNPJDEST := AllTrim(oXmlExp:_NFE:_INFNFE:_DEST:_CPF:TEXT)
			Else
				cCNPJDEST := ""
			EndIf
			
			cVerNfe := IIf(Type("oXmlExp:_NFE:_INFNFE:_VERSAO:TEXT") <> "U", oXmlExp:_NFE:_INFNFE:_VERSAO:TEXT, '')
			
			If !Empty(oXml:oWSNFe:cProtocolo)
				cNota := oXml:cID
				cIdflush := cNota
				cNFes    := cNFes+cNota+CRLF
				cChvNFe  := NfeIdSPED(oXml:oWSNFe:cXML,"Id")
				cChave     := cChvNFe
				cProtocolo := oXml:oWSNFe:cProtocolo
				cModelo   := cChvNFe
				cModelo   := StrTran(cModelo,"NFe","")
				cModelo   := SubStr(cModelo,21,02)
				cAmbiente := cValtoChar(oXmlExp:_Nfe:_InfNfe:_Ide:_TpAmb:Text)
				
				cPrefixo := "NFe"

				nHandle := FCreate(cDestino + SubStr(cChvNFe,4,44) + "-" + cPrefixo + ".xml")

				If nHandle > 0
					
					cCab1 := '<?xml version="1.0" encoding="UTF-8"?>'
					If cModelo == "57"
						cCab1  += '<cteProc xmlns="http://www.portalfiscal.inf.br/cte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.portalfiscal.inf.br/cte procCTe_v'+cVerCte+'.xsd" versao="'+cVerCte+'">'
						cRodap := '</cteProc>'
					Else
						Do Case
							Case cVerNfe <= "1.07"
								cCab1 += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.portalfiscal.inf.br/nfe procNFe_v1.00.xsd" versao="1.00">'
							Case cVerNfe >= "2.00" .And. "cancNFe" $ oXml:oWSNFe:cXML
								cCab1 += '<procCancNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">'
							OtherWise
								cCab1 += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">'
						EndCase
						cRodap := '</nfeProc>'
					EndIf
					FWrite(nHandle,AllTrim(cCab1))
					FWrite(nHandle,AllTrim(oXml:oWSNFe:cXML))
					FWrite(nHandle,AllTrim(oXml:oWSNFe:cXMLPROT))
					FWrite(nHandle,AllTrim(cRodap))
					FClose(nHandle)
					aadd(aDeleta,oXml:cID)
					cXML := AllTrim(cCab1)+AllTrim(oXml:oWSNFe:cXML)+AllTrim(cRodap)
					If !Empty(cXML)
						If ExistBlock("FISEXPNFE")
							ExecBlock("FISEXPNFE",.f.,.f.,{cXML})
						Endif
					EndIF
					
				EndIf
			EndIf
		Next nX
	Else
		ConOut("ERRO: " + IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
	EndIf
	oWs := Nil
	oXml := Nil
	RestArea(aArea)
Return( (cDestino + SubStr(cChvNFe,4,44) + "-" + cPrefixo + ".xml") )

// Static Function GetIdEnt( cError )

// 	Local aArea  		:= GetArea()

// 	Local cIdEnt 		:= ""
// 	Local cURL   		:= PadR(GetNewPar("MV_SPEDURL","http://"),250)

// 	Local lMethodOk		:= .F.

// 	Local oWsSPEDAdm

// 	BEGIN SEQUENCE

// 		IF !( CTIsReady(cURL) )
// 			BREAK
// 		EndIF

// 		cURL	:= AllTrim(cURL)+"/SPEDADM.apw"

// 		IF !( CTIsReady(cURL) )
// 			BREAK
// 		EndIF

// 		oWsSPEDAdm										:= WsSPEDAdm():New()
// 		oWsSPEDAdm:cUSERTOKEN 							:= "TOTVS"
// 		oWsSPEDAdm:oWsEmpresa:cCNPJ       				:= SM0->( IF(M0_TPINSC==2 .Or. Empty(M0_TPINSC),M0_CGC,"")	 )
// 		oWsSPEDAdm:oWsEmpresa:cCPF        				:= SM0->( IF(M0_TPINSC==3,M0_CGC,"") )
// 		oWsSPEDAdm:oWsEmpresa:cIE         				:= SM0->M0_INSC
// 		oWsSPEDAdm:oWsEmpresa:cIM         				:= SM0->M0_INSCM
// 		oWsSPEDAdm:oWsEmpresa:cNOME       				:= SM0->M0_NOMECOM
// 		oWsSPEDAdm:oWsEmpresa:cFANTASIA   				:= SM0->M0_NOME
// 		oWsSPEDAdm:oWsEmpresa:cENDERECO   				:= FisGetEnd(SM0->M0_ENDENT)[1]
// 		oWsSPEDAdm:oWsEmpresa:cNUM        				:= FisGetEnd(SM0->M0_ENDENT)[3]
// 		oWsSPEDAdm:oWsEmpresa:cCOMPL      				:= FisGetEnd(SM0->M0_ENDENT)[4]
// 		oWsSPEDAdm:oWsEmpresa:cUF         				:= SM0->M0_ESTENT
// 		oWsSPEDAdm:oWsEmpresa:cCEP        				:= SM0->M0_CEPENT
// 		oWsSPEDAdm:oWsEmpresa:cCOD_MUN    				:= SM0->M0_CODMUN
// 		oWsSPEDAdm:oWsEmpresa:cCOD_PAIS   				:= "1058"
// 		oWsSPEDAdm:oWsEmpresa:cBAIRRO     				:= SM0->M0_BAIRENT
// 		oWsSPEDAdm:oWsEmpresa:cMUN        				:= SM0->M0_CIDENT
// 		oWsSPEDAdm:oWsEmpresa:cCEP_CP     				:= NIL
// 		oWsSPEDAdm:oWsEmpresa:cCP         				:= NIL
// 		oWsSPEDAdm:oWsEmpresa:cDDD        				:= Str(FisGetTel(SM0->M0_TEL)[2],3)
// 		oWsSPEDAdm:oWsEmpresa:cFONE       				:= AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
// 		oWsSPEDAdm:oWsEmpresa:cFAX        				:= AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
// 		oWsSPEDAdm:oWsEmpresa:cEMAIL      				:= UsrRetMail(RetCodUsr())
// 		oWsSPEDAdm:oWsEmpresa:cNIRE       				:= SM0->M0_NIRE
// 		oWsSPEDAdm:oWsEmpresa:dDTRE       				:= SM0->M0_DTRE
// 		oWsSPEDAdm:oWsEmpresa:cNIT        				:= SM0->( IF(M0_TPINSC==1,M0_CGC,"") )
// 		oWsSPEDAdm:oWsEmpresa:cINDSITESP  				:= ""
// 		oWsSPEDAdm:oWsEmpresa:cID_MATRIZ  				:= ""
// 		oWsSPEDAdm:oWsOutrasInscricoes:oWsInscricao		:= SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
// 		oWsSPEDAdm:_URL									:= cURL
// 		lMethodOk                                       := oWsSPEDAdm:AdmEmpresas()

// 		DEFAULT lMethodOk := .F.
// 		IF !( lMethodOk )
// 			cError := IF( Empty( GetWscError(3) ) , GetWscError(1) , GetWscError(3) )
// 			BREAK
// 		EndIF

// 		cIdEnt  := oWsSPEDAdm:cAdmEmpresasResult

// 	END SEQUENCE

// 	RestArea(aArea)

// Return( cIdEnt )
