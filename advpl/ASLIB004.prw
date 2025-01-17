
#INCLUDE "TOTVS.ch"
#INCLUDE "TopConn.ch"

#DEFINE X3TITULO   1
#DEFINE X3CAMPO	   2
#DEFINE X3PICTURE  3
#DEFINE X3TAMANHO  4
#DEFINE X3DECIMAL  5
#DEFINE X3VALID    6
#DEFINE X3USADO    7
#DEFINE X3TIPO     8
#DEFINE X3F3       9
#DEFINE X3CONTEXT 10
#DEFINE X3CBOX    11
#DEFINE X3RELACAO 12
#DEFINE X3WHEN    13
#DEFINE X3VISUAL  14
#DEFINE X3VLDUSER 15
#DEFINE X3PICTVAR 16
#DEFINE X3OBRIGAT 17

Static STATUS_NORMAL       := 0
Static STATUS_UNEXPANDED   := 1
Static STATUS_EXPANDED     := 2

//CLASSE AsGrid
//-------------
Class AsGrid
	Data oGrid
	Data oBrowse  
	Data nUsado

	//Variaveis de inicialização
	Data nTop
	Data nLeft
	Data nBottom
	Data nRight
	Data nStyle
	Data cLinhaOk
	Data cTudoOk
	Data cIniCpos
	Data aAlter
	Data nFreeze
	Data nMax
	Data cFieldOk
	Data cSuperDel
 	Data cDelOk
	Data oWnd
	Data aHeader
	Data aCols
	Data uChange
	Data cTela

	Data cAliasTree  //Alias temporário para indexar a árvore, caso esteja sendo utilizada
	Data cIndID     //Indice do arquivo temporário por ID
	Data cIndParent  //Indice do arquivo temporário por ID do Pai
	Data lTree       //Facilitador para verificar se existe árvore na grid
	Data nIndent     //Quantidade de caracteres para indentação
	Data cIdSeq      //Controle sequecial de ID
	Data nPosIDTree  //Posição do ID no aCols
	Data oHColBMP   
	Data aColors As Array 
	Data bBackColor 
	Data cTitle As String
	Data oPanel As Object
	Data oSay As Object
	Data oFont As Object
	Data nLastTime As Integer
	Data oTimer As Object
	Data bChange 
	Data nSelectRow As Integer
	Data lMarkSelected As Boolean

	DATA oTimerChange
	Data lTimerChange as boolean

	// propriedades para o SetSeek()
	Data oSeekPnl
	Data oSeekCbx
	Data cSeekCbx
	Data oSeekGet
	Data oSeekChk
	Data lSeekChk
	Data xSeekGet
	Data oSeekFirst
	Data oSeekNext
	Data lSetSeek
	Data aSeekItem

	Data bAfterDel


	// Trabalhar como MarkBrowse
	Data lIsMarkSet
	Data lAllMark
	Data lCriaCol 
	Data oTik
	Data oNo
	Data bOnMark
	
	
	Method New(nTop, nLeft, nBottom, nRight, nStyle, cLinhaOk, cTudoOk, cIniCpos, aAlter, nFreeze, nMax, cFieldOk, cSuperDel, cDelOk, oWnd,  ;
				aPartHeader, aParCols, uChange, cTela) Constructor
	Method AddColumn(aColumn)  //Adiciona Coluna no aHeader conforme parametro -- passa-se os dados da coluna no array conforme cfg. do aHeader
	Method AddColSX3(cFieldSX3, cTitulo, cCampo, cPicture, nTamanho, nDecimal, lReadOnly)//Adiciona Coluna no aHeader conforme dicionario
	Method AddColBMP(cName, cBMPDefault, nPos, cTitle) //Adiciona Coluna para exibir BMP
	Method AddLine(aInfo) //Adiciona linha na grid
	Method Load()         //Instancia a MsNewgetDados
	Method SetAlignAllClient()
	Method SetAlignTop()
	Method SetAlignBottom()
	Method SetAlignLeft()
	Method SetAlignRight()
	Method SetDoubleClick(bCodeBlock) //Bloco de codigo executado no duplo clique
	Method SetChange(bCodeBlock)      //Bloco de codigo executado no evento OnChange

	Method SetSeek()                  // Abre painel superior para pesquisar
	method setSeekGet()
	Method gridSeek()
	Method itSeek()

	Method GetAt()                    //Retorna nAt da Grid
	Method SetAt(nAt)                 //Possibilita mudar nAt da Grid
	Method GetColPos()                //Retorna qual coluna foi selecionada na Grid
	Method GetField(cField, nRow)     //Retorna o conteúdo de um campo na linha nAt
	Method SetField(cField, xValue, nRow)   //Preenche campo com conteúdo na linha nAt
	Method FromSql(cSql)              //Carrega linhas na Grid de acordo com uma query passada
	Method SetArray(aCols)            //Mesmo papel da SetArray na NewGetdados
	Method Refresh()
	Method GetColHeader(cField)       //Retorna o número da coluna de um determinado campo na grid
	Method Busca(xBusca, cField)      //Busca conteúdo em determinada coluna
	Method SetFocus()
	Method GotFocus(bAction)
	Method LostFocus(bAction)

	Method Tree()                     //Adiciona coluna BMP para simulação de arvore
	Method SaveNodeInfo(nLevel, cIDParent, nStatus) //Grava informações do Nó no arquivo temporário
	Method DelNodeInfo(nRow)                        //Exclui informações do Nó
	Method AddTreeChields(aFieldCols, nRowParent) //Adiciona "SubAcols" um nivel abaixo de determinado item
	Method AddChield(aInfo)           //Adiciona linha "filha" na arvore
	Method GetLevel(nRow)                 //Retorna nível de acordo com o nAt
	Method GetIDNode(nRow)            //Retorna ID do Nó
	Method SetTreeStatus(nStatus, nRow) //Seta algum status na linha, default nAt
	Method SetTreeExpanded(nRow)						//Seta Bitmap "-" no item da arvore, na linha passada, default nAt
	Method SetTreeUnExpanded(nRow)    //Seta Bitmap "+" no item da arvore, na linha passada, default nAt
	Method IsExpanded(nRow)           //Retorna .T. se uma linha está expandida, default nAt
	Method AddColID(aVet, nLevel)             //Adiciona coluna ID no aCols
	Method GetRowID(cID)              //Busca no acols a linha que contém determinado ID
	Method GetNodeInfo(cInfo, nRow)   //Retorna informações do arquivo temporário a respeito de um determinado nó da árvore
	Method DelTreeChields()           //Exclui registros "filhos" a partir de um nó da árvore
	Method GetParentRowId(nBackLvl)
	Method GetParentField(cField, nBackLvl)
	Method IsDeleted(nRow)

	//Tramento Cor
	Method SetBackColor(nRow, cBackColor)
	Method RetBackColor()
	Method SetbBackColor(bColor)
	Method SelectRowColor()

	Method SetTitle(cTitle)

	Method Length()
	Method IniTimer()

	Method NextLine()
	Method PrevLine()

	Method InitACols()
	
	Method SetAfterDel(bDelete)
	
	
	// Trabalhar como MarkBrowse
	Method MarkSet() // Trabalha como MarkBrowse
	Method Marca() // Marca / Desmarca
	Method MarkAll() // Marca todos ou desmarca todos
	Method IsMarked() // Linha Marcada?
	Method OnMark() // Executa codigo de bloco ao marcar/Desmarcar
	
	
