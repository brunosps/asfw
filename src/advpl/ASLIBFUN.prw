
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

Static cBlankFil := Space(FWGETTAMFILIAL)
Static cSX2Emp   := SM0->M0_CODIGO 
Static cSX3Emp   := SM0->M0_CODIGO 

Static Function RetTable(cAlias, __cEmp)
	Local cTable := ""

	Default __cEmp := SM0->M0_CODIGO

	If cSX2Emp <> __cEmp .Or. Select("___SX2") == 0
		If Select("___SX2") <> 0
			___SX2->(DbCloseArea())
		EndIf

		DbUseArea(.T., , "sx2" + __cEmp + "0" + GetDBExtension(), "___SX2", .T., .F.)
		___SX2->(dbSetIndex("sx2" + __cEmp + "0" + ".cdx"))

		cSX2Emp := __cEmp
	EndIf

	If ___SX2->X2_CHAVE <> cAlias .And. ___SX2->(!DbSeek(cAlias))
		UserException("Alias ["+cAlias+"] não encontrado no arquivo sx2" + __cEmp + GetDBExtension())
	EndIf

	cTable := ___SX2->X2_ARQUIVO

Return(cTable)

Static Function RetFilial(cAlias, __cFil)
	Local cRet := ""
	cRet := cAlias + "." + PrefixoCpo(SubStr(cAlias, 1, 3)) + "_FILIAL"
	cRet := cRet + " = '" + cBlankFil + "' OR " + cRet + " = '" + __cFil + "' "
Return("("+cRet+") AND " + cAlias + ".D_E_L_E_T_  <> '*' ")

Static Function RetEmpresa(cEmpDe, cEmpAte, cFilialDe, cFilialAte)
	Local nRecSm0     := SM0->(RECNO())
	Local aVet        := {}
	Local cEmpExc     := GetMv('ASCTB00201', , '03/01;04/01;05/01;05/02;06/01;07/01;')

	DbSelectArea("SM0")
	SM0->(DbGoTop())

	While SM0->(!Eof())
		If (!SM0->(M0_CODIGO + "/" + M0_CODFIL) $ cEmpExc) .And. ;
			SM0->M0_CODIGO >= cEmpDe .And. SM0->M0_CODIGO <= cEmpAte .And. ;
			SM0->M0_CODFIL >= cFilialDe .And. SM0->M0_CODFIL <= cFilialAte
			aAdd(aVet, {SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->(AllTrim(M0_FILIAL) + " - " + AllTrim(M0_NOME))})
		EndIf
		SM0->(DbSkip())
	EndDo

    SM0->(DbGoTo(nRecSm0))
Return(aVet)

User Function AsExec()

	Local   oGet := Nil, oDlg1 := Nil, oBtBusca := Nil
 Private cGet := Space(200)
	
	DEFINE MSDIALOG oDlg1 FROM 000,000 TO 150, 400 PIXEL TITLE "AS Execute"

		oGet := TGet():New(10,10,bSETGET(cGet),oDlg1,130,10,"@!",{|| },,,,,,.T.,,,,,,,.F.,,,)
		
		oBtBusca  := tButton():New(25, 10, "Executar", oDlg1, {|| AsProcExec(cGet) }, 030, 012,,,, .T.)
		
	ACTIVATE MSDIALOG oDlg1
	
Return

Static Function AsProcExec(cGet)

 If !Empty(cGet)
	//	TRYEXCEPTION
			xConteudo	:= &(AllTrim(cGet))
	//	ENDEXCEPTION
	EndIf
	
Return()

User Function AsUpdTable(cAlias)
	Local aArea := GetArea()
	
	If Select(cAlias) > 0
		dbSelectArea(cAlias)
		dbCloseArea()					
	EndIf	            

	X31UpdTable(cAlias)

	If __GetX31Error()
		Alert(__GetX31Trace())
		Aviso("Aviso!","Ocorreu um erro durante a atualizacao da tabela : "+ cAlias + ". Verifique a integridade do dicionario e da tabela.",{"OK"})
	EndIf
	dbSelectArea(cAlias)	

    RestArea(aArea)       
