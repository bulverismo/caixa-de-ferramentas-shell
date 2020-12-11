#!/bin/bash

# Cria um banner para mostrar caso haja erro ou seja pedido ajuda
banner='
hostitoipneitor
Recebe uma lista de hosts atraves de uma arquivo
ou na entrada padrao e retorna uma lista
com os ips correspondentes aos hosts
'
# Exemplo de como acessar o que esta vindo da entrada padrão
#echo $(</dev/stdin)

# Verifica se o numero de argumentos esta correto , se tentou
# help ou ainda se esta com algo vindo da entrada padrão
# caso não esteja redireciona uma mensagem para a saída de erro 
# e sai do script enviando retorno diferente de zero para indificar
# o erro
if [ "$1" == "--help" ] || [ -t 0 -a  $# -ne 1 ]  
then

  echo "$banner"

  # usa o comando test para condicionar a exibição da linha
  # a somente ter o numero errado de argumentos
  # caso tenha sido indicado o comando help então não exibe
  [ "$1" ] || echo "Forneça o numero correto de argumentos"
  echo "Uso: $0 lista_de_hosts.txt" >&2
  [ "$1" ] || exit 1


else

  # Pega lista de nome de dominio para achar os ips
  # tenta buscar o argumento 1 que deve ter o nome do arquivo
  # mas o cat vai buscar da entrada padrão se não tiver
  # sido enviado nada no argumento 1
  lista=`cat $1`

  # Se há elementos na lista quer dizer que tem  
  # nomes de dominio para resolver em ip
  if [ "$lista" ]
  then

    # Neste for ele vai correr através dos elementos da lista 
    # resolvendo os ips e então mostrando na tela 
    for url in $lista 
    do
      ./resolve_nomes $url | grep -oE "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"
    done

    exit 0

  else
    echo Não encontrou resultados 

    exit 2
  fi

fi