EndClass

Method SetAfterDel(bDelete) class AsGrid	
	self:bAfterDel := bDelete
Return(self)

Method NextLine() class AsGrid
	Local nLin := self:GetAt()
	If nLin + 1 <= self:Length()
		self:SetAt(nLin + 1)
	EndIf
Return(self)

Method PrevLine() class AsGrid
	Local nLin := self:GetAt()
	If nLin - 1 > 0
		self:SetAt(nLin - 1)
	EndIf
Return(self)

Method SelectRowColor() class AsGrid
	Local nColor := Nil
	If self:oGrid:nAt == self:nSelectRow
		nColor := RGB(250, 255, 185)
	EndIf
Return(nColor)

Method IniTimer(lTimer) class AsGrid
	Local nSeconds := Seconds()

	Default lTimer := .F.
	
	if ! (self:lTimerChange)
		return(self)
	endif
	self:nSelectRow := self:oGrid:nAt

	If lTimer .Or. nSeconds - self:nLastTime > 0.4
		Eval(self:bChange)
		self:Refresh()

		self:oTimerChange:DeActivate()
	Else
		self:oTimerChange:DeActivate()
		self:oTimerChange:Activate()
	EndIf
	self:nLastTime := nSeconds
Return(self)

Method Length() class AsGrid
Return(Len(self:oGrid:aCols))

Method SetTitle(cTitle) class AsGrid
	self:cTitle := " " + cTitle
	If self:oSay <> Nil
		self:oSay:SetText( self:cTitle )
		self:oSay:Refresh()
	EndIf
Return(self)

Method SetBackColor(nRow, cBackColor) class AsGrid
	Local nCurrRow := self:oGrid:oBrowse:nAt
	Local bColor := Nil

	self:oGrid:oBrowse:nAt := nRow

	self:oGrid:oBrowse:lUseDefaultColors := .F.

	If aScan(self:aColors, { | aVet | aVet[1] == nRow }) == 0
		aAdd(self:aColors, {nRow, cBackColor})
	EndIf

	If Empty(self:bBackColor)
		self:bBackColor := {|| self:RetBackColor() }
	EndIf

	self:oGrid:oBrowse:SetBlkBackColor(self:bBackColor)

	self:oGrid:oBrowse:nAt := nCurrRow
Return(self)

Method SetbBackColor(bColor) class AsGrid
	self:bBackColor := bColor
	self:oGrid:oBrowse:SetBlkBackColor(self:bBackColor)
Return(Self)

Method RetBackColor() class AsGrid
    Local nRow := self:oGrid:oBrowse:nAt
	Local nColor := RGB(255,255,255)

	If (nPos := aScan(self:aColors, { | aVet | aVet[1] == nRow })) > 0
		nColor := self:aColors[nPos, 2]
	EndIf

Return(nColor)

Method IsDeleted(nRow) class AsGrid
	Local nPosDel := 0

	Default nRow := self:GetAt()

	nPosDel := Len(self:oGrid:aCols[nRow])
Return(self:oGrid:aCols[nRow, nPosDel])

Method New(nTop, nLeft, nBottom, nRight, nStyle, cLinhaOk, cTudoOk, cIniCpos, aAlter, nFreeze, nMax, cFieldOk, cSuperDel, cDelOk, oWnd, ;
	aPartHeader, aParCols, uChange, cTela) Class AsGrid

	Default nFreeze     := 0
	Default nMax        := 5000
	Default aAlter      := Nil
	Default cFieldOk    := Nil
	Default cSuperDel   := Nil
	Default cDelOk      := Nil
	Default oWnd        := Nil
	Default aPartHeader := Nil
	Default aParCols    := Nil
	Default uChange     := Nil
	Default cTela       := Nil
	

	self:oGrid     := Nil
	self:oBrowse   := Nil
	self:nTop      := nTop
	self:nLeft     := nLeft
	self:nBottom   := nBottom
	self:nRight    := nRight
	self:nStyle    := nStyle
	self:cLinhaOk  := cLinhaOk
	self:cTudoOk   := cTudoOk
	self:cIniCpos  := cIniCpos
	self:aAlter    := aAlter
	self:nFreeze   := nFreeze
	self:nMax      := nMax
	self:cFieldOk  := cFieldOk
	self:cSuperDel := cSuperDel
	self:cDelOk    := cDelOk
	self:oWnd      := oWnd
	self:aHeader    := aPartHeader
	self:aCols     := aParCols
	self:uChange   := uChange
	self:cTela     := cTela
	self:aColors   := {}

	self:nUsado    := 0

	self:oHColBMP   := AsHash():New()
	self:lTree      := .F.
	self:cIdSeq     := StrZero(0, 10)
	self:nPosIDTree := 0
	self:cTitle := ""
	self:bChange := { || Nil }
	self:lMarkSelected := .F.
	self:lTimerChange  := .t.
	self:bAfterDel := { || .T. }

	self:oFont  := TFont():New("ARIAL BLACK",,-12,.F.)
	self:nLastTime := Seconds()

	self:lSetSeek := .f.
	
	// MarkBrowse
	self:lIsMarkSet := .f. // .t.=trata grid como markbrowse
	self:lAllMark   := .f. // .t.=traz todos os registros marcados
	