Return(.T.)

User Function AsInspVar(cVarName, xValue)
	
	If ValType(xValue) == 'A'
		
		InspectArr(cVarName, xValue)

	Else
		If ValType(xValue) == 'C'
			cAux := "'" + xValue + "'"
		ElseIf ValType(xValue) == 'N'
			cAux := AllTrim(Str(xValue))
		ElseIf ValType(xValue) == 'D'
			cAux := DtoC(xValue)
		EndIf
		
		Logger(cVarName + ": " + cAux)

	EndIf


Return(Nil)

Static Function InspectArr(cVar, xVar, nNivel)
	Local nI := 1 
	Local cAux := ""

	Default nNivel := 1

	For nI := 1 To Len(xVar)		
		If ValType(xVar[nI]) == "A"
			Logger(Replicate(" ", nNivel) + cVar + ": " )
			InspectArr("[" + AllTrim(Str(nI)) + "]", xVar[nI], nNivel + 1)
		Else
			If ValType(xVar[nI]) == "D"
				cAux := DtoC(xVar[nI])
			ElseIf ValType(xVar[nI]) == "N"
				cAux := AllTrim(Str(xVar[nI]))
			ElseIf xVar[nI] == Nil
				cAux := "Nil"
			Else
				cAux := xVar[nI]
			EndIf
			
			Logger(Replicate(" ", nNivel) + cVar + ": " + cAux)
		EndIf
	Next

Return(Nil)

Static Function Logger(cMsg)
	Local cTime := "[" + DtoC(Date()) + " " + Time() + "] "
	cMsg := " > " + cTime + cMsg
	U_AsConOut(cMsg)
Return(Nil)

User Function AsConOut(cTexto)
    Local aArea    := GetArea()
    Default cTexto := ""
     
    FWLogMsg(;
        "INFO",;    //cSeverity      - Informe a severidade da mensagem de log. As opções possíveis são: INFO, WARN, ERROR, FATAL, DEBUG
        ,;          //cTransactionId - Informe o Id de identificação da transação para operações correlatas. Informe "LAST" para o sistema assumir o mesmo id anterior
        "ASCONOUT",; //cGroup         - Informe o Id do agrupador de mensagem de Log
        ,;          //cCategory      - Informe o Id da categoria da mensagem
        ,;          //cStep          - Informe o Id do passo da mensagem
        ,;          //cMsgId         - Informe o Id do código da mensagem
        cTexto,;    //cMessage       - Informe a mensagem de log. Limitada à 10K
        ,;          //nMensure       - Informe a uma unidade de medida da mensagem
        ,;          //nElapseTime    - Informe o tempo decorrido da transação
        ;           //aMessage       - Informe a mensagem de log em formato de Array - Ex: { {"Chave" ,"Valor"} }
    ) 
     
    RestArea(aArea)
Return

User Function AsNfeSefaz(oHmPar, cProtocolo, cCodSta, cMsgSta, cXML, lQuiet)
	Local cIdEnt := ""
	Local cChave := ""
	Local lRet   := .T.
	
	Local cURL      := PadR(GetNewPar("MV_SPEDURL", "http://"),250)
	Local cMensagem := ""
	Local oWS
	
	Default lQuiet := .T.
	
	cIdEnt := AllTrim(u_AsGetIdEnt())
	cChave := Iif(ValType(oHmPar) == "O", oHmPar:getObj("cChave"), oHmPar)
	If Empty(cChave)
		UserException("Obrigatório a Informação da Chave!")
	EndIf
	
	oWs := WsNFeSBra():New()
	oWs:cUserToken := "TOTVS"
	oWs:cID_ENT    := cIdEnt
	ows:cCHVNFE    := cChave
	oWs:_URL       := AllTrim(cURL)+"/NFeSBRA.apw"
	
	If oWs:ConsultaChaveNFE()
		cMensagem := ""
		If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cVERSAO)
			cMensagem += "Versão da mensagem: "+oWs:oWSCONSULTACHAVENFERESULT:cVERSAO+CRLF
		EndIf
		cMensagem += "Ambiente: " + IIf(oWs:oWSCONSULTACHAVENFERESULT:nAMBIENTE==1,"Produção","Homologação")+CRLF //###
		cMensagem += "Cod.Ret.NFe: " + oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE+CRLF
		cMensagem += "Msg.Ret.NFe: " + oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE+CRLF
		If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO)
			cMensagem += "Protocolo: " + oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO+CRLF
			cProtocolo := oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO
		EndIf
		cCodSta := oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE
		cMsgSta := oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE
		cXML    := ""
		lRet    := AllTrim(oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE) $ "100/101/110"
		If !lRet .And. !lQuiet
			Aviso("Consulta Nfe", cMensagem, {"Ok"}, 3)
		EndIf
	Else
		If !lQuiet
			Aviso("SPED",IIf(Empty(GetWscError(3)), GetWscError(1), GetWscError(3)), {"OK"}, 3)
		EndIf
	EndIf
	
