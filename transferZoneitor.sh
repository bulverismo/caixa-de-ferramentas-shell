#!/bin/bash

# Cria um banner para mostrar caso haja erro ou seja pedido ajuda
banner='
transferZoneitor
Busca servidores de nome de dominio associados a um host e tenta transferir a zona de servidor de dominio para obter os registros
'

# Verifica se o numero de argumentos esta correto ou se tentou
# help caso não esteja ok redireciona uma mensagem para a saída de erro 
# e sai do script enviando retorno diferente de zero para indificar
# que ocorreu o erro
if [ "$1" == "--help" ]  
then

  # Mostra o banner
  echo "$banner"

  # usa o comando test para condicionar a exibição da linha
  # a somente ter o numero errado de argumentos
  # caso tenha sido indicado o comando help então não exibe
  [ "$1" == "--help" ] || echo "Forneça o numero correto de argumentos"
  echo "Uso: $0 site" >&2
  [ "$1" == "--help" ] || exit 1

else

  # Poe na variavel hosts o host informado no argumento 1
  # porém se nada for informado MAS tiver algo na entrada
  # primaria então o cat vai pegar esse item ou lista e 
  # por na variavel hosts
  if [ "$1" ]
  then
    hosts="$1"
  else
    hosts=`cat $1`
  fi

  # O primeiro for vai 'caminhar' pela lista de itens que estão
  # dentro da variável hosts, que podera conter um site ou muitos
  for host in $hosts
  do
  
    # Encontra uma lista com os servidores de nome de dominio
    # e guarda numa lista para então tentar a trasferencia de zona
    # de um em um, e perceba que manda via pipe para o comando cut
    # para deixar a saida limpa somente com os endereços dos servidores
    # de nome de dominio
    # obs.: nss = NameServerS
    nss=$(host -t ns $host | grep -v "alias" | grep -v "not found" | grep -v "has no NS" | cut -d " " -f4)
    
    # Este segundo for aninhado corresponde a andar em cada um dos 
    # servidores de dominio encontrados em relação ao host atual 
    for ns in $nss
    do
      
      # Tenta fazer a transferencia de zona e se não consegue da o feedback
      # senão mostra o que encontrou
      resultado="$(host -l $host $ns)"
      if ! grep -qE "Transfer failed|communications error" <<< "$resultado"
      then
        sed "1,5d" <<< "$resultado"
      fi
    done
  done

  exit 0

fi