Return(Self)

Method AddColumn(aColumn) Class AsGrid
	/* Padrão aHeader MsNewGetDados
	1 - TITULO, ;
	2 - CAMPO   	, ;
	3 - PICTURE 	, ;
	4 - TAMANHO 	, ;
	5 - DECIMAL 	, ;
	6 - VALID   	, ;
	7 - USADO   	, ;
	8 - TIPO    	, ;
	9 - F3      	, ;
	10 - CONTEXT 	, ;
	11 - CBOX    	, ;
	12 - RELACAO 	, ;
	13 - WHEN    	, ;
	14 - VISUAL  	, ;
	15 - VLDUSER 	, ;
	16 - PICTVAR 	, ;
	17 - OBRIGAT})
	*/
	If self:aHeader == Nil
		self:aHeader := {}
	EndIf

	aAdd(self:aHeader, aColumn)

	self:nUsado++

Return(Self)

Method AddColSX3(cFieldSX3, cTitulo, cCampo, cPicture, nTamanho, nDecimal, lReadOnly) Class AsGrid
	Local aArea   := {Alias(),IndexOrd(),Recno()} // GetArea() - gambiarra alessandro
	Local aAreaX3 := SX3->({Alias(),IndexOrd(),Recno()}) // SX3->(GetArea())

	If self:aHeader == Nil
		self:aHeader := {}
	EndIf

	DbSelectArea("SX3")
	DbSetOrder(2)
	If DbSeek(cFieldSX3)
		aAdd(self:aHeader, {IIf(cTitulo <> Nil, cTitulo, SX3->X3_TITULO) , ;
		IIf(cCampo  <> Nil, cCampo , SX3->X3_CAMPO ) , ;
		IIf(cPicture <> Nil, cPicture, SX3->X3_PICTURE), ;
		IIf(nTamanho <> Nil, nTamanho, SX3->X3_TAMANHO), ;
		IIf(nDecimal <> Nil, nDecimal, SX3->X3_DECIMAL), ;
		SX3->X3_VALID  , ;
		SX3->X3_USADO  , ;
		SX3->X3_TIPO   , ;
		SX3->X3_F3     , ;
		SX3->X3_CONTEXT, ;
		SX3->(X3Cbox()) , ;
		SX3->X3_RELACAO, ;
		IIf(lReadOnly <> Nil .And. lReadOnly, '.F.', SX3->X3_WHEN), ;
		SX3->X3_VISUAL , ;
		SX3->X3_VLDUSER, ;
		SX3->X3_PICTVAR, ;
		SX3->X3_OBRIGAT})
	EndIf

	self:nUsado++

	RestArea(aAreaX3)
	RestArea(aArea)
Return(Self)

//Cria nova linha na Grid
//Com os dados da linha passados no parâmetro ou uma linha em branco, caso o parametro não tenha sido passado
Method AddLine(aInfo) Class AsGrid
	Local nI      := 0
	Local aArea   := GetArea()
	Local aAreaX3 := SX3->(GetArea())

	Default aInfo := {}

	If self:aCols == Nil
		self:aCols := {}
	EndIf

	If Len(aInfo) > 0
		aAdd(self:aCols, aInfo)
	Else
		aAdd(self:aCols, Array(self:nUsado + 1))

		DbSelectArea("SX3")
		DbSetOrder(2)

		For nI := 1 To Len(self:aHeader)

			If DbSeek(self:aHeader[nI, X3CAMPO]) //É um campo do dicionário
				self:aCols[Len(self:aCols), nI] := CriaVar(self:aHeader[nI, X3CAMPO], .F.)
			Else
				If self:aHeader[nI, X3TIPO] == "D"
					self:aCols[Len(self:aCols), nI] := CTOD("  /  /  ")
				ElseIf self:aHeader[nI, X3TIPO] == "N"
					self:aCols[Len(self:aCols), nI] := 0
				ElseIf self:aHeader[nI, X3TIPO] == "C"
					If self:aHeader[nI, X3PICTURE] <> "@BMP"
						self:aCols[Len(self:aCols), nI] := Space(self:aHeader[nI, X3TAMANHO])
					Else//Insere Bitmap padrão
						IF ::lIsMarkSet .and. nI == 1
							if ::lCriaCol
								::aCols[Len(::aCols), nI] := if( ::lAllMark, "LBTIK", "LBNO" )
							else
								::aCols[Len(::aCols), nI] := ::oHColBmp:getObj(nI) // aqui
							endif
						Else
							::aCols[Len(::aCols), nI] := ::oHColBmp:getObj(nI)
						EndIf
					EndIf
				EndIf
			EndIf
		Next

		//Adiciona a última coluna -- deleted
		self:aCols[Len(self:aCols), self:nUsado+1] := .F.
	EndIf

	If self:lTree//Se tem arvore adiciona uma coluna para ID da linha
		Self:AddColID(@self:aCols[Len(self:aCols)])
	EndIf

	If self:oGrid <> Nil
		self:oGrid:SetArray(self:aCols)
		self:oGrid:Refresh()
	EndIf

Return(Self)