Return lRet

User Function AsGetIdEnt( cError )
	Local aArea  		:= GetArea()	
	Local cIdEnt 		:= ""
	Local cURL   		:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local lMethodOk		:= .F.
	Local oWsSPEDAdm

	BEGIN SEQUENCE

		IF !( CTIsReady(cURL) )
			BREAK
		EndIF

		cURL	:= AllTrim(cURL)+"/SPEDADM.apw"

		IF !( CTIsReady(cURL) )
			BREAK
		EndIF

		oWsSPEDAdm										:= WsSPEDAdm():New()
		oWsSPEDAdm:cUSERTOKEN 							:= "TOTVS"
		oWsSPEDAdm:oWsEmpresa:cCNPJ       				:= SM0->( IF(M0_TPINSC==2 .Or. Empty(M0_TPINSC),M0_CGC,"")	 )
		oWsSPEDAdm:oWsEmpresa:cCPF        				:= SM0->( IF(M0_TPINSC==3,M0_CGC,"") )
		oWsSPEDAdm:oWsEmpresa:cIE         				:= SM0->M0_INSC
		oWsSPEDAdm:oWsEmpresa:cIM         				:= SM0->M0_INSCM		
		oWsSPEDAdm:oWsEmpresa:cNOME       				:= SM0->M0_NOMECOM
		oWsSPEDAdm:oWsEmpresa:cFANTASIA   				:= SM0->M0_NOME
		oWsSPEDAdm:oWsEmpresa:cENDERECO   				:= FisGetEnd(SM0->M0_ENDENT)[1]
		oWsSPEDAdm:oWsEmpresa:cNUM        				:= FisGetEnd(SM0->M0_ENDENT)[3]
		oWsSPEDAdm:oWsEmpresa:cCOMPL      				:= FisGetEnd(SM0->M0_ENDENT)[4]
		oWsSPEDAdm:oWsEmpresa:cUF         				:= SM0->M0_ESTENT
		oWsSPEDAdm:oWsEmpresa:cCEP        				:= SM0->M0_CEPENT
		oWsSPEDAdm:oWsEmpresa:cCOD_MUN    				:= SM0->M0_CODMUN
		oWsSPEDAdm:oWsEmpresa:cCOD_PAIS   				:= "1058"
		oWsSPEDAdm:oWsEmpresa:cBAIRRO     				:= SM0->M0_BAIRENT
		oWsSPEDAdm:oWsEmpresa:cMUN        				:= SM0->M0_CIDENT
		oWsSPEDAdm:oWsEmpresa:cCEP_CP     				:= NIL
		oWsSPEDAdm:oWsEmpresa:cCP         				:= NIL
		oWsSPEDAdm:oWsEmpresa:cDDD        				:= Str(FisGetTel(SM0->M0_TEL)[2],3)
		oWsSPEDAdm:oWsEmpresa:cFONE       				:= AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
		oWsSPEDAdm:oWsEmpresa:cFAX        				:= AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
		oWsSPEDAdm:oWsEmpresa:cEMAIL      				:= UsrRetMail(RetCodUsr())
		oWsSPEDAdm:oWsEmpresa:cNIRE       				:= SM0->M0_NIRE
		oWsSPEDAdm:oWsEmpresa:dDTRE       				:= SM0->M0_DTRE
		oWsSPEDAdm:oWsEmpresa:cNIT        				:= SM0->( IF(M0_TPINSC==1,M0_CGC,"") )
		oWsSPEDAdm:oWsEmpresa:cINDSITESP  				:= ""
		oWsSPEDAdm:oWsEmpresa:cID_MATRIZ  				:= ""
		oWsSPEDAdm:oWsOutrasInscricoes:oWsInscricao		:= SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
		oWsSPEDAdm:_URL									:= cURL
        lMethodOk                                       := oWsSPEDAdm:AdmEmpresas()

		DEFAULT lMethodOk := .F.
		IF !( lMethodOk )
			cError := IF( Empty( GetWscError(3) ) , GetWscError(1) , GetWscError(3) )
			BREAK
		EndIF

		cIdEnt  := oWsSPEDAdm:cAdmEmpresasResult

	END SEQUENCE

	RestArea(aArea)

