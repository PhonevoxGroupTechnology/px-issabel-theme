#!/bin/bash
clear
echo "Iniciando instalador..."

echo ""


art () {
	local asciiart="$1"
	local IFS=$'\n'
	for line in $asciiart; do
		echo "$line"
	done
	echo ""
	echo ""
}



art "          ###                      #######                                                                              
     ###########                  (#######                                                                              
    ########,  #                  (#######                                               %%%(                           
    ########        ########      (#######       ######                            %%%%%%%%%%%%%%%                      
################ ###############  (#######   ##############. ########     ########%%%           %%%%########  ########  
 ############### ####    ######## (####### (#######   ####### #######    ########%%               %%%%###############   
    ########       ############## (####### ################### #######  ,#######%%/                %%%%############     
    ########    ################# (####### ################### .####### #######%%%%  (             %%%% ###########     
    ########   #######    ####### (####### #######              ############## %%%%   %       %   %%%%(#############    
    ########   ################## (#######  ################     ############   %%%%%.           %%%%######## ########  
    ########    ################# (#######     #############      ##########      %%%%%%%%%  %%%%%%*#######    ######## 
                                                                                      %%%%%%%%%                         "


# DECLARAÇÃO DE VARIÁVEIS <------------------>
CURRDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILENAME_TIMESTAMP=$(date '+%Y-%m-%d-%H%M%S') # 0000-11-22-334455
LOG_TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')    # 0000-11-22 33:44:55

PATH_MAINSTYLECSS="/var/www/html/modules/pbxadmin/themes/default/css"
PATH_FAVICON="/var/www/html"
PATH_ISSABELTHEME="/var/www/html/themes"

# PASTA DE BACKUP PARA ESTA INSTALAÇÃO
BKPFOLDER_NAME="bkp" # Nome (prefixo) pra pasta de backup. "bkp-0000-11-22-334455"
BKPFOLDER="$BKPFOLDER_NAME-$FILENAME_TIMESTAMP"
PATH_BKPFOLDER="$CURRDIR/$BKPFOLDER"

# LOGGING
LOGFILE_NAME="themeinstaller" # Nome (prefixo) pro arquivo de log. "log-0000-11-22.log"
LOGFILE="$LOGFILE_NAME-$(date '+%Y-%m-%d').log"
if ! [ -f "$LOGFILE" ]; then # checa se o arquivo de log já existe
        echo -e "[$LOG_TIMESTAMP] Iniciando novo logfile" > $LOGFILE
fi

# DECLARAÇÃO DE FUNÇÕES ÚTEIS <--------------------->
log() {
echo -e "[$LOG_TIMESTAMP] $1" >> $LOGFILE
echo -e "[$LOG_TIMESTAMP] $1"
}

# -------------------------------------------------------- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Debug

# Checa se diretório existe. Retorna true/false
dExists() {
        [ -d "$1" ]
}

# Checa se file existe. Retorna true/false
fExists() {
        [ -f "$1" ]
}

# Função para validar um diretório
validarDir() {
    local dir_var="$1"  # Recebe o nome da variável a ser validada

    if [ -d "${!dir_var}" ]; then
        eval "${dir_var}_EXISTS=true"
    else
        eval "${dir_var}_EXISTS=false"
    fi
}

# Função para validar um diretório
validarFile() {
    local file_var="$1"  # Recebe o nome da variável a ser validada

    if [ -f "${!file_var}" ]; then
        eval "${file_var}_EXISTS=true"
    else
        eval "${file_var}_EXISTS=false"
    fi
}