Method Load() Class AsGrid

	local nLoop := 1

	self:oPanel := tPanel():New(self:nTop, self:nLeft,, self:oWnd,,,,,, self:nRight - self:nLeft, self:nBottom - self:nTop)
	//oPanel:Align := CONTROL_ALIGN_BOTTOM

	If !Empty(self:cTitle)
		oPnlSay := tPanel():New(000, 000,, self:oPanel,,,,,RGB(255, 255, 255), 80, 10, .F., .F.)
		oPnlSay:Align := CONTROL_ALIGN_TOP
		self:oSay := TSay():New(005,001,{|| self:cTitle },oPnlSay,,self:oFont,,,,.T.,,,80,10)
		self:oSay:Align := CONTROL_ALIGN_ALLCLIENT
		self:oSay:nClrText := 8388608
	EndIf

	//-----------------------------------
	// tratamento para a barra de busca
	//-----------------------------------
	if self:lSetSeek

		//----------------------------------------
		// carrega itens do combobox
		//----------------------------------------
		self:ItSeek()
		::lSeekChk := .f.
		@ 000, 000 MSPANEL self:oSeekPnl SIZE 225, 013 OF self:oPanel RAISED
		@ 000, 000 MSCOMBOBOX self:oSeekCbx VAR self:cSeekCbx ITEMS self:aSeekItem VALID self:setSeekGet() SIZE 066, 010 OF self:oSeekPnl PIXEL
		@ 000, 067 MSGET self:oSeekGet VAR self:xSeekGet SIZE 124, 012 OF self:oSeekPnl PIXEL
		@ 000, 191 BUTTON self:oSeekFirst PROMPT ">" SIZE 016, 012 OF self:oSeekPnl ACTION Processa( {||self:GridSeek( .f. ),self:oGrid:oBrowse:SetFocus()}, "Primeiro..." ) PIXEL
		@ 000, 207 BUTTON self:oSeekNext PROMPT ">>" SIZE 016, 012 OF self:oSeekPnl ACTION Processa( {||self:GridSeek( .t. ),self:oGrid:oBrowse:SetFocus()}, "Próximo..." ) PIXEL
		@ 000, 220 CHECKBOX self:oSeekChk VAR self:lSeekChk PROMPT "Contém" SIZE 028, 008 OF self:oSeekPnl PIXEL
		//----------------------------------------
		// ajusta a propriedade xSeekGet
		//----------------------------------------
		self:setSeekGet()


		self:oSeekPnl:Align := CONTROL_ALIGN_TOP
		self:oSeekCbx:Align := CONTROL_ALIGN_LEFT
		self:oSeekGet:Align := CONTROL_ALIGN_LEFT
		self:oSeekFirst:Align := CONTROL_ALIGN_LEFT
		self:oSeekNext:Align := CONTROL_ALIGN_LEFT

	endIf

	//-----------------------------
	// Se for MarkSet, não deixa
	// editar
	//-----------------------------
	If ::lIsMarkSet
		::nStyle  := 0
		//	::nFreeze := 1
		::oTik    := LoadBitmap( GetResources(), "LBTIK" )
		::oNo     := LoadBitmap( GetResources(), "LBNO"  )
	EndIf

	self:oGrid := MsNewGetDados():New(000, 000, self:nBottom, self:nRight, self:nStyle, self:cLinhaOk, self:cTudoOk, self:cIniCpos, self:aAlter, self:nFreeze, self:nMax, self:cFieldOk, ;
	self:cSuperDel, self:cDelOk, self:oPanel, self:aHeader, self:aCols, self:uChange, self:cTela)
	self:oBrowse := self:oGrid:oBrowse

	if self:lTimerChange
		self:SetChange({ || .T. })
	else
		self:setChange( self:bChange )
	endif

	self:oBrowse:bDelete := { || self:oGrid:DelLine(),  Eval(self:bAfterDel, self) }
	
	If self:lMarkSelected
		self:SetbBackColor({ || self:SelectRowColor() })
	EndIf

	self:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	if self:lTimerChange
		self:oTimerChange := TTimer():New(1000, {|| self:IniTimer(.T.) }, self:oPanel:OWND)
	endif

	If ::lIsMarkSet
		::SetDoubleClick( {|| ::Marca() } )
	EndIf
	
Return(Self)

Method SetAlignAllClient() Class AsGrid
	self:oPanel:Align := CONTROL_ALIGN_ALLCLIENT
	//self:oGrid:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
Return(Self)

Method SetAlignTop() Class AsGrid
	self:oPanel:Align := CONTROL_ALIGN_TOP
	//self:oGrid:oBrowse:Align := CONTROL_ALIGN_TOP
Return(Self)

Method SetAlignBottom() Class AsGrid
	self:oPanel:Align := CONTROL_ALIGN_BOTTOM
	//self:oGrid:oBrowse:Align := CONTROL_ALIGN_BOTTOM
Return(Self)

Method SetAlignLeft() Class AsGrid
	self:oPanel:Align := CONTROL_ALIGN_LEFT
	//self:oGrid:oBrowse:Align := CONTROL_ALIGN_LEFT
Return(Self)

Method SetAlignRight() Class AsGrid
	self:oPanel:Align := CONTROL_ALIGN_RIGHT
	//self:oGrid:oBrowse:Align := CONTROL_ALIGN_RIGHT
Return(Self)

Method SetDoubleClick(bCodeBlock) Class AsGrid
	self:oGrid:oBrowse:BlDblClick := bCodeBlock
Return(Self)

Method SetChange(bCodeBlock) Class AsGrid
	self:bChange := bCodeBlock
	if self:lTimerChange
		self:oGrid:bChange := { || self:IniTimer() } //bCodeBlock
	else
		self:oGrid:bChange :=  bCodeBlock //bCodeBlock
	endIf
Return(Self)

