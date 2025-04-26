
#INCLUDE "TOTVS.CH"

User Function AsGetFact(nRow, nCol, oParent, nWidth, nHeight, cReadVar, cType, aCbItems)
Return(AsGetFact():New(nRow, nCol, oParent, nWidth, nHeight, cReadVar, cType, aCbItems))

Class AsGetFact From LongClassName
	data oGet as Object 
	data cType as String 
	
	method new(nRow, nCol, oParent, nWidth, nHeight, cReadVar, cType, aCbItems, oOpt) Constructor 
    
	//method SetCbItems(aCbItems)
	method SetAlign(nAlign)	
	method GetObj()  
	method Refresh()
		
EndClass         

method SetAlign(nAlign) class AsGetFact
	self:oGet:align := nAlign
	self:oGet:Refresh()
return(self)        

method Refresh() class AsGetFact
	self:oGet:Refresh()
Return(self)

method new(nRow, nCol, oParent, nWidth, nHeight, cReadVar, cType, aCbItems, oOpt) class AsGetFact    
	Local lPixel := .T.
	Local bSetGet := "{|u| Iif(Pcount() > 0, "+cReadVar+" := u, "+cReadVar+")}"	    
	
	Default oOpt := AsHash():New()
			            
	If cType == "M"                
		//TMultiGet 
		oOpt:AddUnless("oFont"     , Nil)
		oOpt:AddUnless("lHScroll"  , .F.)
		oOpt:AddUnless("lPixel"    , .F.)
		oOpt:AddUnless("bWhen"     , { || .T. })
		oOpt:AddUnless("lReadOnly" , .F.)
		oOpt:AddUnless("bValid"    , { || .T. } )
		oOpt:AddUnless("lNoBorder" , .F.)
		oOpt:AddUnless("lVScroll"  , .T.)
		
		self:oGet := TMultiGet():New(nRow     , nCol   , &bSetGet  , oParent, nWidth   , nHeight   , oOpt:GetObj("oFont"), oOpt:GetObj("lHScroll"),           ,            ,            , oOpt:GetObj("lPixel"),            ,            , oOpt:GetObj("bWhen"),            ,            , oOpt:GetObj("lReadOnly") , oOpt:GetObj("bValid"),            ,            , oOpt:GetObj("lNoBorder"), oOpt:GetObj("lVScroll"))
		           //TMultiGet():New( [ nRow ],[ nCol ],[ bSetGet ],[ oWnd ],[ nWidth ],[ nHeight ], [ oFont ]           , [ uParam8 ]            , [uParam9 ], [uParam10 ], [uParam11 ], [ lPixel ]           , [uParam13 ], [uParam14 ], [ bWhen ]           , [uParam16 ], [uParam17 ], [ lReadOnly ]            , [bValid ]            , [ uParam20], [ uParam21], [ lNoBorder ]           , [ lVScroll ]             , [ cLabelText ], [ nLabelPos ], [ oLabelFont ], [ nLabelColor ] )

		//::oGetCVARIABLE := cReadVar
		self:cType := "M"
	ElseIf !Empty(aCbItems)
		//TComboBox                                     
		If ValType(aCbItems) == "C"
			aCbItems := StrTokArr(aCbItems, ";")
		EndIf                
		oOpt:AddUnless("bValid"   , { || .T. })  
		//oOpt:AddUnless("nClrFore" , CLR_BLACK)
		//oOpt:AddUnless("nClrBack" , CLR_WHITE)
		oOpt:AddUnless("oFont"    , Nil)
		oOpt:AddUnless("lPixel"   , .T.)
		oOpt:AddUnless("bWhen"    , Nil)
		oOpt:AddUnless("bChange"  , Nil)
    			
  		//           TComboBox():New(  [ nRow], [ nCol], [ bSetGet], [ nItens], [ nWidth], [ nHeight]                           , [ oWnd], [ uParam8], [ bChange]                     , [ bValid], [ nClrBack]            , [ nClrText]            , [ lPixel]            , [ oFont]            , [ uParam15], [ uParam16], [ bWhen], [ uParam18], [ uParam19], [ uParam20], [ uParam21], [ cReadVar] ) 
		
		//&(cReadVar) := IIF(Empty(&(cReadVar)), aCbItems[1], &(cReadVar))
		::oGet := TComboBox():New(nRow     , nCol   , &bSetGet                             , aCbItems , nWidth   , nHeight   , oParent,           ,                                ,          , , , oOpt:GetObj("lPixel"), oOpt:GetObj("oFont"),            ,            ,      oOpt:GetObj("bWhen")   ,            ,            ,            ,            , cReadVar)
		//           TComboBox():New(02       , 02     ,{|u|if(PCount()>0,cCombo1:=u,cCombo1)}, aItems   ,100       ,      20   ,  oDlg  ,           ,{||Alert('Mudou item da combo')},          ,                        ,                        , .T.                  ,                     ,            ,            ,         ,            ,            ,            ,            ,'cCombo1')
		::oGet:Refresh()
		::cType := "C"
	Else
		oOpt:AddUnless("cF3"      , "")	
		oOpt:AddUnless("cPict"    , "")
		oOpt:AddUnless("bValid"   , { || .T. })  
		//oOpt:AddUnless("nClrFore" , CLR_BLACK)
		//oOpt:AddUnless("nClrBack" , CLR_WHITE)
		oOpt:AddUnless("oFont"    , Nil)
		oOpt:AddUnless("lPixel"   , .T.)
		oOpt:AddUnless("bWhen"    , { || .T. })
		oOpt:AddUnless("bChange"  , Nil)
		oOpt:AddUnless("lReadOnly", .F.)
		oOpt:AddUnless("lPassword", .F.)
		//TGet         
		//           TGet():New([ nRow], [ nCol], [ bSetGet], [ oWnd], [ nWidth], [ nHeight], [ cPict]            , [ bValid]            , [ nClrFore]            , [ nClrBack]            , [ oFont]            , [ uParam12], [ uParam13], [ lPixel]            , [ uParam15], [ uParam16], [ bWhen]            , [ uParam18], [ uParam19], [ bChange]            , [ lReadOnly]            , [ lPassword]            , [ uParam23], [ cReadVar], [ uParam25], [ uParam26], [ uParam27], [ lHasButton], [ lNoButton] )
		::oGet := TGet():New(nRow   , nCol   , &bSetGet  , oParent, nWidth   , nHeight   , oOpt:GetObj("cPict"), oOpt:GetObj("bValid"), , , oOpt:GetObj("oFont"),            ,            , oOpt:GetObj("lPixel"),            ,            , oOpt:GetObj("bWhen"),            ,            , oOpt:GetObj("bChange"), oOpt:GetObj("lReadOnly"), oOpt:GetObj("lPassword"),            , cReadVar) 
		//           TGet():New([ nRow], [ nCol], [ bSetGet], [ oWnd], [ nWidth], [ nHeight], [ cPict]            , [ bValid]     , [ nClrFore], [ nClrBack], [ oFont], [ uParam12], [ uParam13], [ lPixel], [ uParam15], [ uParam16], [ bWhen], [ uParam18], [ uParam19], [ bChange], [ lReadOnly], [ lPassword], [ uParam23], [ cReadVar], [ uParam25], [ uParam26], [ uParam27], [ lHasButton], [ lNoButton], [cLabelText] ,[nLabelPos], [oLabelFont], [nLabelColor], [cPlaceHold] )		
		If !Empty(oOpt:GetObj("cF3"))
			::oGet:cF3 := oOpt:GetObj("cF3")
		EndIf
		::cType := "G"		
	EndIf
	oOpt:AddUnless("lEnable", .T.)    
	::oGet:lActive := oOpt:GetObj("lEnable")
	::oGet:Refresh()
	
return(::GetObj())           

method GetObj() class AsGetFact 
return(self:oGet)