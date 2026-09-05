
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

User Function UXLS2XLSX()
	
Return( Nil )

Class UXls2XlsX From LongClassName
	
	Data cFile As String 
		
	Method New( cFile ) Constructor
	
	Method CopyExe()
	Method CreateXlsX()
	Method CheckLib()
		
EndClass

Method New( cFile ) Class UXls2XlsX

	self:cFile := cFile
	self:CheckLib()
	
Return( self )

Method CheckLib() Class UXls2XlsX
	Local cPathApp := Lower(GetClientDir())
	Local nI := 1 

	Local aFile := {}
	
	aAdd( aFile , 'xls2xlsx.exe' )
	
	For nI := 1 To Len( aFile )
		If !File( cPathApp + Lower( aFile[nI] ) )
			self:CopyExe( Lower( aFile[nI] ) )		
		EndIf
	Next
	
Return( self )

Method CreateXlsX() Class UXls2XlsX
	Local cPathApp := Lower(GetClientDir())
	Local cPathTemp := GetTempPath()
	Local cCommand := cPathApp + 'xls2xlsx.exe'
		
	WaitRun('cmd.exe /C ""' + cCommand + '" "' + StrTran( self:cFile , "/" , "\" ) + '"" ' , 0 )
				
Return( File( self:cFile + 'x' ) )

Method CopyExe( cProgram ) Class UXls2XlsX
	Local cPathApp := Lower(GetClientDir())
	Local lRet := .T.
	Local cFile := '/uxls2xlsx/' + cProgram
	
	If !CpyS2T( cFile, cPathApp )
		Aviso("Atenção",  "Erro ao copiar arquivo: " + cFile , {"OK"})
		Return( Nil )
	EndIf
	
Return( lRet )