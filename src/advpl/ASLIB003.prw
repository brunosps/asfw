
#INCLUDE "TOTVS.CH"

User Function ASLIB003()

Return(Nil)

Class AsCssStyle From LongClassName	
	Method New() Constructor
	Method PnlCss(cClass)
	Method BtnCss(cClass)
	
	Method ComboCss(cClass)
	
EndClass

Method New() Class AsCssStyle
Return( self )

Method ComboCss(cClass) Class AsCssStyle
	cCombo := "QComboBox { font-size: 12px }"
	cCombo += "QComboBox { color: #2462a6 }"
	cCombo += "QComboBox { background-color: #ffffff }"
	cCombo += "QComboBox { min-height: 17px }"
	cCombo += "QComboBox { min-height: 17px }"
	cCombo += "QComboBox { padding-left: 3px }"
	cCombo += "QComboBox { border-style: solid }"
	cCombo += "QComboBox { border-width: 1px }"
	cCombo += "QComboBox { border-color: #2462A6 }"
	cCombo += "QComboBox:hover { color: #ffffff }"
	cCombo += "QComboBox:hover { border-style: solid }"
	cCombo += "QComboBox:hover { border-width: 2px }"
	cCombo += "QComboBox:focus { color: #ffffff }"
	cCombo += "QComboBox:focus { border-style: solid }"
	cCombo += "QComboBox:focus { border-width: 2px }"
	cCombo += "QComboBox::down-arrow{ image: url( rpo:fw_arrow_down.png);}"
	cCombo += "QComboBox::down-arrow:pressed { image: url( rpo:fw_arrow_right.png);}"
	cCombo += "QComboBox::drop-down{ subcontrol-origin:padding; }"
	cCombo += "QComboBox::drop-down{ subcontrol-position:top right; }"
	cCombo += "QComboBox::drop-down{ width:17px; }"
	cCombo += "QComboBox::drop-down{ border-left-width:0px; }"
	cCombo += "QComboBox::drop-down{ border-top-right-radius:0px; }"
	cCombo += "QComboBox::drop-down{ border-bottom-right-radius:0px; }"
	cCombo += "QComboBox QListView{ color: #2462a6;}"
	cCombo += "QComboBox QListView{    border-width: 1px; border-style: flat; }"
Return(cCombo)

Method PnlCss(cClass) Class AsCssStyle
	Local cCssPnl := ""
	
	If Upper( cClass ) == "LIGHTGRAY"
		cCssPnl := 'QLabel { color:                 #000000;}'
		cCssPnl += 'QLabel { background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #efefef, stop: 1 #ffffff  ); }'
		cCssPnl += 'QLabel { border: 1px solid #c1c1c1; }'
		//cCssPnl += 'QLabel { padding:           5px 3px 2px 5px; }'
		//cCssPnl += 'QLabel { margin-left:              5px; }'
		//cCssPnl += 'QLabel { margin-top:               2px; }'
		//cCssPnl += 'QLabel { margin-bottom:            2px; }'
	ElseIf Upper( cClass ) == "LIGHTBLUE"
		cCssPnl := 'QLabel { color:                 #000000;}'
		cCssPnl += 'QLabel { background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #ccd8ff, stop: 1 #edf1ff  ); }'
		cCssPnl += 'QLabel { border: 1px solid #3884ff; }'
		//cCssPnl += 'QLabel { padding:           5px 3px 2px 5px; }'
		
		//cCssPnl += 'QLabel { margin-left:              5px; }'
		//cCssPnl += 'QLabel { margin-top:               2px; }'		
		//cCssPnl += 'QLabel { margin-bottom:            2px; }'
	ElseIf Upper( cClass ) == "LEGAL"
		cCssPnl := 'QLabel { color:                 #000000;}'
		cCssPnl += 'QLabel { background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #ccd8ff, stop: 1 #edf1ff  ); }'
		cCssPnl += 'QLabel { border: 1px solid #3884ff; }'
		cCssPnl += 'QLabel { font-size: 08px }'
		//cCssPnl += 'QLabel { padding:           5px 3px 2px 5px; }'
		
		//cCssPnl += 'QLabel { margin-left:              5px; }'
		//cCssPnl += 'QLabel { margin-top:               2px; }'		
		//cCssPnl += 'QLabel { margin-bottom:            2px; }'
	EndIf
	
Return(cCssPnl) 

