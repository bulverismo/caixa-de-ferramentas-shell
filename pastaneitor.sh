#!/bin/bash

banner='
pastaneitor
Buscar porno mes de diretorios em uma url
baseado em uma lista de palavras fornecidas
'


if [ $# -ne 2 ]
then
  echo "$banner"
  echo "Forneça o numero correto de argumentos"
  echo "Uso correto: $0 site lista_de_palavras.txt" >&2
  exit 1
fi

if [ -w $2 ]
then

  for palavra in $(cat $2)
  do
    resposta=$(curl -s -o /dev/null -w "%{http_code}" $1/$palavra/)
    if [ $resposta == "200" ] 
    then
      echo $1/$palavra
    fi
  done

else
  echo "$banner"
  echo "Forneça um nome arquivo valido e que tenha permissão de leitura"
  echo "Uso correto: $0 site lista_de_palavras.txt" >&2
  exit 2 

fi