Return( cIdEnt )

User Function ASRChvNfe(cNota, cSerie, dDataRef, cUf, cCNPJ, cModalidade)
	Local cChave := ""
	Local cCodUf := ""
	                                     
	Default dDataRef    := dDataBase
	Default cUf         := SM0->M0_ESTCOB
	Default cCNPJ       := SM0->M0_CGC
	Default cModalidade := "55"          
	                       
	cAnoMes := SubStr(DtoS(dDataRef), 3, 2) + SubStr(DtoS(dDataRef), 5, 2)
		
	cCodUf  := RetUfCod(cUf)

	cChave := cCodUf + cAnoMes + cCNPJ + cModalidade + cSerie + cNota  + "1" + Inverte(StrZero(Val(AllTrim(cNota)),Len(cNota)))
	cChave := SubStr(cChave, 1, Len(cChave) - 1) + Modulo11(SubStr(cChave, 1, Len(cChave) - 1))
Return(cChave)    

Static Function Inverte(uCpo, nDig)
Local cRet	:= ""
Default nDig := 9
/*
Local cCpo	:= uCpo
Local cByte	:= ""
Local nAsc	:= 0
Local nI		:= 0
Local aChar	:= {}
Local nDiv	:= 0
*/
cRet	:=	GCifra(Val(uCpo),nDig)
/*
Aadd(aChar,	{"0", "9"})
Aadd(aChar,	{"1", "8"})
Aadd(aChar,	{"2", "7"})
Aadd(aChar,	{"3", "6"})
Aadd(aChar,	{"4", "5"})
Aadd(aChar,	{"5", "4"})
Aadd(aChar,	{"6", "3"})
Aadd(aChar,	{"7", "2"})
Aadd(aChar,	{"8", "1"})
Aadd(aChar,	{"9", "0"})

For nI:= 1 to Len(cCpo)
   cByte := Upper(Subs(cCpo,nI,1))
   If (Asc(cByte) >= 48 .And. Asc(cByte) <= 57) .Or. ;	// 0 a 9
   		(Asc(cByte) >= 65 .And. Asc(cByte) <= 90) .Or. ;	// A a Z
   		Empty(cByte)	// " "
	   nAsc	:= Ascan(aChar,{|x| x[1] == cByte})
   	If nAsc > 0
   		cRet := cRet + aChar[nAsc,2]	// Funcao Inverte e chamada pelo rdmake de conversao
	   EndIf
	Else
		// Caracteres <> letras e numeros: mantem o caracter
		cRet := cRet + cByte
	EndIf
Next
*/
Return(cRet)