colorir() {
  local cor=$(echo "$1" | tr '[:upper:]' '[:lower:]')
  local texto=$2

  # Definir códigos de cores ANSI
  local cor_preto="\\\e[0;30m"
  local cor_vermelho="\\\e[0;31m"
  local cor_verde="\\\e[0;32m"
  local cor_amarelo="\\\e[0;33m"
  local cor_azul="\\\e[0;34m"
  local cor_magenta="\\\e[0;35m"
  local cor_ciano="\\\e[0;36m"
  local cor_branco="\\\e[0;37m"
  local cor_preto_claro="\\\e[1;30m"
  local cor_vermelho_claro="\\\e[1;31m"
  local cor_verde_claro="\\\e[1;32m"
  local cor_amarelo_claro="\\\e[1;33m"
  local cor_azul_claro="\\\e[1;34m"
  local cor_magenta_claro="\\\e[1;35m"
  local cor_ciano_claro="\\\e[1;36m"
  local cor_branco_claro="\\\e[1;37m"
  local cor_reset="\\\e[0m"

  # Verificar a cor selecionada e atribuir o código ANSI correspondente
  case "$cor" in
    "preto")
      cor_ansi=$cor_preto
      ;;
    "vermelho")
      cor_ansi=$cor_vermelho
      ;;
    "verde")
      cor_ansi=$cor_verde
      ;;
    "amarelo")
      cor_ansi=$cor_amarelo
      ;;
    "azul")
      cor_ansi=$cor_azul
      ;;
    "magenta")
      cor_ansi=$cor_magenta
      ;;
    "ciano")
      cor_ansi=$cor_ciano
      ;;
    "branco")
      cor_ansi=$cor_branco
      ;;
    "preto_claro")
      cor_ansi=$cor_preto_claro
      ;;
    "vermelho_claro")
      cor_ansi=$cor_vermelho_claro
      ;;
    "verde_claro")
      cor_ansi=$cor_verde_claro
      ;;
    "amarelo_claro")
      cor_ansi=$cor_amarelo_claro
      ;;
    "azul_claro")
      cor_ansi=$cor_azul_claro
      ;;
    "magenta_claro")
      cor_ansi=$cor_magenta_claro
      ;;
    "ciano_claro")
      cor_ansi=$cor_ciano_claro
      ;;
    "branco_claro")
      cor_ansi=$cor_branco_claro
      ;;
    *)
      cor_ansi=$cor_reset
      ;;
  esac

  # Imprimir o texto com a cor selecionada
  echo -e "${cor_ansi}${texto}${cor_reset}"
}

# INICIO DO SCRIPT <-------------------------->

# Setando flags
# Validando se já tem uma pasta de BKP; preciso garantir que não exista para eu poder fazer o backup seguramente.
validarDir "PATH_BKPFOLDER"        # nesse momento, deve retornar false

# Validando se os diretórios-destino existem
validarDir "PATH_MAINSTYLECSS"     # nesse momento, deve retornar true (o path até o mainstyle.css existe)
validarDir "PATH_FAVICON"          # nesse momento, deve retornar true (o path até os favicons existem (/var/www/html))
validarDir "PATH_ISSABELTHEME"     # nesse momento, deve retornar true (o path até os temas existem na central)

# Validando se os arquivos SCP foram transferidos.
SCP_MAINSTYLECSS="$CURRDIR/mainstyle.css"
SCP_FAVICON="$CURRDIR/favicon.ico"
SCP_FALEVOXTHEME="$CURRDIR/falevox"
validarFile "SCP_MAINSTYLECSS"     # nesse momento, deve retornar true (acabei de passar via scp)
validarFile "SCP_FAVICON"          # nesse momento, deve retornar true (acabei de passar via scp)
validarDir "SCP_FALEVOXTHEME"      # nesse momento, deve retornar true (acabei de passar via scp)