Method AddColBMP(cName, cBMPDefault, nPos, cTitle) Class AsGrid

	Default cTitle := " "
	nPos := 1

	If self:aHeader == Nil
		self:aHeader := {}
	EndIf

	If nPos > Len(self:aHeader)
		nPos := Len(self:aHeader)
	EndIf
	
	if empty( nPos )
		nPos := 1
	endif
	
	aSize(self:aHeader, Len(self:aHeader) + 1 )
	aIns(self:aHeader, nPos)

	self:aHeader[nPos] := { cTitle, cName, "@BMP", 3, 0, .F., "", "C", "", "V", "", "'" + cBMPDefault + "'", "", "V", "", "", ""}

	self:oHColBMP:put(nPos, cBMPDefault) //Armazena o Bitmap padrão para aquela coluna

	self:nUsado++
Return(Self)



Method Tree() Class AsGrid
	Local aFields  := {}
	Local cFile := Nil

	self:lTree := .T.

	aAdd(aFields, {"ID"        , "C", 10 , 0})
	aAdd(aFields, {"LEVEL "    , "N", 2  , 0})
	aAdd(aFields, {"IDPARENT"  , "C", 10 , 0})
	aAdd(aFields, {"STATUS"    , "N", 1  , 0})

	cFile := CriaTrab(aFields, .T.)

	self:cAliasTree := CriaTrab(Nil, .F.)
	DbUseArea(.T., "DBFCDX", cFile, self:cAliasTree, .F., .F.)

	self:cIndParent := CriaTrab(Nil , .F.)
	DbCreateIndex(self:cIndParent, "IDPARENT", {|| IDPARENT })

	self:cIndID     := CriaTrab(Nil , .F.)
	DbCreateIndex(self:cIndID, "ID", {|| ID })

	DbSetIndex(self:cIndParent)
	DbSetIndex(self:cIndID)

	Self:AddColBMP("TREE", "SHORTCUTPLUS", 1)
Return(Self)

Method AddChield(aInfo) Class AsGrid
	Self:AddLine(aInfo)
Return(Self)

Method GetAt() Class AsGrid
Return(self:oGrid:oBrowse:nAt)

Method SetArray(aCols) Class AsGrid

local nLoop
local cBmp

	//---------------------------------
	// Tratamento quando MarkSet()
	//---------------------------------

	If ::lIsMarkSet
		// Verifica se deve ou não trazer todas as colunas marcadas
		If ::lAllMark
			cBmp := "LBTIK"
		Else
			cBmp := "LBNO"
		EndIf

	EndIf

	If Empty( aCols )
		self:InitACols()
	Else
		self:aCols := aClone(aCols)
	EndIf

	If self:oGrid <> Nil


		If ::lIsMarkSet .and. ValType( aCols[1] ) == "A" .and. ::lCriaCol
			//----------------------------------------------------------
			// Verifica se todos os campos estão com o bitmap de marca
				//----------------------------------------------------------
			For nLoop := 1 to Len( aCols )
				//----------------------------------------------------------
				// Verifica se deve inserir a coluna de marca
				//----------------------------------------------------------
				If Len(aCols[nLoop]) <= Len( ::aHeader )
					//----------------------------------------------------------
					// Adiciona a coluna de marca
					//----------------------------------------------------------
					aSize( aCols[nLoop], Len(aCols[nLoop])+1 )
					aIns( aCols[nLoop], 1 )
					//----------------------------------------------------------
					// Adiciona o bitmap correto
					//----------------------------------------------------------
					aCols[nLoop,1] := cBmp
				EndIf
	
			Next nLoop
			self:aCols := aClone(aCols)
		EndIf
		self:oGrid:SetArray(self:aCols)
		self:nSelectRow := IIF(Empty(self:aCols), 0, 1)
		Self:Refresh()
	EndIf

Return(Self)

Method FromSql(cSql, lBmp) Class AsGrid
	Local aArea := GetArea()
	Local nCol       := 0, nPos := 0
	Local aVet       := {}
	Local aColsTMP   := {}
	Local cAlias     := CriaTrab(Nil, .F.)
	Local xVar       := Nil
	Local nIni       := 1

	Default lBmp := .T.

	TCQuery cSql New Alias &cAlias

	For nCol := 1 To Len(self:aHeader)
		If self:aHeader[nCol, 10] <> "V" .And. self:aHeader[nCol, 08] $ "D/N"
			TCSetField(cAlias, self:aHeader[nCol, 02], self:aHeader[nCol, 08], self:aHeader[nCol, 04], self:aHeader[nCol, 05])
		EndIf
	Next

	DbSelectArea(cAlias)

	If (cAlias)->(Eof()) //Se não retornar nada na query, carrega com uma linha em branco evitando erros
		aVet := Array(self:nUsado + 1)

		//---------------------------------
		// Tratamento quando MarkSet()
		//---------------------------------
		If ::lIsMarkSet .and. ::lCriaCol
			nIni := 2
			If ::lAllMark
				aVet[1] := "LBTIK"
			Else
				aVet[1] := "LBNO"
			EndIf
		EndIf

		For nCol := nIni To Len(self:aHeader)
			If (nPos := (cAlias)->(FieldPos(self:aHeader[nCol, X3CAMPO]))) > 0
				If self:aHeader[nCol, X3TIPO] == "C"
					xVar := Space( self:aHeader[nCol, X3TAMANHO] )
				ElseIf self:aHeader[nCol, X3TIPO] == "D"
					xVar := CTOD("  /  /  ")
				ElseIf self:aHeader[nCol, X3TIPO] == "N"
					xVar := 0
				Else
					xVar := Nil
				EndIf
				if ! empty( self:ogrid:aheader[nCol,X3RELACAO] )
					// Executa o inicializador padrão para a 1a linha
					aVet[nCol] := &(trim(self:ogrid:aheader[nCol,X3RELACAO]))
				else
					aVet[nCol] := xVar
				endif
				
			ElseIf lBmp //Verifica se deve carregar BMP Padrão
				If self:aHeader[nCol, X3PICTURE] == "@BMP" //Somente para colunas do tipo "BMP"
					aVet[nCol] := self:oHColBmp:getObj(nCol)
				EndIf
			EndIf
		Next nCol

		aVet[self:nUsado + 1] := .F.

		If self:lTree //Se utiliza árvore
			Self:AddColID(@aVet)
		EndIf

		aAdd(aColsTMP, aVet)

	Else

		While !(cAlias)->(Eof())
			aVet := Array(self:nUsado + 1)
	
			nIni := 1
			If ::lIsMarkSet .and. ::lCriaCol
				nIni := 2
				If ::lAllMark
					aVet[1] := "LBTIK"
				Else
					aVet[1] := "LBNO"
				EndIf
			EndIf
	
			For nCol := nIni To Len(self:aHeader)
				If (nPos := (cAlias)->(FieldPos(self:aHeader[nCol, X3CAMPO]))) > 0
					aVet[nCol] := (cAlias)->(&(Field(nPos)))
				ElseIf lBmp //Verifica se deve carregar BMP Padrão
					If self:aHeader[nCol, X3PICTURE] == "@BMP" //Somente para colunas do tipo "BMP"
						aVet[nCol] := self:oHColBmp:getObj(nCol)
					EndIf
				EndIf
			Next nCol
	
			aVet[self:nUsado + 1] := .F.
	
			If self:lTree //Se utiliza árvore
				Self:AddColID(@aVet)
			EndIf
	
			aAdd(aColsTMP, aVet)
	
			(cAlias)->(DbSkip())
		Enddo
	
	EndIf

	(cAlias)->(DbCloseArea())

	Self:SetArray(aColsTMP)
	Self:oGrid:GoBottom()
	Self:oGrid:GoTop()

	RestArea( aArea )
