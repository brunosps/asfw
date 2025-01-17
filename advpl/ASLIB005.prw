	
#INCLUDE "TOTVS.CH"
#INCLUDE "TRYEXCEPTION.CH"
#INCLUDE "TOPCONN.CH"

User Function AsBrowse()
	Local oBrowse := AsBrowse():New("SB1", "Cadastro de Produtos")
	
	Private oMemo := Nil, cMemo := ""
	
	oBrowse:SetMenuDef("MATA010")
	
	oBrowse:AddColSx3("B1_COD"):AddColSx3("B1_DESC")

	oBrowse:AddLegend("B1_TIPO == 'ME'", "BR_VERDE", "Mercadoria")
	oBrowse:AddLegend("B1_TIPO <> 'ME'", "BR_AZUL" , "Não Mercadoria")
				
	oBrowse:SetDescription( "Cadastro de Produtos" )
	
	oBrowse:SetBChange({ || AtuRodaPe() })

	oBrowse:SetBPnlDetails({ |oOwner| Detalhes(oOwner) })
	
	oBrowse:Activate()
Return(Nil)

Static Function Detalhes(oOwner)
	@ 001, 001 GET oMemo VAR cMemo MEMO SIZE 150, 060 OF oOwner PIXEL
	oMemo:Align := CONTROL_ALIGN_ALLCLIENT
	oMemo:lReadOnly := .T.
Return(Nil)

Static Function AtuRodaPe()
	cMemo := SB1->B1_DESC
	oMemo:Refresh()
Return(Nil)

Class AsBrowse From LongClassName

	Data cAlias As String 
	Data cDescription As String 
	Data oDlg As Object 

	Data oBrowse As Object
	Data aColumns As Array
	Data aHeader As Array
	Data bChange
	Data bPnlFilter
	Data bPnlDetails
	
	Data WPnlFil As Integer
	Data HPnlFil As Integer
	Data WPnlDet As Integer
	Data HPnlDet As Integer
	
	Data lMark As Boolean

	Data oTimerChange As Object
	Data nLastChange As Integer
	Data nLastReg As Integer

	Data bInit 
						
	Method New(cAlias, cDescription) Constructor
	Method SetDescription(cDescription)
	Method SETMENUDEF(cMenudef)
	Method Activate(OOWNER)
	
	Method AddColSx3(cFieldSX3, cTitulo, cCampo, cPicture, nTamanho, nDecimal, nAlign)
	Method ArrColSx3(cAlias, cFieldSX3, cTitulo, cCampo, cPicture, nTamanho, nDecimal, nAlign)
	Method ConfigColumns()
	Method AddLegend(cCond, cColor, cTitle)
	Method SetbChange(bChange)
	Method SetbPnlFilter(bPnlFilter)
	Method SetbPnlDetails(bPnlDetails)
	
	METHOD SetFilterDefault(cFilter)

	Method SetWPnlDet(nHeight)
	Method SetHPnlDet(nWeight)

	Method SetWPnlFil(nWeight)
	Method SetHPnlFil(nHeight)

	Method AddStatusColumns(bMeth, bView, cTitle)
	Method SetbBackColor(bColor)
	Method SetBlkColor(bColor)
	Method SetBLineOk(bLineOk)
	
	Method Refresh()
	Method GoTo(nReg)
	
	Method ExecChange()
	
	Method AddFilter(cFilter,  cExpAdvPL,  lNoCheck,  lSelected,  cAlias,  lFilterAsk,  aFilParser,  cID)

	Method OnInit()
	Method SetBInit(bInit)
	Method SetMainProc(cMainProc)
	Method SetCacheView(lCacheView)

	Method SetChgAll(lChange)
	Method SetSeeAll(lSee)

EndClass

Method SetChgAll(lChange) Class AsBrowse
	self:oBrowse:SetChgAll(lChange)
Return(self)

Method SetSeeAll(lSee) Class AsBrowse
	self:oBrowse:SetSeeAll(lSee)
Return(self)

Method SetCacheView(lCacheView) Class AsBrowse
	self:oBrowse:SetCacheView(lCacheView)
Return(self)

Method SetMainProc(cMainProc) Class AsBrowse
	self:oBrowse:SetMainProc(cMainProc)
Return(self)

Method SetBInit(bInit)  Class AsBrowse
	self:bInit := bInit
Return(self)

Method OnInit(oDlg)  Class AsBrowse

	Eval(self:bInit, oDlg)

Return(self)