# Validando se já não tem um tema do Falevox
if $PATH_ISSABELTHEME_EXISTS; then
    # Caminho até a pasta de temas existe, agora vou verificar se o tema já existe.

    if dExists "$PATH_ISSABELTHEME/falevox"; then
        # O tema já existe, preciso perguntar se quer sobreescrever ou cancelar.
        while true; do
            echo "O tema 'falevox' já existe ('$PATH_ISSABELTHEME/falevox')."
            echo "O que você deseja fazer?"
            echo "1. Reescrever a pasta"
            echo "2. Utilizar a pasta existente"
            echo "3. Cancelar"

            read escolha

            case "$escolha" in
                1)
                    echo "A pasta será reescrita."
                    echo ""
                    OLD_EXISTS=true
                    USE_OLD_THEME=false
                    break  # Sai do loop e continua o script
                    ;;
                2)
                    echo "A pasta será utilizada."
                    echo ""
                    OLD_EXISTS=true
                    USE_OLD_THEME=true
                    break  # Sai do loop e continua o script
                    ;;
                3)
                    echo "Abortando."
                    exit 0  # Sai do script com código de saída 0
                    ;;
                *)
                    echo "Opção inválida. Por favor, escolha uma opção válida (1, 2 ou 3)."
                    echo ""
                    ;;
            esac
        done
    else
        # O tema não existe, posso prosseguir normalmente.
        OLD_EXISTS=false
        USE_OLD_THEME=false
    fi
else
    log "[CRITICAL] Parece que a pasta de temas ($PATH_ISSABELTHEME) não existe. Finalizando o script por aqui."
    echo "Erro: O diretório essencial não foi encontrado em '$PATH_ISSABELTHEME'."
    exit 1
    # O caminho até a pasta de temas não existe. Algum problema muito maior pode estar acontecendo, então é bom avisar e cancelar por aqui.
fi


# Verificando o MAINSTYLE.CSS atualmente em uso
CURRENT_MAINSTYLECSS="$PATH_MAINSTYLECSS/mainstyle.css"
validarFile "CURRENT_MAINSTYLECSS" # nesse momento, deve retornar true

# Verificando o FAVICON atualmente em uso
CURRENT_FAVICON="$PATH_FAVICON/favicon.ico"
validarFile "CURRENT_FAVICON" # nesse momento, deve retornar true

# <------------ Exibindo o resultado das checagens ao usuário ------------>

expectTrue() {
    local var_name="$1"
    local message_success="$2"
    local message_fail="$3"
    local needs_stop="$4"
    if eval "[[ \${$var_name} == true ]]"; then
        log "$message_success"
    else
        log "$message_fail"
	if $needs_stop; then
		log "-- Setando finalização de sessão devido à valor inesperado em : $1 --"
        	END_SESSION=true
	else
	:
	fi
    fi
}

expectFalse() {
    local var_name="$1"
    local message_success="$2"
    local message_fail="$3"
    local needs_stop="$4"
    if eval "[[ \${$var_name} != true ]]"; then
        log "$message_success"
    else
        log "$message_fail"
	if $needs_stop; then
		log "-- Setando finalização de sessão devido à valor inesperado em : $1 --"
        	END_SESSION=true
	else
	:
	fi
    fi
}

OK_TAG="[  $(colorir "verde" "OK")  ]"
ERR_TAG="[ $(colorir "vermelho" "ERRO") ]"

expectFalse "PATH_BKPFOLDER_EXISTS" \
"$OK_TAG PATH_BKPFOLDER" \
"$ERR_TAG PATH_BKPFOLDER $(colorir "amarelo_claro" "-> A pasta para backup já existe.")" \
"true"

expectTrue "PATH_MAINSTYLECSS_EXISTS" \
"$OK_TAG PATH_MAINSTYLECSS" \
"$ERR_TAG PATH_MAINSTYLECSS $(colorir "amarelo_claro" "-> O diretório do mainstyle.css do Issabel não existe.")" \
"true"

expectTrue "PATH_FAVICON_EXISTS" \
"$OK_TAG PATH_FAVICON" \
"$ERR_TAG PATH_FAVICON $(colorir "amarelo_claro" "-> O diretório do favicon.ico do Issabel não existe.")" \
"true"