Static Function RetUfCod(cUf)
	Local aUf := {}
	aadd(aUF,{"RO","11"})
	aadd(aUF,{"AC","12"})
	aadd(aUF,{"AM","13"})
	aadd(aUF,{"RR","14"})
	aadd(aUF,{"PA","15"})
	aadd(aUF,{"AP","16"})
	aadd(aUF,{"TO","17"})
	aadd(aUF,{"MA","21"})
	aadd(aUF,{"PI","22"})
	aadd(aUF,{"CE","23"})
	aadd(aUF,{"RN","24"})
	aadd(aUF,{"PB","25"})
	aadd(aUF,{"PE","26"})
	aadd(aUF,{"AL","27"})
	aadd(aUF,{"MG","31"})
	aadd(aUF,{"ES","32"})
	aadd(aUF,{"RJ","33"})
	aadd(aUF,{"SP","35"})
	aadd(aUF,{"PR","41"})
	aadd(aUF,{"SC","42"})
	aadd(aUF,{"RS","43"})
	aadd(aUF,{"MS","50"})
	aadd(aUF,{"MT","51"})
	aadd(aUF,{"GO","52"})
	aadd(aUF,{"DF","53"})
	aadd(aUF,{"SE","28"})
	aadd(aUF,{"BA","29"})
	aadd(aUF,{"EX","99"})
Return(aUF[aScan(aUF,{|x| x[1] == cUf})][02])

User Function AsCountTb(cAlias, cCond, aJoin)
	Local aArea  := GetArea()
	Local nCount := 0, nI := 0

	Local cSql := ""

	Local cAliasJoin := ""
	Local aCpoJoin   := {}, aCpValJoin := {}
	Local nCpoJoin   := 0
	Local lLeftJoin  := .F.
	Local cJoin  := ""     

	Default aJoin = {}

	If Len(aJoin) > 0
		For nI := 1 to len(aJoin)
			cAliasJoin := aJoin[nI, 1]
			aCpoJoin   := aJoin[nI, 2]
			aCpValJoin := aJoin[nI, 3]
			lLeftJoin  := IIF(Len(aJoin)>3,aJoin[nI, 4],.F.)

			cJoin := IIF(lLeftJoin, " LEFT ", "")+" JOIN " + RetSqlName(cAliasJoin) + " " + cAliasJoin + " ON "
			cJoin += cAliasJoin +"."+ PrefixoCpo(cAliasJoin) + "_FILIAL = '" + xFilial(cAliasJoin) + "' AND "
			cJoin += cAliasJoin + ".D_E_L_E_T_ <> '*' "

			For nCpoJoin := 1 to len(aCpoJoin)
				cJoin += " AND " + cAliasJoin + "." + aCpoJoin[nCpoJoin] + " = '" + &(aCpValJoin[nCpoJoin]) +"' "
			Next nCpoJoin
		Next nI 
	EndIf

	cSql += " SELECT COUNT(*) NCOUNT "
	cSql += "   FROM " + RetSqlName(cAlias) + " " + cAlias
	cSql += IIF(!Empty(cJoin),cJoin,"")
	cSql += "  WHERE " + cAlias + "." + PrefixoCpo(cAlias) + "_FILIAL = '" + xFilial(cAlias) + "' " 
	cSql += "    AND " + cAlias + ".D_E_L_E_T_ <> '*' " 
	cSql += IIf(!Empty(cCond), "AND " + cCond, "")

	TCQuery cSql New Alias "QTREG"

	nCount := QTREG->NCOUNT

	QTREG->(DbCloseArea())
	RestArea(aArea)
Return(nCount)

User Function AsMsDocGrv(cArq, cChave, cEntidade)
	Local lRet := .F.
	Local cFile := ""
	Local cExten := ""
	Local cCodObj := ""

	Default cEntidade := Alias()
	
	If Select("ACB") == 0
		DbSelectArea("ACB")
	EndIf
	
	If Select("AC9") == 0
		DbSelectArea("AC9")
	EndIf
	
	If lRet := CopyObj(cArq)
		SplitPath( cArq, , , @cFile, @cExten )
		RecLock("ACB", .T.)
			ACB->ACB_FILIAL := xFilial("ACB")
			ACB->ACB_CODOBJ := cCodObj := GetSXENum( "ACB", "ACB_CODOBJ" )
			ACB->ACB_OBJETO := cFile + cExten
			ACB->ACB_DESCRI := cFile
		MsUnLock()
		
		ConfirmSx8()
		
		RecLock("AC9", .T.)
			AC9->AC9_FILIAL := xFilial("AC9")
			AC9->AC9_FILENT := xFilial(cEntidade)
			AC9->AC9_ENTIDA := cEntidade
			AC9->AC9_CODENT := cChave
			AC9->AC9_CODOBJ := cCodObj
		MsUnLock()
	EndIf
	FErase(cArq)