Method AddFilter(cFilter,  cExpAdvPL,  lNoCheck,  lSelected,  cAlias,  lFilterAsk,  aFilParser,  cID) Class AsBrowse
	self:oBrowse:AddFilter(cFilter,  cExpAdvPL,  lNoCheck,  lSelected,  cAlias,  lFilterAsk,  aFilParser,  cID)
Return(self)

Method GoTo(nReg) Class AsBrowse
	self:oBrowse:GoTo(nReg)
Return(self)

Method Refresh() Class AsBrowse
	self:oBrowse:Refresh()
Return(self)

Method New(cAlias, cDescription) Class AsBrowse
	
	Default cDescription := ""
	
	self:oBrowse := FWMBrowse():New()
	self:oBrowse:oData := FWBrwTable():New()//UBrwTable():New()
	self:oBrowse:SetAlias( cAlias )	
	
	self:SetDescription( cDescription )
	
	self:oBrowse:DisableDetails()
	
	self:cAlias := cAlias
	//self:cDescription := cDescription
	self:aColumns := {}
	self:aHeader := {}
	self:bChange := Nil
	self:bPnlFilter := Nil
	self:bPnlDetails := Nil

	self:WPnlFil := 018
	self:HPnlFil := 018	
		
	self:WPnlDet := 100
	self:HPnlDet := 100	
	
	self:lMark := .F.

	self:nLastChange := Seconds()		
	self:nLastReg := 0
	self:bInit := { |oDlg| .T. }
Return(self)

Method SetWPnlDet(nWeight) Class AsBrowse
	self:WPnlDet := nWeight
Return(Self)

Method SetHPnlDet(nHeight) Class AsBrowse
	self:HPnlDet := nHeight
Return(Self)

Method SetWPnlFil(nWeight) Class AsBrowse
	self:WPnlFil := nWeight
Return(Self)

Method SetHPnlFil(nHeight) Class AsBrowse
	self:HPnlFil := nHeight
Return(Self)     

Method AddStatusColumns(bMeth, bView, cTitle) Class AsBrowse
	Local nPos := 1
		
	self:oBrowse:AddStatusColumns(bMeth, bView)
	
	If !self:lMark
		nPos := Len(self:oBrowse:aColumns)
			
		If !Empty(cTitle)		
			self:oBrowse:aColumns[nPos]:SetTitle(cTitle)
		EndIf
	Else
		nPos := Len(self:oBrowse:oBrowse:aColumns)
		
		If !Empty(cTitle)		
			self:oBrowse:oBrowse:aColumns[nPos]:SetTitle(cTitle)
		EndIf	
	EndIf
	
Return(Self)

Method SetBlkColor(bColor) class AsBrowse
	self:oBrowse:SetBlkColor(bColor)
Return(Self)

Method SetbBackColor(bColor) class AsBrowse
	self:oBrowse:SetBlkBackColor(bColor)
Return(Self)

Method SetBLineOk(bLineOk) class AsBrowse
	If !self:lMark
		self:oBrowse:bLineOK := bLineOk
	Else
		self:oBrowse:oBrowse:bLineOK := bLineOk
	EndIf
Return(Self)

Method SETMENUDEF(cMenudef) Class AsBrowse
	self:oBrowse:SETMENUDEF(cMenudef)
Return(Self)

Method SetDescription(cDescription) Class AsBrowse
	Local cCssLabel := ""

	//cCssLabel := 'QLabel { color:                 #0049bf;}'
	cCssLabel := 'QLabel { color:                 #000000;}'
	cCssLabel += 'QLabel { background-color:	#FFFFFF; }'
	cCssLabel += 'QLabel { font-size:                  17px;}'
	cCssLabel += 'QLabel { font-weight:                bold;}'
	cCssLabel += 'QLabel { padding-left:               10px; }'
	cCssLabel += 'QLabel { padding-top:                10px; }'
	cCssLabel += 'QLabel { padding-bottom:             02px; }'
	//cCssLabel += 'QLabel { border: 1px solid #0049bf; }'
	//cCssLabel += 'QLabel { border-radius: 3px; }'
	
	self:cDescription := cDescription
		
    If !self:lMark
        If self:oBrowse:OBROWSEUI <> Nil .And. self:oBrowse:OBROWSEUI:OTITLEBAR <> Nil
            self:oBrowse:OBROWSEUI:OTITLEBAR:cCaption := self:cDescription			
            self:oBrowse:OBROWSEUI:OTITLEBAR:SetCss( cCssLabel )
        EndIf
    Else
        If self:oBrowse:oBrowse:OBROWSEUI <> Nil .And. self:oBrowse:oBrowse:OBROWSEUI:OTITLEBAR <> Nil
            self:oBrowse:oBrowse:OBROWSEUI:OTITLEBAR:cCaption := self:cDescription			
            self:oBrowse:oBrowse:OBROWSEUI:OTITLEBAR:SetCss( cCssLabel )			
        EndIf		
    EndIf

