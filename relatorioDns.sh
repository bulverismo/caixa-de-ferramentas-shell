#!/bin/bash

# Cria um banner para mostrar caso haja erro ou seja pedido ajuda
banner='
** Relatório Automatizado de DNS **
TODO
'

# Verifica se o numero de argumentos esta correto ou se tentou
# help caso não esteja ok redireciona uma mensagem para a saída de erro 
# e sai do script enviando retorno diferente de zero para indificar
# que ocorreu o erro
if [ "$1" == "--help" ] || [ -t 0 -a  $# -ne 2 ]  
then

  # Mostra o banner
  echo "$banner"

  # usa o comando test para condicionar a exibição da linha
  # a somente ter o numero errado de argumentos
  # caso tenha sido indicado o comando help então não exibe
  [ "$1" == "--help" ] || echo "Forneça o numero correto de argumentos"
  echo "Uso: $0 site" >&2
  echo "ou " >&2
  echo "Uso: $0 lista_hosts.txt" >&2
  exit 1

else

  site="$1"
  subdominios="./subdominios.txt"
  listaPastasArqs="$2"

  echo ""
  echo "* * * * * * * * * * * * *"
  echo "Buscando arquivos e diretorios em $site"
  arquivos=$(./arquinator.sh $site $listaPastasArqs)
  diretorios=$(./pastaneitor.sh $site $listaPastasArqs)

  for item in arquivos diretorios
  do
    if [ "${!item}" ]
    then
      echo ""
      echo Encontrou $item comuns 
      echo "${!item}"
    else
      echo ""
      echo Não encontrou $item comuns 
    fi
  done

  unset ip
  ip=$(./hostitoipneitor.sh <<< "$site")

  echo ""
  echo "IP DO HOST = $ip"

  # Descobrindo subdominios
  
  unset subHosts
  subHosts=$(./dnsBrutos.sh $site $subdominios)
  subHostsIps=$(cut -d " " -f2 <<< $(tr -s ' ' ' ' <<< $subHosts))
  subHostsSub=$(cut -d " " -f1 <<< $(tr -s ' ' ' ' <<< $subHosts))
  
  # Lista dos ips e dos subdominios capturados
  #echo $subHostsIps
  #echo $subHostsSub

  if [[ "$subHosts" ]]
  then
    echo ""
    echo "Subdominios encontrados"
    echo "$subHosts"
  else
    echo ""
    echo "Não encontrou um subdominio comum"
  fi

  echo ""
  echo "Analisando ips vizinhos"
  vizinhos=$(./dnsReversor.sh $ip)
  echo "$vizinhos"

  echo "======="
  echo "Analisando sites relacionados a esta pagina web"
  relacionados=$(./parseneitor.sh $site)
  echo "$relacionados"

  echo "======="
  echo "Tentando realizar a transferência de zona" 
  ./transferZoneitor.sh $site

  exit 0

fi