Return(lRet)

Static Function CopyObj(cArq)
	Local lRet := .F.
	Local cDirDocs := ""
	Local cFile := "", cExt := ""
	Local cDrive := ""
	Local cTempDir := "/tmp/"
	
	Private cCadastro := "Banco de Conhecimento"
	
	SplitPath( cArq, @cDrive, , @cFile, @cExt )

	If !Empty(cDrive)//Arquivo Local
		MakeDir(cTempDir)

		CpyT2S(cArq, cTempDir)

		cArq := cTempDir + cFile + cExt
		
		cDrive := "" 
		cFile  := "" 
		cExt   := ""

		SplitPath( cArq, @cDrive, , @cFile, @cExt )
	EndIf 

	cDirDocs := MsDocPath()
	
	If File(cDirDocs + "\" + cFile + cExt) //Exclui arquivo pré existente para atualização
		FErase(cDirDocs + "\" + cFile + cExt)
	EndIf
	
	If !(lRet := __CopyFile(cArq, cDirDocs + "\" + cFile + cExt))
		MsgStop("Erro ao copiar arquivo [" + cFile + cExt + "] para banco de conhecimento")
	EndIf

Return(lRet)

User Function JsonObj(cJson)
    Local oJson := Nil

	If ValType( cJson ) <> "C"
		cJson := ""
	EndIf

	cRet := FwNoAccent(Upper(cJson))

    If !FWJsonDeserialize(cRet, @oJson)
		oJson := Nil
	EndIf

Return(oJson)

User Function ASApostro(cString) 
	Local nI := 1
	Local cRet := ""

	For nI := 1 To Len(cString)
		If Substr(cString,nI,1) == "'"
			cRet += "''"
		Else
			cRet += Substr(cString,nI,1)
		Endif
	Next
Return(cRet)

User Function AsRetFone( cPhone , cDDD, cTel )
	cDDD := ""
	cTel := ""
	
	cPhone := StrTran( cPhone , ")" , "" )
	cPhone := StrTran( cPhone , "(" , "" )
	cPhone := StrTran( cPhone , "-" , "" )
	cPhone := StrTran( cPhone , " " , "" )
		
	cPhone := AllTrim( IIF( SubStr( cPhone , 1 , 1 ) == '0', cPhone , "0" + cPhone ) )
		
	cDDD := SubStr( cPhone , 1 , 3 )
	cTel := SubStr( cPhone , 4 )
			
Return( Nil )

User Function AsTrataStr( cString )
	Default cString := ""
	
	If ValType( cString ) <> "C"
		cString := ""
	EndIf
	cString := DecodeUtf8( cString )
	cString := NoAcento( cString )	
	cString := Upper( cString )
Return( cString )

User Function AsExists(aVet)
	Local aArea := GetArea()
	Local lRet  := .T.
	Local nI    := 0

	For nI := 1 to Len(aVet)
		If lRet
			If aVet[nI, 1] == "T"
				DbSelectArea("SX2")
				DbSetOrder(1) //X2_CHAVE
				lRet := DbSeek(aVet[nI, 2])
			ElseIf aVet[nI, 1] == "C"                
				//Abre Area 
				If lRet := u_Exists({{"T", u_RPrefCpo(aVet[nI, 2], .T.)}})
					DbSelectArea(u_RPrefCpo(aVet[nI, 2], .T.))
					
					DbSelectArea("SX3")
					DbSetOrder(2) //X3_CAMPO
					lRet := DbSeek(aVet[nI, 2]) .And. &(u_RPrefCpo(aVet[nI, 2], .T.)+"->(FieldPos('"+aVet[nI, 2]+"'))") > 0
				EndIf
			EndIf
		EndIf
	Next


	RestArea(aArea)
Return(lRet)