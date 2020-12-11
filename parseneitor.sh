#!/bin/bash

# Cria um banner para mostrar caso haja erro ou seja pedido ajuda
banner='
parsenator
Buscar urls relacionadas a um site
'

# Verifica se o numero de argumentos esta correto
# caso não esteja redireciona uma mensagem para a saída de erro 
# e sai do script enviando retorno diferente de zero para indicar
# o erro
if [ $# -ne 1 ] || [ "$1" == "--help" ]
then

  echo "$banner"

  # usa o comando test para condicionar a exibição da linha
  # a somente ter o numero errado de argumentos
  # caso tenha sido indicado o comando help então não exibe
  [ "$1" ] || echo "Forneça o numero correto de argumentos"
  echo "Uso correto: $0 site" >&2
  exit 1

else

  # Usa o wget para baixar setando algumas flags para controle
  # -T 3 define tempo limite para ficar tentando baixar
  # -q omite a saída
  # -O define a saida para um arquivo temporario
  wget -T 3 -q -O /tmp/siteAlvo $1
  
  # Pega a pagina que baixo e limpa para apresentar na saída 
  # grep acha as linhas usando uma expressão regular
  # sort remove duplicatas 
  # sed edita para deixar sem o http:// ou https:// no inicio usando uma expressão regular
  lista=`grep -Eo 'https?://[^\"/]*' /tmp/siteAlvo | sort -u | sed -E 's-https?://(.*)-\1-g'`

  # Se há elementos na lista quer dizer que encontrou então entra aqui
  # para exibir
  if [ "$lista" ]
  then

    # Neste for ele vai correr através dos resultados encontrados
    # e então mostrar na tela
    for url in $lista 
    do
      echo $url
    done

    exit 0

  else
    echo Não encontrou resultados 

    exit 2
  fi

fi