Return(Self)

Method Activate(oOwner) Class AsBrowse
	Local aArea := GetArea()
	Local aSize := MsAdvSize(.T.)
	Local oLayer := Nil
	Local oBrowse := Nil
	Local oDlg := Nil
	
	If oOwner == Nil
		Define MsDialog oDlg TITLE '' From aSize[7], 000 TO aSize[6], aSize[5] STYLE nOr(WS_VISIBLE,WS_POPUP) Of oMainWnd Pixel
	Else
		oDlg := oOwner
	EndIf
			
	self:oBrowse:Activate(oDlg)
		
	self:ConfigColumns()
	
	If self:bChange <> Nil	
		If !self:lMark
			//self:oBrowse:bChange := self:bChange
			self:oBrowse:bChange := { || self:ExecChange() } 	
			self:oTimerChange := TTimer():New(1000, {|| self:ExecChange(.T.) }, self:oBrowse:OBROWSEUI:OGRID:oWnd)
		Else
			//self:oBrowse:oBrowse:bChange := self:bChange
			self:oBrowse:oBrowse:bChange := { || self:ExecChange() } 	
			self:oTimerChange := TTimer():New(1000, {|| self:ExecChange(.T.) }, self:oBrowse:oBrowse:OBROWSEUI:OGRID:oWnd)			
		EndIf
	EndIf
	
	If self:bPnlFilter <> Nil
		oPnlTop := 	IIF(!self:lMark, self:oBrowse:OBROWSEUI:OGRID:OPARENT, self:oBrowse:oBrowse:OBROWSEUI:OGRID:OPARENT)

		oPnlTop := tPanel():New(000, 000,"", oPnlTop,,,,,/* Rgb(245, 245, 205) */, self:WPnlFil, self:HPnlFil)		
		
		oPnlTop:Align := CONTROL_ALIGN_TOP
						
		Eval(self:bPnlFilter, oPnlTop)
	EndIf

	If self:bPnlDetails <> Nil		
		oPnlDet := 	IIF(!self:lMark, self:oBrowse:OBROWSEUI:OGRID:OPARENT, self:oBrowse:oBrowse:OBROWSEUI:OGRID:OPARENT)
		oPnlDet := tPanel():New(000, 000,"", oPnlDet,,,,,Rgb(245, 245, 245), self:WPnlDet, self:HPnlDet)
		oPnlDet:Align := CONTROL_ALIGN_BOTTOM

		Eval(self:bPnlDetails, oPnlDet)
	EndIf
	
	self:oDlg := oDlg
		
	//Ajusta Mark
	If self:lMark		
		self:oBrowse:OBROWSE:ACOLUMNS[1]:BLDBLCLICK := { || self:MarkRec() }
		self:oBrowse:OBROWSE:BCUSTOMLDBLCLICK := { || self:MarkRec() }
	EndIf
	
	If !Empty(self:cDescription)	
		self:SetDescription( self:cDescription )
	EndIf
					
	If oOwner == Nil		
		oBrowse := self		
		Activate MsDialog oDlg On Init (oBrowse:OnInit(self), oBrowse:oBrowse:OnChange())
	EndIf
			
	RestArea(aArea)
Return(Self)

Method ExecChange(lTimer) Class AsBrowse
	Local nSeconds := Seconds()	
	
	Default lTimer := .F.
	
	If lTimer .Or. nSeconds - self:nLastChange > 0.7
			
		If self:nLastReg <> (self:cAlias)->(RecNo())
			Eval(self:bChange)
			self:nLastReg := (self:cAlias)->(RecNo())
		EndIf

		self:oTimerChange:DeActivate()
	Else
		self:oTimerChange:DeActivate()	
		self:oTimerChange:Activate()	
	EndIf
	
	self:nLastChange := nSeconds			
Return(Self)

Method AddColSx3(cFieldSX3, cTitulo, cCampo, cPicture, nTamanho, nDecimal, nAlign) Class AsBrowse
	Local cAlias := PADL(SubStr(cFieldSX3, 1, aT("_",cFieldSX3)-1), 3, "S")
	Local aColumn := self:ArrColSx3(cAlias, cFieldSX3, cTitulo, cCampo, cPicture, nTamanho, nDecimal, nAlign)
	
	aAdd(self:aHeader , cFieldSX3 )
	aAdd(self:aColumns, aColumn )
	//self:oBrowse:SetColumns({ aColumn })
		
