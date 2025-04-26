
#include "TOTVS.CH"

#DEFINE F_NAME 1
#DEFINE F_SIZE 2

Static cLastDir := ""
Static aLetters := {'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'}

User Function ASSelArq(cFileExt)
	Local aSize    := MsAdvSize()
	Local cTitulo := "Selecione Arquivos"
	Local oDlgSel := Nil
	Local aUnits := {}
	Local aNodes := {}
	Local nI := 1
	Local cImg1 := "FOLDER5", cImg2 := "FOLDER6"
	Local oTree := Nil, oGridSel := Nil
	Local aArquivos := {}
	Local cSelDir := ""
	Local nOpcE := 0
	Local cCSSPesq := ""

	Private nId := 0
	Private cPesq := Space(100)
	Private oPesq := Nil
	Private cCadastro := cTitulo

	Default cFileExt := "*"

	If cFileExt <> "*"
		cCadastro += " (Somente: " + cFileExt + ")"
	EndIf

	For nI := 1 To Len(aLetters)
		If ExistDir(aLetters[nI] + ":")
			aAdd(aUnits, aLetters[nI] + ":")
		EndIf
	Next

	cCSSPesq := 'QLineEdit          { border-width:               1px    ; }'
	cCSSPesq += 'QLineEdit          { border-style:               Solid  ; }'
	cCSSPesq += 'QLineEdit          { border-color:               #777777; }'
	cCSSPesq += 'QLineEdit          { border-radius:              14px   ; }'
	cCSSPesq += 'QLineEdit          { background-color:           #FFFFFF; }'
	cCSSPesq += 'QLineEdit          { font-family:                Verdana; }'
	cCSSPesq += 'QLineEdit          { font-size:                  20px   ; }'
	cCSSPesq += 'QLineEdit          { padding:                    0 2px  ; }'
	cCSSPesq += 'QLineEdit          { margin:                     2px 2px 2px 2px ; }'
	cCSSPesq += 'QLineEdit:disabled { background-color:           #BCBCBC; }'
	cCSSPesq += 'QLineEdit:disabled { color:                      #FFFFFF; }'

	DEFINE MSDIALOG oDlgSel TITLE cTitulo From 000, 000 TO aSize[6] * 0.9, aSize[5] * 0.9 Of oMainWnd PIXEL

	// oPnlBottom := TPanel():New(000,000,, oDlgSel            ,,,,,RGB(245, 245, 245), 018,018)
	// oPnlBottom:align := CONTROL_ALIGN_BOTTOM

	// oBtn := TBtnBmp2():New(000, 855, 100, 030, 'CANCEL', 'CANCEL'  , , , {|| oDlgSel:End() }, oPnlBottom   , "Sair" )
	// oBtn:cCaption := "SAIR"
	// oBtn:Refresh()
	// oBtn:align := CONTROL_ALIGN_RIGHT

	// oBtn := TBtnBmp2():New(000, 855, 100, 030, 'OK', 'OK'  , , , {|| nOpcE := 1, oDlgSel:End() }, oPnlBottom   , "Finaliza" )
	// oBtn:cCaption := "CONFIRMAR"
	// oBtn:Refresh()
	// oBtn:align := CONTROL_ALIGN_RIGHT

	// Cria a Tree
	oTree := DbTree():New(0     , 0      , 200      , 200     , oDlgSel  , { || ChgDir(@oTree, @oGridSel, @cSelDir, aArquivos, cFileExt) },           , .T.      , .F.        ,         , )		    // Insere itens
	//       DBTree():New([nTop], [nLeft], [nBottom], [nRight], [oWnd]   , [ bChange]           , [ bRClick], [ lCargo], [ lDisable], [ oFont], [ cHeaders] )
	oTree:Align := CONTROL_ALIGN_LEFT
	For nI := 1 To Len(aUnits)
		oTree:AddItem(PadR(aUnits[nI], 80), GetNextId(), "FOLDER5", "FOLDER6",,,1)

		oTree:TreeSeek(GetId())
		InsFolder(aUnits[nI], @oTree)
	Next
	oTree:EndTree()

	oPnlMain := TPanel():New(000,000,, oDlgSel            ,,,,,RGB(245, 245, 245), 018,018)
	oPnlMain:align := CONTROL_ALIGN_ALLCLIENT

	oPnlTop := TPanel():New(000,000,, oPnlMain            ,,,,,RGB(245, 245, 245), 018,018)
	oPnlTop:align := CONTROL_ALIGN_TOP

	oBtn := TBtnBmp2():New(009, 090, 040, 040, "S4WB011N", "S4WB011N"  , , , {|| LoadFiles( oGridSel, @aArquivos, cSelDir, cFileExt ) }, oPnlTop   , "" )
	oBtn:cCaption := ""
	oBtn:Align := CONTROL_ALIGN_RIGHT
	oBtn:Refresh()

	oPesq := AsGetFact():new(001 , 001 , oPnlTop   , 120   , 060    , 'cPesq', "G" )
	oPesq:oGet:Align := CONTROL_ALIGN_RIGHT
	oPesq:oGet:SetCss(cCSSPesq)
	oPesq:Refresh()

	oGridSel := AsGrid():New(001, 001  , 600    , 600   , 0,         ,         ,,,, 99999,,,, oPnlMain)
	oGridSel:SetTitle("Arquivos")
	oGridSel:AddColumn({ "Nome"       , "ARQUIVO",  ""               , 100, 0, .F., "", "C", "", "V", "", "", "", "V", "", "", ""})
	oGridSel:AddColumn({ "Tamanho(KB)", "TAMANHO",  "@E 999,999,999,999.99", 015, 2, .F., "", "N", "", "V", "", "", "", "V", "", "", ""})
	//oGridSel:AddColumn({ "Data"   , "DATAARQ",  "@D", 008, 0, .F., "", "D", "", "V", "", "", "", "V", "", "", ""})
	//oGridSel:AddColumn({ "Hora"   , "HORAARQ",  "@!", 008, 0, .F., "", "C", "", "V", "", "", "", "V", "", "", ""})

	oGridSel:AddColBMP("IDMARK", "LBNO")

	oGridSel:Load()
	oGridSel:SetAlignAllClient()
	oGridSel:SetDoubleClick({ || MarcaGrid(oGridSel, cSelDir, aArquivos) })

	oGridSel:SetArray({{"LBNO", "", 0, .T.}})

	ACTIVATE MSDIALOG oDlgSel CENTERED ON INIT EnchoiceBar(oDlgSel, {|| nOpcE := 1,  oDlgSel:End()}, ;
		{|| nOpcE := 0,  oDlgSel:End()})//,, aButtons)

	If nOpcE == 0
		aArquivos := {}
	EndIf
