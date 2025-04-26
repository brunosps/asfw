#INCLUDE "Totvs.ch"

Static lSrvUnix := GetRemoteType() == 2
Static cBarra := IIF(lSrvUnix, "/", "\")

User Function AsLib012()
    Local aCols := {}

    AsIniEnv("99", "01", "FAT")

    oObj := ASXls2Csv():New( "c:\temp\sample.xlsx" )
    aCols := oObj:ToArray()
Return ( Nil )

Static Function AsIniEnv(_cEmp, _cFil, _cMod)
    RpcClearEnv()
    RpcSetEnv(_cEmp, _cFil,,,_cMod,GetEnvServer())

    InitPublic()
    SetsDefault()
    __cLogSiga := "NNNNNNNNNN"
Return(.T.)

Class ASXls2Csv From LongClassName
    Data cFile As String
    Data cFileName As String
    Data cDirName As String
    Data cRootPath As String
    Data cTempPath As String
    Data cInput As String
    Data cOutPut  As String
    Data cProgram As String
    Data cPathApp As String

    Method New( cFile ) Constructor
    Method CheckLib()
    Method CopyExe()
    Method CreateCsv(nWorkSheet, cChar)
    Method ToArray( nWorkSheet , cChar, nInitLin )

    Method SetFile(cFile)
EndClass

Method SetFile(cFile) Class ASXls2Csv
    self:cFile := cFile
Return(self)

Method New( cFile ) Class ASXls2Csv

    Default cFile := ""

    self:cFile := cFile
    self:cTempPath := GetTempPath(.T.)
    self:cRootPath := GetPVProfString(GetEnvServer(),"RootPath","", GetAdv97())

    self:cPathApp := Lower(GetClientDir())

    If SubStr(self:cRootPath, -1) <> cBarra
        self:cRootPath += cBarra
    EndIf

    self:cDirName  := "asxlsx2csv"
    self:cInput    := cBarra + "input"
    self:cOutPut   := cBarra + "output"
    self:cProgram  := "xlsx2csv" + iif(lSrvUnix, "", ".exe")
    self:CheckLib()
Return( self )

Method ToArray( nWorkSheet , cChar, nInitLin ) Class ASXls2Csv
    Local cLinha := ""
    Local nLin := 0
    Local aRet := {}
    Local aAux := {}
    Local nAux := 1

    Default nWorkSheet := 0
    Default cChar := ";"
    Default nInitLin := 1

    If !self:CreateCsv( nWorkSheet, cChar )
        Aviso("Atenção", "Não foi possivel criar arquivo csv.", {"OK"})
        Return( aRet )
    EndIf

    FT_FUSE( self:cFile )
    FT_FGOTOP()

    While ( !FT_FEOF() )
        nLin++

        If nLin >= nInitLin
            cLinha := FT_FREADLN()
            If !Empty(cLinha)
                If ValType( cLinha ) == "C"
                    cLinha := U_AsTrataStr( cLinha )
                    cLinha := StrTran( cLinha , cChar + cChar , cChar + " " + cChar )

                    aAux := StrToKArr2( cLinha , cChar , .T. )

                    For nAux := 1 To Len(aAux)
                        If SubStr(aAux[nAux], 1, 1) == "'"
                            aAux[nAux] := SubStr(aAux[nAux], 2)
                        EndIF
                    Next

                    aAdd( aRet, aAux )
                EndIf
            EndIf
        EndIf

        FT_FSKIP()
    EndDo
    FT_FUSE()
    FErase( self:cFile )
Return( aRet )

Method CreateCsv(nWorkSheet, cChar) Class ASXls2Csv
    Local cInputFile    := ""
    Local cCommandLine  := ""
    Local cDrive := "", cDiretorio := "", cNome := "", cExtensao := ""
    Local lCompress := .T.
    Local lChangeCase := .T.
    Local cDestFolder := (cBarra + self:cDirName + self:cOutPut)
    Local nRet := 0

    SplitPath( self:cFile, @cDrive, @cDiretorio, @cNome, @cExtensao )

    cInputFile := self:cFile

    self:cFileName := (cNome + ".csv")

    self:cFile := (self:cTempPath + self:cFileName)

    cCommandLine := '"' + (self:cPathApp + self:cProgram) + '"'
    // cCommandLine := (self:cPathApp + self:cProgram) // '"' + (self:cPathApp + self:cProgram) + '"'
    cCommandLine += ' -i ' + cValToChar(nWorkSheet) + ' -d "' + cChar + '" -o "' + self:cFile + '" "' + cInputFile + '" '

    If File( self:cFile )
        FErase( self:cFile )
    EndIf

    // nret := WaitRun('cmd.exe /C ' + cCommandLine, 1 )
    nRet := ShellExecute('open', '"' + self:cPathApp + self:cProgram + '"', ' -i ' + cValToChar(nWorkSheet) + ' -d "' + cChar + '" -o "' + self:cFile + '" "' + cInputFile + '" ', GetClientDir(), 1)

    Sleep(1000)
    
    If File( self:cFile )
        FErase(cDestFolder + cBarra + cNome + ".csv")
        CpyT2S( self:cFile, cDestFolder, lCompress, lChangeCase)
        self:cFile := cDestFolder + cBarra + cNome + ".csv"
    EndIf
Return( File(self:cFile) )

Method CheckLib() Class ASXls2Csv
    Local cLocalFile := (self:cPathApp + self:cProgram)

    If !ExistDir(cBarra + self:cDirName)
        FwMakeDir(cBarra + self:cDirName)
    EndIf

    If !ExistDir(cBarra + self:cDirName + self:cInput)
        FwMakeDir(cBarra + self:cDirName + self:cInput)
    EndIf

    If !ExistDir(cBarra + self:cDirName + self:cOutPut)
        FwMakeDir(cBarra + self:cDirName + self:cOutPut)
    EndIf

    If !File(cLocalFile)
        self:CopyExe()
    EndIf
Return( File(cLocalFile) )

Method CopyExe() Class ASXls2Csv
    Local lExistSrv := .T.
    Local cFile := ""

    If !File(cBarra + self:cDirName + cBarra + self:cProgram)
        cFile := cGetFile( "*",'Selecione o arquivo executável',1,"",.F.,GETF_LOCALHARD,.T.,.T.)
        lExistSrv := CpyT2S( cFile, cBarra + self:cDirName, .T., .T.)
    EndIf

Return( lExistSrv .And. CPYS2T(cBarra + self:cDirName + cBarra + self:cProgram, self:cPathApp) )
