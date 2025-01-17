
#INCLUDE "TOTVS.CH"

Static lBlind := IsBlind()

User Function AsLib011()

Return(Nil)

Class ASCEP

    Data cUrl As String

    Data cCEP As String
    Data cLOGRADOURO As String
    Data cCOMPLEMENTO As String
    Data cBAIRRO As String
    Data cLOCALIDADE As String
    Data cUF As String
    Data cIBGE As String

    Method New() Constructor

    Method BuscaCep(cCep)
    Method BuscaCidade(cEstado, cCidade, cLogradouro)

    Method BuscaCC2(cEstado, cCidade)

    Method BuscaCC2ByCodMun(cCodMun, cEstado)

    Method Reset()
EndClass

Method New() Class ASCEP
    self:cUrl := "http://viacep.com.br/ws/"
Return(self)

Method Reset() Class ASCEP
    self:cCEP := ""
    self:cLOGRADOURO := ""
    self:cCOMPLEMENTO := ""
    self:cBAIRRO := ""
    self:cLOCALIDADE := ""
    self:cUF := ""
    self:cIBGE := ""
Return(self)

Method BuscaCep(cCep) Class ASCEP
    Local lRet := .F.
    Local cJson := ""

    Private oJson := Nil

    Self:Reset()

    cCep := StrTran(cCep, "-", "")

    cJson := Httpget(self:cUrl + cCep + "/json", , 10)

    If ValType(cJson) <> "U"
        oJson := U_JsonObj(DecodeUtf8(cJson))

        If !Empty(oJson) .And. Type("oJson:erro") == "U"
            lRet := .T.
            self:cCEP := oJson:CEP
            self:cLOGRADOURO := oJson:LOGRADOURO
            self:cCOMPLEMENTO := oJson:COMPLEMENTO
            self:cBAIRRO := oJson:BAIRRO
            self:cLOCALIDADE := oJson:LOCALIDADE
            self:cUF := oJson:UF
            self:cIBGE := oJson:IBGE
        Else
            If lBlind
                ConOut("Web Service de consulta fora do ar ou Cidade não encontrado.")
            Else
                MsgAlert("Web Service de consulta fora do ar ou Cidade não encontrado.")
            EndIf
        EndIf
    Else
        If lBlind
            ConOut("Erro ao consultar CEP." + cCep)
        Else
            MsgAlert("Erro ao consultar CEP." + cCep)
        EndIf
    EndIf

Return(lRet)

Method BuscaCidade(cEstado, cCidade, cLogradouro) Class ASCEP
    Local lRet := .F.
    Local oJson := Nil, cJson := ""

    Default cLogradouro := "brasil"

    Self:Reset()

    If At(",", cLogradouro) > 0
        cLogradouro := SubStr(cLogradouro, 1, At(",", cLogradouro) - 1)
    EndIf

    cJson := Httpget(self:cUrl + cEstado + "/" + AllTrim(cCidade) +"/" + AllTrim(cLogradouro) + "/json", , 10)

    oJson := U_JsonObj(cJson)

    If !Empty(oJson)
        lRet := .T.
        self:cCEP := oJson[1]:CEP
        self:cLOGRADOURO := oJson[1]:LOGRADOURO
        self:cCOMPLEMENTO := oJson[1]:COMPLEMENTO
        self:cBAIRRO := oJson[1]:BAIRRO
        self:cLOCALIDADE := oJson[1]:LOCALIDADE
        self:cUF := oJson[1]:UF
        self:cIBGE := oJson[1]:IBGE
    Else
        If lBlind
            ConOut("Web Service de consulta fora do ar ou Cidade não encontrado.")
        Else
            MsgAlert("Web Service de consulta fora do ar ou Cidade não encontrado.")
        EndIf
    EndIf

Return(lRet)

Method BuscaCC2(cEstado, cCidade) Class ASCEP
    Local lRet := .F.
    Local cSql := ""
    Local cAliasQry := GetNextAlias()

    Self:Reset()
    cSql += "SELECT CC2_CODMUN, CC2_MUN "
    cSql += "  FROM " + RetSQLName("CC2") + " CC2 "
    cSql += " WHERE CC2.CC2_FILIAL = '" + xFilial("CC2") + "' AND D_E_L_E_T_ <> '*' "
    cSql += "   AND CC2_EST = '" + cEstado + "' "
    cSql += "   AND CC2_MUN = '" + U_ASApostro(cCidade) + "' "

    __ExecSql(cAliasQry, cSql, {}, .F.)

    If (cAliasQry)->( !Eof() )
        lRet := .T.
        self:cLOCALIDADE := AllTrim( (cAliasQry)->CC2_MUN )
        self:cIBGE := (cAliasQry)->CC2_CODMUN
    EndIf

    (cAliasQry)->( DbCloseArea() )

Return(lRet)

Method BuscaCC2ByCodMun(cCodMun, cEstado) Class ASCEP
    Local lRet := .F.
    Local cSql := ""
    Local cAliasQry := GetNextAlias()

    Self:Reset()
    cSql += "SELECT CC2_CODMUN, CC2_MUN "
    cSql += "  FROM " + RetSQLName("CC2") + " CC2 "
    cSql += " WHERE CC2.CC2_FILIAL = '" + xFilial("CC2") + "' AND D_E_L_E_T_ <> '*' "
    cSql += "   AND CC2_CODMUN = '" + cCodMun + "' "
    cSql += "   AND CC2_EST = '" + cEstado + "' "

    __ExecSql(cAliasQry, cSql, {}, .F.)

    If (cAliasQry)->( !Eof() )
        lRet := .T.
        self:cLOCALIDADE := AllTrim( (cAliasQry)->CC2_MUN )
        self:cIBGE := (cAliasQry)->CC2_CODMUN
    EndIf

    (cAliasQry)->( DbCloseArea() )

Return(lRet)