Method BtnCss(cClass) Class AsCssStyle
	Local cCss := ""
	
	Do Case
		Case	Upper( cClass ) == 'TBTNPRIMARY'
		
			cCSS := 'QPushButton			{ font-family:		Verdana         ; }'
			cCSS += 'QPushButton			{ font-size:		09px            ; }'
			cCSS += 'QPushButton			{ border-width:		1px             ; }' 
			cCSS += 'QPushButton			{ border-style:		Solid           ; }' 
			cCSS += 'QPushButton			{ border-color:		#777777         ; }'
    		cCSS += 'QPushButton			{ border-radius:	3px             ; }'
    		cCSS += 'QPushButton			{ color:	#FFFFFF             ; }'    		
    		cCSS += 'QPushButton			{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #92B5D4, stop: 1 #3071A9 ); }'
    		cCSS += 'QPushButton			{ min-width:			20px            ; }'
			cCSS += 'QPushButton			{ margin:				5px 7px 02px 06px; }'
			cCSS += 'QPushButton			{ padding:				5px 7px 02px 06px; }'			
			cCSS += 'QPushButton:pressed	{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #3071A9, stop: 1 #92B5D4 ); }'			
			cCSS += 'QPushButton:disabled { background-color:           #BCBCBC; }'
			cCSS += 'QPushButton:disabled { color:                      #FFFFFF; }'


		Case	Upper( cClass ) == 'TBTNDANGER'
		
			cCSS := 'QPushButton			{ font-family:		Verdana         ; }'
			cCSS += 'QPushButton			{ font-size:		09px            ; }'
			cCSS += 'QPushButton			{ border-width:		1px             ; }' 
			cCSS += 'QPushButton			{ border-style:		Solid           ; }' 
			cCSS += 'QPushButton			{ border-color:		#777777         ; }'
    		cCSS += 'QPushButton			{ border-radius:	3px             ; }'
    		cCSS += 'QPushButton			{ color:	#FFFFFF             ; }'    
    		cCSS += 'QPushButton			{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #E37B78, stop: 1 #C9302C ); }'
    		cCSS += 'QPushButton			{ min-width:			20px            ; }'
			cCSS += 'QPushButton			{ margin:				5px 7px 02px 06px; }'
			cCSS += 'QPushButton			{ padding:				5px 7px 02px 06px; }'			
			cCSS += 'QPushButton:pressed	{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #C9302C, stop: 1 #E37B78 ); }'						
			cCSS += 'QPushButton:disabled { background-color:           #BCBCBC; }'
			cCSS += 'QPushButton:disabled { color:                      #FFFFFF; }'
		Case	Upper( cClass ) == 'TBTNSUCCESS'
		
			cCSS := 'QPushButton			{ font-family:		Verdana         ; }'
			cCSS += 'QPushButton			{ font-size:		09px            ; }'
			cCSS += 'QPushButton			{ border-width:		1px             ; }' 
			cCSS += 'QPushButton			{ border-style:		Solid           ; }' 
			cCSS += 'QPushButton			{ border-color:		#777777         ; }'
    		cCSS += 'QPushButton			{ border-radius:	3px             ; }'
    		cCSS += 'QPushButton			{ color:	#FFFFFF             ; }'                                  
    		cCSS += 'QPushButton			{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #8BC98B, stop: 1 #449D44 ); }'
    		cCSS += 'QPushButton			{ min-width:			20px            ; }'
			cCSS += 'QPushButton			{ margin:				5px 7px 02px 06px; }'
			cCSS += 'QPushButton			{ padding:				5px 7px 02px 06px; }'			
			cCSS += 'QPushButton:pressed	{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #449D44, stop: 1 #8BC98B ); }'						

		Case	Upper( cClass ) == 'TBTNDEFAULT'
		
			cCSS := 'QPushButton			{ font-family:		Verdana         ; }'
			cCSS += 'QPushButton			{ font-size:		09px            ; }'
			cCSS += 'QPushButton			{ border-width:		1px             ; }' 
			cCSS += 'QPushButton			{ border-style:		Solid           ; }' 
			cCSS += 'QPushButton			{ border-color:		#777777         ; }'
    		cCSS += 'QPushButton			{ border-radius:	3px             ; }'
    		cCSS += 'QPushButton			{ color:	#000000             ; }'    
    		cCSS += 'QPushButton			{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #FFFFFF, stop: 1 #F0F0F0 ); }'
    		cCSS += 'QPushButton			{ min-width:			20px            ; }'
			cCSS += 'QPushButton			{ margin:				5px 7px 02px 06px; }'
			cCSS += 'QPushButton			{ padding:				5px 7px 02px 06px; }'			
			cCSS += 'QPushButton:pressed	{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #F0F0F0, stop: 1 #FFFFFF ); }'						

		Case	Upper( cClass ) == 'TBTNINFO'
		
			cCSS := 'QPushButton			{ font-family:		Verdana         ; }'
			cCSS += 'QPushButton			{ font-size:		09px            ; }'
			cCSS += 'QPushButton			{ border-width:		1px             ; }' 
			cCSS += 'QPushButton			{ border-style:		Solid           ; }' 
			cCSS += 'QPushButton			{ border-color:		#777777         ; }'
    		cCSS += 'QPushButton			{ border-radius:	3px             ; }'
    		cCSS += 'QPushButton			{ color:	#FFFFFF             ; }'        		                                                                                                                  
    		cCSS += 'QPushButton			{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #9ECFDE, stop: 1 #5bc0de ); }'
    		cCSS += 'QPushButton			{ min-width:			20px            ; }'
			cCSS += 'QPushButton			{ margin:				5px 7px 02px 06px; }'
			cCSS += 'QPushButton			{ padding:				5px 7px 02px 06px; }'			
			cCSS += 'QPushButton:pressed	{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #5bc0de, stop: 1 #9ECFDE ); }'						
		Case	Upper( cClass ) == 'TBTNWARNING'
		
			cCSS := 'QPushButton			{ font-family:		Verdana         ; }'
			cCSS += 'QPushButton			{ font-size:		09px            ; }'
			cCSS += 'QPushButton			{ border-width:		1px             ; }' 
			cCSS += 'QPushButton			{ border-style:		Solid           ; }' 
			cCSS += 'QPushButton			{ border-color:		#777777         ; }'
    		cCSS += 'QPushButton			{ border-radius:	3px             ; }'
    		cCSS += 'QPushButton			{ color:	#FFFFFF             ; }'        		                                                                                                                  
    		cCSS += 'QPushButton			{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #EDC893, stop: 1 #F0AD4E ); }'
    		cCSS += 'QPushButton			{ min-width:			20px            ; }'
			cCSS += 'QPushButton			{ margin:				5px 7px 02px 06px; }'
			cCSS += 'QPushButton			{ padding:				5px 7px 02px 06px; }'			
			cCSS += 'QPushButton:pressed	{ background-color:	qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #F0AD4E, stop: 1 #EDC893 ); }'						
	EndCase
	
Return(cCss)