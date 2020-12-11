#!/bin/bash

# Cria um banner para mostrar caso haja erro ou seja pedido ajuda
banner='
dnsBrutos
Recebe uma lista de subdominios através de uma arquivo
retorna uma lista com os ips correspondentes aos hosts
'
usoCorreto=' Uso: $0 site lista_de_subdominios.txt

    -ip    desta forma mostra na saída somente os ips encontrados
    -sub   desta forma mostra na saída somente os subdominios encontrados
    -sem   desta forma mostra na saída sem suprimir "has address" 
'

# Variavel para indicar que tudo ocorreu como o esperado
sucesso=0

# Verifica se o numero de argumentos esta correto ou se tentou
# help caso não esteja ok redireciona uma mensagem para a saída de erro 
# e sai do script enviando retorno diferente de zero para indificar
# que ocorreu o erro, verifica se o numero de argumentos esta correto
# e testa se veio algo da entrada primaria
if [ "$1" == "--help" ] || [ $# -ne 2 -a $# -ne 3 -a -t 0 ]
then

  # Mostra o banner
  echo "$banner" >&2

  # usa o comando test para condicionar a exibição da linha
  # a somente ter o numero errado de argumentos
  # caso tenha sido indicado o comando help então não exibe
  [ "$1" == "--help" ] || echo "Forneça o numero correto de argumentos" >&2
  echo "$usoCorreto" >&2
  [ "$1" == "--help" ] || exit 1

else

  # Pega lista de nomes de subdominios para achar os ips
  # testa para ver se foi setado alguma opção especial e
  # tenta buscar o argumento 2 ou 3 que deve ter o nome do arquivo
  # dependendo do caso
  if [ "$1" = "-ip" -o "$1" = "-sub" -o "$1" = "-sem" ]
  then
    lista=`cat $3`
    arg1="$1"
    site="$2"
  else
    lista=`cat $2`
    unset arg1
    site="$1"
  fi
  
  # testa com o comando test uma expressão regular se o que chegou na
  # variavel teste foi digitado no formato esperado
  if [[ "$site" =~ ([a-z]*)*\.[a-z]* ]]
  then

    # Se há elementos na lista quer dizer que tem  
    # nomes de subdominio para resolver em ip
    if [ "$lista" ]
    then

      # Neste for ele vai correr através dos elementos da lista 
      # resolvendo os ips e então mostrar na tela 
      for url in $lista 
      do
        
        # Executa o comando host que resolve o nome em ip
        # e usa o grep para filtrar se encontrou o ip do host
        # se tudo der certo grep retorna 0 caso contrario não 
        # vamos usar isso para guiar o if pois nos diz se 
        # host tem um dos subdominios da lista
        retorno1=$(host $url.$site | grep "has address")

        # Usa o sed para editar o retorno e remover as palavras
        # indesejadas do retorno
        retorno2=$(sed "s/ has address / /g" <<< "$retorno1")

        # Se de fato tem retorno do comando host então vai poder
        # apresentar na tela
        if [ "$retorno1" ]
        then

          # Separa o que esta na variavel em duas variaveis
          # uma com subdominio e outra vai conter o ip
          read sub ip <<< "$retorno2"
          sem="$retorno1"

          sucesso=1

          # Se o argumento 1 que foi enviado para o script 
          # contém -ip então somente exibe o ip na saída
          # caso contrario vai exibir subdominio e ip
          if [ "$1" = "-ip" -o "$1" = "-sub" -o "$1" = "-sem" ]
          then
            ponteiro=${arg1:1}
            printf "%s\n" "${!ponteiro}"
          else
            printf "%-30s %10s\n" "$sub" "$ip"
          fi
        fi

      done

      if [[ $sucesso -eq 1 ]]
      then
        exit 0
      else
        exit 4
      fi
        

    else
      
      # Forneça uma lista de subdominios que tenha itens
      echo "$banner" >&2

      echo "Lista de subdominio vazia" >&2
      echo "Envie uma lista de subdominios que tenha pelo menos um elemento" >&2

      echo "$usoCorreto" >&2

      exit 2 

    fi

  else

    # Erro de site em formato incorreto
    # Mostra o banner
    echo "$banner" >&2

    echo "Argumento 1 inválido!" >&2
    echo "Digite um site no formato: sub.dominio.com.br" >&2

    echo "$usoCorreto" >&2

    exit 3 
  fi
 
fi
