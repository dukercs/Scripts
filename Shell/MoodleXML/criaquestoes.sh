#!/bin/bash
# Autor: rodolpho.stach(at)ipog(dot)edu(dot)br
# Função: Criar questões XML para importação no AVA (moodle)
# Funcionamento: ./criaquestao.sh responda as perguntas e será criado um arquivo questao_$QNUM.xml na pasta atual
# update: Alterada como fazer a leitura da questão para atribuir as tags <p> e </p> a cada linha copiada
#FIXME: Ainda precisa dar um enter após a última linha da questão para poder sair com CTRL+D

# Iniciando variáveis usadas nas alternativas
# Todas começam como incorretas valor 0 e será alterada apenas a correta por outra função abaixo.
AFRACAO=0
BFRACAO=0
CFRACAO=0
DFRACAO=0
EFRACAO=0

# Rodos os feedback são Incorreto e o valor para Correto é alterado ao indicar a alternativa certa
AFEED=Incorreto!
BFEED=Incorreto!
CFEED=Incorreto!
DFEED=Incorreto!
EFEED=Incorreto!



# Pede ao usuário para inserir os valores
read -p "Número da questão (QNUM): " QNUM
read -p "Nome da questão (QNOME): " QNOME

#read -p "Contexto da questão (CONTEXTO): " CONTEXTO
echo "Cole aqui a questão com todas as linhas antes das alternativas, depois dê um enter e finalize com CTRL+D para sair:"
CONTEXTO=""
while IFS= read -r linha; do
  CONTEXTO+="<p>$linha</p>"$'\n'
done

echo "Vamos cadastrar as alternativas e depois a alternativa correta."
#read -p "Fração da resposta A (AFRACAO): " AFRACAO
read -p "Texto da resposta A (ATEXTO): " ATEXTO
#read -p "Feedback da resposta A (AFEED): " AFEED

#read -p "Fração da resposta B (BFRACAO): " BFRACAO
read -p "Texto da resposta B (BTEXTO): " BTEXTO
#read -p "Feedback da resposta B (BFEED): " BFEED

#read -p "Fração da resposta C (CFRACAO): " CFRACAO
read -p "Texto da resposta C (CTEXTO): " CTEXTO
#read -p "Feedback da resposta C (CFEED): " CFEED

#read -p "Fração da resposta D (DFRACAO): " DFRACAO
read -p "Texto da resposta D (DTEXTO): " DTEXTO
#read -p "Feedback da resposta D (DFEED): " DFEED

#read -p "Fração da resposta E (EFRACAO): " EFRACAO
read -p "Texto da resposta E (ETEXTO): " ETEXTO
#read -p "Feedback da resposta E (EFEED): " EFEED

declare -u RESPOSTA
read -p "Alternativa correta: " RESPOSTA


case "${RESPOSTA:0:1}" in
	A|B|C|D|E)
		if [ "$RESPOSTA" == "A" ]
		then
			AFRACAO=100
			AFEED="Correto! Parabéns"
		elif [ "$RESPOSTA" == "B" ]
		then
			BFRACAO=100
			BFEED="Correto! Parabéns"
		elif [ "$RESPOSTA" == "C" ]
		then
			CFRACAO=100
			CFEED="Correto! Parabéns"
		elif [ "$RESPOSTA" == "D" ]
		then
			DFRACAO=100
			DFEED="Correto! Parabéns"
		elif [ "$RESPOSTA" == "E" ]
		then
			EFRACAO=100
			EFEED="Correto! Parabéns"
		fi
		;;
	*)
		echo "Informe uma alternativa entre A B C D ou E"
		exit 1
		;;
esac


NOMEARQUIVO="questao_${QNUM}_${QNOME}.xml"


# Substituir as variáveis no arquivo XML
cat <<EOF > "${NOMEARQUIVO// /_}"
<?xml version="1.0" encoding="UTF-8"?>
<quiz>
<question type="multichoice">
  <name>
    <text><![CDATA[${QNOME}]]></text>
  </name>
  <questiontext format="html">
    <text><![CDATA[${CONTEXTO}]]></text>
  </questiontext>
  <answer fraction="${AFRACAO}">
    <text><![CDATA[${ATEXTO}]]></text>
    <feedback>
      <text><![CDATA[${AFEED}]]></text>
    </feedback>
  </answer>
  <answer fraction="${BFRACAO}">
    <text><![CDATA[${BTEXTO}]]></text>
    <feedback>
      <text><![CDATA[${BFEED}]]></text>
    </feedback>
  </answer>
  <answer fraction="${CFRACAO}">
    <text><![CDATA[${CTEXTO}]]></text>
    <feedback>
      <text><![CDATA[${CFEED}]]></text>
    </feedback>
  </answer>
  <answer fraction="${DFRACAO}">
    <text><![CDATA[${DTEXTO}]]></text>
    <feedback>
      <text><![CDATA[${DFEED}]]></text>
    </feedback>
  </answer>
  <answer fraction="${EFRACAO}">
    <text><![CDATA[${ETEXTO}]]></text>
    <feedback>
      <text><![CDATA[${EFEED}]]></text>
    </feedback>
  </answer>
  <shuffleanswers>true</shuffleanswers>
  <single>true</single>
  <answernumbering>ABCD</answernumbering>
</question>
</quiz>
EOF

echo "Arquivo ${NOMEARQUIVO// /_} gerado com sucesso!"