expectTrue "PATH_ISSABELTHEME_EXISTS" \
"$OK_TAG PATH_ISSABELTHEME" \
"$ERR_TAG PATH_ISSABELTHEME $(colorir "amarelo_claro" "-> O diretório do tema do Issabel não existe.")" \
"true"

expectTrue "SCP_MAINSTYLECSS_EXISTS" \
"$OK_TAG SCP_MAINSTYLECSS" \
"$ERR_TAG SCP_MAINSTYLECSS $(colorir "amarelo_claro" "-> O mainstyle.css puxado do SCP não está aqui?")" \
"true"

expectTrue "SCP_FAVICON_EXISTS" \
"$OK_TAG SCP_FAVICON" \
"$ERR_TAG SCP_FAVICON $(colorir "amarelo_claro" "-> O favicon.ico puxado do SCP não está aqui?")" \
"true"

expectTrue "SCP_FALEVOXTHEME_EXISTS" \
"$OK_TAG SCP_FALEVOXTHEME" \
"$ERR_TAG SCP_FALEVOXTHEME $(colorir "amarelo_claro" "-> A pasta com o tema FALEVOX puxado do SCP não está aqui?")" \
"true" 

log "$OK_TAG USAR TEMA ANTIGO $(colorir "amarelo_claro" "-> $USE_OLD_THEME")"

expectTrue "CURRENT_MAINSTYLECSS_EXISTS" \
"$OK_TAG CURRENT_MAINSTYLECSS" \
"$OK_TAG CURRENT_MAINSTYLECSS $(colorir "amarelo_claro" "-> OBS: O arquivo de mainstyle.css do Issabel não existe. Seu Issabel deve estar quebrado..")" \
"false" # Precisa que encerre a sessao, caso nao seja o booleano esperado?

expectTrue "CURRENT_FAVICON_EXISTS" \
"$OK_TAG CURRENT_FAVICON" \
"$OK_TAG CURRENT_FAVICON $(colorir "amarelo_claro" "-> OBS: O arquivo de favicon.ico do Issabel não existe. Seu Favicon deve estar quebrado..")" \
"false"

# Conferindo se houve algum erro, se teve alguma flag com valor fora do esperado.
if [ $END_SESSION ]; then
    exit 1
fi

# Perguntando se deseja prosseguir com as alterações, com a aplicação do tema.
while true; do
  echo "Deseja prosseguir com a aplicação do tema? (s/n)"
  echo ""

  read prosseguir

  # Converter a entrada do usuário para letras minúsculas
  prosseguir_lowercase=$(echo "$prosseguir" | tr '[:upper:]' '[:lower:]')


  case "$prosseguir_lowercase" in
    s|sim|y|yes)
      echo "Prosseguindo..."
      break
      ;;
    n|nao|no)
      echo "Encerrando..."
      exit 1
      ;;
    *)
      echo "Opção inválida."
      echo ""
      ;;
  esac
done

# <--------------- iniciando, de fato, as alterações ------------>

log "# Verificando sobre o DIRETÓRIO DE BACKUP ..."
if $PATH_BKPFOLDER_EXISTS; then
  # A pasta de backup já existe, não deveria ter chego até este ponto!
  log "[CRITICAL] De alguma forma, você conseguiu chegar onde não deveria. Sua pasta de backup '$PATH_BKPFOLDER' existe, sendo que não é o momento dela existir ainda! Chame alguém responsável pelo SCRIPT."
  exit 1
else
  log "- $(colorir "ciano_claro" "Criando a pasta de backup")."
  log "- mkdir $PATH_BKPFOLDER"
  mkdir $PATH_BKPFOLDER
  if dExists $PATH_BKPFOLDER; then
    # Tudo certo, o diretório foi criado.
    :
  else
    log "[CRITICAL] Por algum motivo, não foi possível criar a pasta de backup (mkdir $PATH_BKPFOLDER). Abortando por segurança."
    exit 1
  fi