Return(Self)

Method Refresh() Class AsGrid
	If self:oGrid <> Nil .And. self:oGrid:oBrowse <> Nil
		self:oGrid:oBrowse:Refresh()
		self:oGrid:Refresh()
	EndIf
Return(Self)

Method GetLevel(nRow) Class AsGrid
	Local nLevel := 0

	Default nRow := Self:GetAt()

	DbSelectArea(self:cAliasTree)
	DbSetOrder(1)
	If DbSeek(Self:GetIDNode(nRow)) //Busca a linha no arquivo de índice da árvore
		nLevel := (self:cAliasTree)->LEVEL
	EndIf

Return(nLevel)

Method GetField(cField, nRow, lReadVar ) Class AsGrid
	
	PRIVATE n        := 1
	default nRow     := self:getAt()
	default lReadVar := .f.
	
	if lReadVar .and. readVar() == upper( "M->"+trim(cField) )
		if valType(&( readVar() )) == "U"
			lReadVar := .f.
		endif
	endif
	n := nRow
	xRet := GDFieldGet ( cField, nRow, lReadVar, self:oGrid:aHeader, self:oGrid:aCols )
	
Return(xRet)

Method AddTreeChields(aFieldCols, nRowParent) Class AsGrid
	Local nFor := 0
	Local nCurrent := 0
	Local cIDParent  := ""
	Local nNextLevel := 0

	Default nRowParent := Self:GetAt()

	cIDParent  := Self:GetNodeInfo("ID") //ID da linha "pai"
	nNextLevel := Self:GetNodeInfo("LEVEL") + 1//Incrmenta 1 no nivel para gravar nos "filhos"

	nCurrent := nRowParent + 1

	For nFor := 1 To Len(aFieldCols)
		//Aumenta a coluna do ID no array auxiliar
		Self:AddColID(aFieldCols[nFor], nNextLevel, cIDParent)

		//Aumenta espaço no aCols
		aSize(self:oGrid:aCols, Len(self:oGrid:aCols)+1)
		aIns(self:oGrid:aCols, nCurrent)
		self:oGrid:aCols[nCurrent] := aFieldCols[nFor]

	Next

	self:aCols := aClone(self:oGrid:aCols)

	Self:Refresh()

Return(Self)

Method SetField(cField, xValue, nRow) Class AsGrid
	Local nPosField := aScan(self:aHeader, {|aVet| AllTrim(aVet[2]) == AllTrim(cField)})
	Local xRet := Nil

	Default nRow := Self:GetAt()

	If nPosField > 0
		self:oGrid:aCols[nRow, nPosField] := xValue
	EndIf

	Self:Refresh()

Return(Self)

Method SetTreeStatus(nStatus, nRow) Class AsGrid

	Default nRow := Self:GetAt()

	Self:SetField("TREE", IIf(nStatus == STATUS_UNEXPANDED, "SHORTCUTPLUS", "SHORTCUTMINUS"))

	DbSelectArea(self:cAliasTree)
	DbSetOrder(1)//ID
	If DbSeek(Self:GetIDNode(nRow)) //Busca a linha no arquivo de índice da árvore
		RecLock(self:cAliasTree, .F.)
		(self:cAliasTree)->STATUS := nStatus
		MsUnlock()

	EndIf

Return(Self)

Method SetTreeExpanded(nRow) Class AsGrid

	Self:SetTreeStatus(STATUS_EXPANDED, nRow)

Return(Self)

Method SetTreeUnExpanded(nRow) Class AsGrid

	Self:SetTreeStatus(STATUS_UNEXPANDED, nRow)

Return(Self)

Method IsExpanded(nRow) Class AsGrid
	Local lRet := .T.

	Default nRow := Self:GetAt()

	DbSelectArea(self:cAliasTree)
	DbSetOrder(1)//ID
	If DbSeek(Self:GetIDNode(nRow)) //Busca a linha no arquivo de índice da árvore
		lRet := (self:cAliasTree)->STATUS == STATUS_EXPANDED
	EndIf

Return(lRet)

Method GetNodeInfo(cInfo, nRow) Class AsGrid
	Local xRet := Nil

	Default nRow := Self:GetAt()

	DbSelectArea(self:cAliasTree)
	DbSetOrder(1)//ID
	If DbSeek(Self:GetIDNode(nRow)) //Busca a linha no arquivo de índice da árvore
		xRet := (self:cAliasTree)->&(cInfo)
	EndIf

Return(xRet)