Return(Self)

Method ArrColSx3(cAlias, cFieldSX3, cTitulo, cCampo, cPicture, nTamanho, nDecimal, nAlign) Class AsBrowse
	Local aArea   := GetArea()
	Local aAreaX3 := SX3->(GetArea())
	Local aColumn := {}
	
	Local bData := Nil
	
	cCampo := IIF(cCampo <> Nil, cCampo, cFieldSX3)

	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	
	If !SX3->( DbSeek(cFieldSX3) )
		Return(.F.)
	EndIf
	
	If SX3->X3_CONTEXT == 'V'
		bData := "{ || " + AllTrim(SX3->X3_INIBRW) + " }"						
	ElseIf SX3->X3_TIPO == "D" 
		If u_AsExists({{"T", cAlias}})
			bData := "{ || DtoC(" + cCampo + ")}"
		Else
			bData := "{ || DtoC(StoD(" + cCampo + ")) }"			
		EndIf
	Else
		bData := "{ || " + cCampo + " } "
	EndIf
	
	If cTitulo == Nil
		cTitulo := Alltrim(SX3->( X3Titulo() ))
	EndIf
	
	If cPicture == Nil
		cPicture := Alltrim(SX3->( X3_PICTURE ))
	EndIf
			
	If nTamanho == Nil
		nTamanho := SX3->( X3_TAMANHO )  * 0.6
		If SX3->X3_TIPO == "N"
			nTamanho := SX3->( X3_TAMANHO ) * 0.5
		ElseIf SX3->X3_TIPO == "D"
			nTamanho := 10
		ElseIf SX3->X3_TIPO == "C"			
			If nTamanho > 80
				nTamanho := 80
			ElseIf nTamanho < 5
				nTamanho := 5
			EndIf
		EndIf		
	EndIf

	If nDecimal == Nil
		nDecimal := SX3->( X3_DECIMAL )
	EndIf
	
	If nAlign == Nil
		If SX3->X3_TIPO == "N"
			nAlign := 2
		EndIf
	EndIf
	
    /*
	[n][01] Título da coluna
	[n][02] Code-Block de carga dos dados
	[n][03] Tipo de dados
	[n][04] Máscara
	[n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
	[n][06] Tamanho
	[n][07] Decimal
	[n][08] Indica se permite a edição
	[n][09] Code-Block de validação da coluna após a edição
	[n][10] Indica se exibe imagem
	[n][11] Code-Block de execução do duplo clique
	[n][12] Variável a ser utilizada na edição (ReadVar)
	[n][13] Code-Block de execução do clique no header
	[n][14] Indica se a coluna está deletada
	[n][15] Indica se a coluna será exibida nos detalhes do Browse
	[n][16] Opções de carga dos dados (Ex: 1=Sim, 2=Não)
	[n][17] Id da coluna

	[n][18] Indica se a coluna é virtual
	*/	
	aAdd(aColumn, cTitulo)//1
	aAdd(aColumn, &bData)//2
	aAdd(aColumn, SX3->X3_TIPO)//3
	aAdd(aColumn, cPicture)//4
	aAdd(aColumn, nAlign)//5
	aAdd(aColumn, nTamanho)//6
	aAdd(aColumn, nDecimal)//7
	aAdd(aColumn, Nil)//8
	aAdd(aColumn, Nil)//9
	aAdd(aColumn, Nil)//10
	aAdd(aColumn, Nil)//11
	aAdd(aColumn, AllTrim(SX3->X3_CAMPO))//12
	If self:lMark
		aAdd(aColumn, { || self:oBrowse:oBrowse:ORDERCOLUMN() })//13
	Else
		aAdd(aColumn, { || self:oBrowse:ORDERCOLUMN() })//13
	EndIf
	
	aAdd(aColumn, Nil)//14
	aAdd(aColumn, Nil)//15

	If SubStr(SX3->(X3Cbox()),1,1) == '#'
		aAdd(aColumn, StrToKArr(AllTrim(&(SubStr(SX3->(X3Cbox()),1,1))), ";"))//16
	Else
		aAdd(aColumn, StrToKArr(AllTrim(SX3->(X3CBOX())), ";"))//16
	EndIf	

	RestArea(aAreaX3)
	RestArea(aArea)
Return(aColumn)

