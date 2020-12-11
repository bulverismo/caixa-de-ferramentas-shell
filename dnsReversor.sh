#!/bin/bash

# Cria um banner para mostrar caso haja erro ou seja pedido ajuda
banner='
ipReversor
Recebe um endereço ip e retorna registros ptr 
'

# Verifica se o numero de argumentos esta correto ou se tentou
# help caso não esteja ok redireciona uma mensagem para a saída de erro 
# e sai do script enviando retorno diferente de zero para indificar
# que ocorreu o erro
if [ "$1" == "--help" ] || [ $# -ne 1 ]  
then

  # Mostra o banner
  echo "$banner"

  # usa o comando test para condicionar a exibição da linha
  # a somente ter o numero errado de argumentos
  # caso tenha sido indicado o comando help então não exibe
  [ "$1" == "--help" ] || echo "Forneça o numero correto de argumentos"
  echo "Uso: $0 ip" >&2
  echo ""
  echo "Fornecer bloco de ip no formato xxx.xxx.xxx.xxx"
  [ "$1" == "--help" ] || exit 1

else

  # Pegando ultima parte do bloco de ip 
  host=${1#*.*.*.}
  inicioIp=${1%.*}

  hosts=$( seq $(( (( $host <= 8 ? 1 : $host - 8 ))  )) $(( (( $host >= 246 ? 254 : $host + 8 ))  )) )

  # percorre range de ip definido 
  for ip in $hosts 
  do
    # o comando host resolve o ip para o nome
    # joga a saida do comando no grep para filtrar e 
    # não exibir as linhas que não contém um nome de dominio
    # de nosso interesse
    # o comando sed substitui no bloco de ip que foi 
    host $inicioIp.$ip | grep -v "$(sed "s/\./-/g" <<< "$1")" | grep -v "not found" 

  done

  exit 0

fi