Method DelTreeChields(nRow) Class AsGrid
	Local cIDParent := ""
	Local nPosDel   := 0
	Local lDel      := .T.
	Local nRowDel   := 0
	Local nLevelIni := 0

	Default nRow := Self:GetAt()

	nRowDel := nRow + 1

	//Busca Nivel do registro pai
	DbSelectArea(self:cAliasTree)
	DbSetOrder(1)//ID
	If DbSeek(Self:GetIDNode(nRow))
		nLevelIni := (self:cAliasTree)->LEVEL
	EndIf

	//A idéia é excluir linhas até achar uma que seja do mesmo nível de onde veio o clique
	While lDel .And. nRowDel <= Len(self:oGrid:aCols)
		If Self:GetLevel(nRowDel) > nLevelIni
			Self:DelNodeInfo(nRowDel) //Exclui informações do arquivo

			//Ajusta aCols
			aDel(self:oGrid:aCols, nRowDel)
			aSize(self:oGrid:aCols, Len(self:oGrid:aCols)-1)

		Else
			lDel := .F.
		EndIf
	End

	Self:Refresh()

	Self:SetTreeUnExpanded()

Return(Self)

Method SaveNodeInfo(nLevel, cIDParent, nStatus) Class AsGrid

	Default nLevel    := 1
	Default cIdParent := Space(Len(self:cIdSeq))
	Default nStatus   := STATUS_UNEXPANDED

	self:cIdSeq := Soma1(self:cIdSeq)

	DbSelectArea(self:cAliasTree)
	RecLock(self:cAliasTree, .T.)
	(self:cAliasTree)->ID       := self:cIdSeq
	(self:cAliasTree)->LEVEL    := nLevel
	(self:cAliasTree)->IDPARENT := cIDParent
	(self:cAliasTree)->STATUS   := nStatus
	MsUnlock()
Return(self:cIdSeq)

Method DelNodeInfo(nRow) Class AsGrid

	DbSelectArea(self:cAliasTree)
	DbSetOrder(1)//ID
	If DbSeek(Self:GetIDNode(nRow))
		RecLock(self:cAliasTree, .F.)
		DbDelete()
		MsUnlock()
	EndIf

Return()

Method GetIDNode(nRow) Class AsGrid
	Default nRow := Self:GetAt()
Return(self:oGrid:aCols[nRow, self:nPosIDTree])

Method AddColID(aVet, nLevel, cIDParent) Class AsGrid

	Default nLevel := 1
	Default cIDParent := ""

	self:nPosIDTree := Len(self:aHeader)+1   //Armazena essa posição para facilitar
	aSize(aVet, Len(aVet)+1)        //Aumenta o tamanho da linha
	aIns(aVet, self:nPosIDTree)           //Insere um espaço em branco antes do deletado
	aVet[self:nPosIDTree] := Self:SaveNodeInfo(nLevel, cIDParent)   //Salva as informações		no temporário e armazena o ID na coluna

Return(Self)

Method GetRowID(cID) Class AsGrid
	Local nRow := 0

	Default cID := Self:GetIDNode()

	nRow := aScan(self:oGrid:aCols, {|aVet| aVet[self:nPosIDTree] == cID})

Return(nRow)

Method GetParentRowId(nBackLvl) Class AsGrid
	Local nRow := 0
	Local cId  := Self:GetIDNode()
	Local nI   := 1

	Default nBackLvl := 1

	For nI := 1 To nBackLvl
		cId := self:GetNodeInfo("IDPARENT", Self:GetRowID(cId))
	Next

	nRow := Self:GetRowID(cId)
Return(nRow)

Method GetParentField(cField, nBackLvl) Class AsGrid
	Local cRet := ""

	Default nBackLvl := 1

	cRet := Self:GetField(cField, Self:GetParentRowId(nBackLvl))
Return(cRet)

Method GetColHeader(cField) Class AsGrid
	Local nRet := 0

	nRet := aScan(self:aHeader, {|aVet| AllTrim(aVet[2]) == AllTrim(cField) })

Return(nRet)

Method Busca(xBusca, cField) Class AsGrid
	Local nRet := 0

	nRet := aScan(self:oGrid:aCols, {|aVet| AllTrim(aVet[Self:GetColHeader(cField)]) = AllTrim(xBusca) })

Return(nRet)

Method SetAt(nAt) Class AsGrid
	Self:oGrid:oBrowse:nAt := nAt
	self:nSelectRow := nAt
	Eval(self:bChange)
	self:Refresh()
Return(Self)

Method SetFocus() Class AsGrid
	self:oGrid:oBrowse:SetFocus()
Return(Self)

Method GetColPos() Class AsGrid
Return(self:oGrid:oBrowse:nColPos)

Method GotFocus(bAction) Class AsGrid
	self:oGrid:oBrowse:bGotFocus := bAction
Return()

Method LostFocus(bAction) Class AsGrid
	self:oGrid:oBrowse:bLostFocus := bAction
Return()

Method InitACols() Class AsGrid
	Local nI := 1
	Local aAux := {}, xValue := ""

	aAdd( aAux , {} )

	For nI := 1 To Len( self:aHeader )

		If Upper( self:aHeader[ nI,  03 ] ) == "@BMP" //Mascara
			xValue := self:aHeader[ nI,  12 ] //BMP
		ElseIf self:aHeader[ nI,  08 ] == "D" //Tipo
			xValue := CtoD("")
		ElseIf self:aHeader[ nI,  08 ] == "N" //Tipo
			xValue := 0
		Else
			xValue := Space( self:aHeader[ nI,  04 ] ) //Tamanho
		EndIf

		aAdd( aTail( aAux ) , xValue )

	Next

	aAdd( aTail( aAux ) , .F. )

	self:aCols := aClone( aAux )

Return( self )

method setSeek() class AsGrid
	self:lSetSeek := .t.
return(self)


User Function __AsGrid()
Return()

Method GridSeek( lNext ) Class AsGrid

Local xConteudo := self:xSeekGet
Local nPos      := if( self:oSeekCbx:nAt < 1, 1, self:oSeekCbx:nAt )
Local nCol      := Val( SubStr( self:aSeekItem[nPos],1,3 ) )
Local nRow      := self:GetAt()+1
Local nSeek     := 0
Local nTam      := 0
Local nLoop