Method ConfigColumns() Class AsBrowse
	Local aArea    := GetArea()
	Local aAreaX3  := SX3->(GetArea())

	Local aImgCol  := {}

	Local nSeq     := 1
	Local nI       := 1
	Local nLenCol  := 0
	Local cAlias   := IIF(self:lMark, self:oBrowse:oBrowse:cAlias, self:oBrowse:cAlias)
	Local aColsBrw := IIF(self:lMark, self:oBrowse:oBrowse:aColumns, self:oBrowse:aColumns)
	Local lSaveConfig := IIF(self:lMark, self:oBrowse:oBrowse:lSaveConfig, self:oBrowse:lSaveConfig)
	Local aHeadBrw := aClone(self:aHeader)
	Local nPosBrw  := 0, lHeadBrw := .T.
	Local lProf := .F. 
	Local cAviso := "", cErro := ""
	Local aProfile := {}
	Local nColumn := 1
		
	If !Empty(self:aColumns)
		
		nLenCol := Len(aColsBrw)
		
		For nColumn := 1 To nLenCol
			If self:lMark
				self:oBrowse:oBrowse:DelColumn(nColumn)
				If self:oBrowse:oBrowse:oBrowse <> Nil
					self:oBrowse:oBrowse:oBrowse:RemoveColumn(nColumn)
				EndIf
			Else
				self:oBrowse:DelColumn(nColumn)
				If self:oBrowse:oBrowse <> Nil
					self:oBrowse:oBrowse:RemoveColumn(nColumn)
				EndIf
			EndIf
			
			If aColsBrw[nColumn]:lImage 
				aAdd(aImgCol, {})
				
                aAdd(aTail(aImgCol) , aColsBrw[nColumn]:cTitle)
                aAdd(aTail(aImgCol) , aColsBrw[nColumn]:bData)
                aAdd(aTail(aImgCol) , aColsBrw[nColumn]:CTYPE)
                aAdd(aTail(aImgCol) , aColsBrw[nColumn]:XPICTURE)
                aAdd(aTail(aImgCol) , aColsBrw[nColumn]:NALIGN)
                aAdd(aTail(aImgCol) , aColsBrw[nColumn]:NSIZE)
                aAdd(aTail(aImgCol) , aColsBrw[nColumn]:NDECIMAL)
                aAdd(aTail(aImgCol) , aColsBrw[nColumn]:LEDIT)
                aAdd(aTail(aImgCol) , aColsBrw[nColumn]:BVALID)
                aAdd(aTail(aImgCol) , aColsBrw[nColumn]:LIMAGE)
                aAdd(aTail(aImgCol) , aColsBrw[nColumn]:BLDBLCLICK)
                aAdd(aTail(aImgCol) , aColsBrw[nColumn]:CREADVAR)
                aAdd(aTail(aImgCol) , aColsBrw[nColumn]:BHEADERCLICK)
				
			EndIf
			
		Next 
		
		If self:lMark 		
			self:oBrowse:oBrowse:aColumns := {}
		Else
			self:oBrowse:aColumns := {}
		EndIf
		
		For nI := 1 To Len(aImgCol)
			If self:lMark
				self:oBrowse:oBrowse:AddColumn(aImgCol[nI])
			Else
				self:oBrowse:AddColumn(aImgCol[nI])			
			EndIf
		Next
				
		If VerSenha(114) .And. !Empty(xFilial(cAlias))
			If self:lMark
				self:oBrowse:oBrowse:AddColumn(self:ArrColSx3(cAlias, PrefixoCpo(cAlias) + "_FILIAL"))			
			Else			
				self:oBrowse:AddColumn(self:ArrColSx3(cAlias, PrefixoCpo(cAlias) + "_FILIAL"))			
			EndIf
		EndIf
			
		For nI := 1 To Len(self:aColumns)
			If self:lMark
				self:oBrowse:oBrowse:AddColumn(self:aColumns[nI])
			Else			
				self:oBrowse:AddColumn(self:aColumns[nI])
			EndIf
		Next
	EndIf
	
	self:oBrowse:Refresh()
	
	RestArea(aAreaX3)
	RestArea(aArea)	
Return(.T.)

Method AddLegend(cCond, cColor, cTitle) Class AsBrowse
	self:oBrowse:AddLegend(cCond, cColor, cTitle)
Return(Self)

Method SetbChange(bChange) Class AsBrowse
	self:bChange := bChange
Return(self)

Method SetbPnlFilter(bPnlFilter) Class AsBrowse
	self:bPnlFilter := bPnlFilter
Return(self)

Method SetbPnlDetails(bPnlDetails) Class AsBrowse
	self:bPnlDetails := bPnlDetails
Return(self)

METHOD SetFilterDefault(cFiltro) CLASS AsBrowse
RETURN(SELF:OBROWSE:SetFilterDefault(cFiltro))