Return(aArquivos)

Static Function MarcaGrid(oGrid, cSelDir, aArquivos)
	Local cMark := IIF(oGrid:GetField("IDMARK") == "LBTIK", "LBNO", "LBTIK")
	Local cFile := AllTrim(cSelDir + "\" + oGrid:GetField("ARQUIVO"))
	Local nPos := aScan(aArquivos, { |aVet| AllTrim(aVet) == AllTrim(cFile) })

	oGrid:SetField("IDMARK", cMark)
	If cMark == "LBTIK"
		If nPos == 0
			aAdd(aArquivos, cFile)
		EndIf
	Else
		If nPos > 0
			aDel(aArquivos, nPos)
			aSize(aArquivos, Len(aArquivos) - 1)
		EndIf
	EndIf
	oGrid:Refresh()
Return(Nil)

Static Function InsFolder(cPath, oTree)
	Local aFiles := Directory(cPath + "\*.*", "D", , .F.)
	Local nJ := 1

	For nJ := 1 To Len(aFiles)
		If "D" $ aFiles[nJ, 5] .And. aFiles[nJ, 1] <> '.' .And. aFiles[nJ, 1] <> '..'
			oTree:AddItem(aFiles[nJ, 1], GetNextId(), "FOLDER5", "FOLDER6",,,2)
		EndIf
	Next
Return(Nil)

Static Function GetNextId()
Return(StrZero(++nId, 12))

Static Function GetId()
Return(StrZero(nId, 12))

Static Function ChgDir(oTree, oGridSel, cSelDir, aArquivos, cFileExt)
	Local cAlias := oTree:cArqTree
	Local cPath := ""
	Local cCargo := oTree:GetCargo()
	Local cTitle := ""
	Local cAux := ""

	oTree:TreeSeek(cCargo)
	GetPath(cAlias, @cPath)

	cPesq := Space(100)
	oPesq:Refresh()

	If (cAlias)->T_ISTREE <> 'S'
		InsFolder(cPath, @oTree)
		oTree:TreeSeek(cCargo)
		oTree:PTUpdateNodes( (cAlias)->T_IDCODE )
		oTree:PTGotoToNode( (cAlias)->T_IDCODE )
		oTree:PTRefresh()
	EndIf

	LoadFiles( oGridSel, aArquivos, cPath, cFileExt )
	cSelDir := cPath
Return(Nil)

Static Function SetTitle(oGridSel, cPath)
	Local cAux := ""
	Local cTitle := cPath
	Local cSearch := IIF( Empty( cPesq ), "*.*", "*" + AllTrim( cPesq ) + "*")

	While Len(cTitle) > 60
		If RAt('\', cTitle) > 0
			cAux := SubStr(cTitle, RAt('\', cTitle), 57)
			cTitle := SubStr(cTitle, 1, 60 - (Len(cAux) + 3)) + "..." + cAux
		Else
			cTitle := SubStr(cPath, 1, 7) + "..." + SubStr(cPath, -45)
		EndIf
	EndDo

	oGridSel:SetTitle(cTitle + "\" + cSearch)
Return( Nil )

Static Function LoadFiles( oGridSel, aArquivos, cPath, cFileExt )
	Local aFiles := {}, aCols := {}
	Local nPos := 0
	Local cSearch := IIF( Empty( cPesq ), "*.*", "*" + AllTrim( cPesq ) + "*")
	Local nI := 1

	SetTitle(oGridSel, cPath)

	aFiles := Directory(cPath + "\" + cSearch )
	For nI := 1 To Len(aFiles)
		nPos := aScan(aArquivos, { |aVet| AllTrim(aVet) == AllTrim(cPath + "\" + aFiles[nI, 1]) })

		If cFileExt == "*" .OR. Upper(AllTrim(SubStr(aFiles[nI, 1], RAt(".", aFiles[nI, 1]) + 1))) + "/" $ Upper(cFileExt) + "/"
			aAdd(aCols, {IIF(nPos == 0, "LBNO", "LBTIK"), aFiles[nI, F_NAME], aFiles[nI, F_SIZE] / 1024, .F.})
		EndIf
	Next

	If Empty(aCols)
		aCols := {{"LBNO", "", 0, .T.}}
	EndIf

	oGridSel:SetArray(aCols)

Return( Nil )

Static Function GetPath(cAlias, cPath)
	Local cIdCode := ""

	If (cAlias)->T_IDTREE == "0000000"
		cPath := AllTrim((cAlias)->T_PROMPT)
	Else
		cIdCode := (cAlias)->T_IDCODE
		(cAlias)->(DbSetOrder(3))
		(cAlias)->(DbSeek((cAlias)->T_IDTREE))
		GetPath(cAlias, @cPath)
		(cAlias)->(DbSeek(cIdCode))

		cPath += "\" + AllTrim((cAlias)->T_PROMPT)
	EndIf
Return()