ProcRegua(0)
IncProc()

If ValType( self:oGrid:aCols ) <> "A" .or. Empty( self:oGrid:aCols )
	MsgInfo("Grid vazio")
	Return(self)
EndIf

If ValType( xConteudo ) == "C"
	xConteudo := Trim(Upper(xConteudo))
	nTam      := Len(xConteudo)
EndIf

incProc( "Pesquisando " + if(lNext,"próximo registro","primeiro registro") )

if nTam > 0
	if ! self:lSeekChk
		nSeek := aScan( self:oGrid:aCols, {|x| Upper( SubStr( x[nCol],1,nTam ) ) == xConteudo }, if( lNext, nRow, 1 ) )
	else
		nSeek := aScan( self:oGrid:aCols, {|x| xConteudo $ trim(x[nCol])  }, if( lNext, nRow, 1 ) )
	endif
else
	nSeek := aScan( self:oGrid:aCols, {|x| x[nCol] == xConteudo } )
endIf

self:oGrid:oBrowse:lVisibleControl := .f.
If nSeek > 0
	self:oGrid:oBrowse:SetFocus()
	self:oGrid:Goto( nSeek )
Else
	MsgInfo("Registro não encontrado")
EndIf
eval( self:bChange )
self:oGrid:oBrowse:lVisibleControl := .t.
self:oGrid:oBrowse:SetFocus()

Return(self)

Method ItSeek() Class AsGrid

Local nLoop

self:aSeekItem := {}

For nLoop := 1 to Len( self:aHeader )
	If Empty( self:aHeader[nLoop,X3TITULO] )
		Loop
	EndIf
	If self:aHeader[nLoop,X3PICTURE] == "@BMP"
		Loop
	EndIf
	If self:aHeader[nLoop,X3TIPO] == "M"
		Loop
	EndIf
	AAdd( self:aSeekItem, StrZero(nLoop,3) + " " + self:aHeader[nLoop,X3TITULO] )
Next nLoop

If ValType( self:oSeekCbx ) == "O"
	self:oSeekCbx:SetItems( self:aSeekItem )
EndIf

Return(self)

Method setSeekGet() class AsGrid

	Local nPos       := if( self:oSeekCbx:nAt < 1, 1, self:oSeekCbx:nAt )
	Local nPosHeader := val( subStr( self:oSeekCbx:aItems[nPos],1,3 ) )

	//----------------------------------------
	// ajusta o valor da variavel de pesquisa
	//----------------------------------------
	do case
		case self:aHeader[nPosHeader,8] == "C"
			self:xSeekGet := space( self:aHeader[nPosHeader,4] )
		case self:aHeader[nPosHeader,8] == "N"
			self:xSeekGet := 0
		case self:aHeader[nPosHeader,8] == "D"
			self:xSeekGet := CtoD("")
		case self:aHeader[nPosHeader,8] == "L"
			self:xSeekGet := .t.
	endcase

	//----------------------------------------
	// ajusta a máscara do campo
	//----------------------------------------
	if ! empty( self:aHeader[nPosHeader,3] )
		self:oSeekGet:Picture := alltrim( self:aHeader[nPosHeader,3] )
	endif

	//----------------------------------------
	// ajusta o F3
	//----------------------------------------
	If ! Empty( self:aHeader[nPosHeader,9] )
		self:oSeekGet:cF3 := allTrim( self:aHeader[nPosHeader,9] )
	EndIf

	self:oSeekGet:ctrlRefresh()

Return ( .T. )

Method MarkSet( lAllMark, lCriaCol ) Class AsGrid

Default lAllMark := .f.
Default lCriaCol := .t.

::lIsMarkSet  := .t.
::lAllMark    := lAllMark
::lCriaCol    := lCriaCol


// Define se cria a coluna
if ::lCriaCol
	::AddColBMP("MARCA", IF(lAllMark,"LBTIK","LBNO"), 1, "   " )
endIf

Return(self)

Method Marca( lMark, nLineMark ) Class AsGrid

Local nLinha  := 0
Local cName   := ""

Default nLineMark := ::GetAt()

nLinha := nLineMark
cName  := ::oGrid:aCols[ nLinha, 1 ]

//--------------------------------------------------
// Força marcar ou desmarcar o campo
//--------------------------------------------------
If ValType( lMark ) == "L"
	If lMark
		cName := "LBNO"
	Else
		cName := "LBTIK"
	EndIf
EndIf

If cName == "LBTIK"
	::oGrid:aCols[nLinha,1] := "LBNO"
Else
	::oGrid:aCols[nLinha,1] := "LBTIK"
EndIf

//-----------------------------------------
// Executa uma rotina ao marcar/desmarcar
//-----------------------------------------
If ValType( ::bOnMark ) == "B"
	Eval( ::bOnMark )
EndIf

::oGrid:oBrowse:DrawSelect()

Return(self)

Method MarkAll( lMarca ) Class AsGrid

local nLoop := 1
local cBmp  := ""
default lMarca := .t.

if valtype(self:ogrid) <> "O" .or. valtype( self:aCols ) <> "A"
	return( self )
Endif

ProcRegua( len( ::oGrid:aCols ) )

cBmp := if( lMarca, "LBTIK", "LBNO" )
aEval( ::oGrid:aCols, {|x| IncProc(), x[1] := cBmp }  )
::oGrid:oBrowse:drawSelect()

Return( self )

Method OnMark( bOnMark ) Class AsGrid

::bOnMark := bOnMark

Return(self)

Method IsMarked( nLinha ) Class AsGrid

Local cName  := ""
Local lRet   := .f.

Default nLinha := if( ValType(nLinha) <> "N", ::GetAt(), nLinha )

cName := ::oGrid:aCols[ nLinha, 1 ]

If cName == "LBTIK"
	lRet := .t.
EndIf

Return( lRet )