fi

log "# Verificando sobre o MAINSTYLE.CSS ..."
if $CURRENT_MAINSTYLECSS_EXISTS; then
    # Arquivo MAINSTYLE existe, logo, renomeio, movo à bkp, substituo pelo novo.
    log "- $(colorir "ciano_claro" "Substituindo o mainstyle.css atual pelo novo")."
    log "- Movendo o arquivo '$CURRENT_MAINSTYLECSS' para a pasta '$PATH_BKPFOLDER'."
    mv $CURRENT_MAINSTYLECSS $PATH_BKPFOLDER/

    log "- Copiando o arquivo '$SCP_MAINSTYLECSS' para a pasta '$PATH_MAINSTYLECSS'."
    cp -R $SCP_MAINSTYLECSS $PATH_MAINSTYLECSS
else
    # Arquivo MAINSTYLE não existe, logo, só substituo pelo novo.
    log "- $(colorir "ciano_claro" "Utilizando o mainstyle.css novo")."
    log "- Copiando o arquivo '$SCP_MAINSTYLECSS' para a pasta '$PATH_MAINSTYLECSS'."
    cp -R $SCP_MAINSTYLECSS $PATH_MAINSTYLECSS
fi

log "# Verificando sobre o FAVICON.ICO ..."
if $CURRENT_FAVICON_EXISTS; then
    # Arquivo FAVICON existe, logo, renomeio, movo à bkp, substituo pelo novo.
    log "- $(colorir "ciano_claro" "Substituindo o favicon.ico atual pelo novo")."
    log "- Movendo o arquivo '$CURRENT_FAVICON' para a pasta '$PATH_BKPFOLDER'."
    mv $CURRENT_FAVICON $PATH_BKPFOLDER/

    log "- Copiando o arquivo '$SCP_FAVICON' para a pasta '$PATH_FAVICON'."
    cp -R $SCP_FAVICON $PATH_FAVICON
else
    # Arquivo FAVICON não existe, logo, só substituo pelo novo.
    log "- $(colorir "ciano_claro" "Utilizando o favicon.ico novo")."
    log "- Copiando o arquivo '$SCP_FAVICON' para a pasta '$PATH_FAVICON'."
    cp -R $SCP_FAVICON $PATH_FAVICON
    
fi

log "# Verificando sobre o themes/FALEVOX ..."
if $USE_OLD_THEME; then
    # "Quer usar o tema antigo, logo, não faço nada."
    log "- $(colorir "ciano_claro" "Utilizando o tema antigo")."
    :
else
    # "Quer usar o tema novo, preciso verificar se o antigo existe ou não."
    if $OLD_EXISTS; then

        # "O tema antigo existe, logo, renomeio, movo à bkp, substituo pelo novo."
	log "- $(colorir "ciano_claro" "Substituindo o tema atual pelo novo")."
        log "- Movendo o arquivo '$PATH_ISSABELTHEME/falevox' para a pasta '$PATH_BKPFOLDER'."
        mv $PATH_ISSABELTHEME/falevox $PATH_BKPFOLDER/ # Movo o antigo pra pasta de backup

        log "- Copiando o arquivo '$SCP_FALEVOXTHEME' para a pasta '$PATH_ISSABELTHEME'."
        cp -R $SCP_FALEVOXTHEME $PATH_ISSABELTHEME # Movo o novo pra pasta de temas
    else
        # O tema antigo não existe, logo, só substituo pelo novo.
        log "- $(colorir "ciano_claro" "Utilizando o tema novo")."
	log "- Copiando o arquivo '$SCP_FALEVOXTHEME' para a pasta '$PATH_ISSABELTHEME'."
        cp -R $SCP_FALEVOXTHEME $PATH_ISSABELTHEME # Movo o novo pra pasta de temas
    fi   
fi

log "# --- $(colorir "verde_claro" "SUCESSO")! --- #"
