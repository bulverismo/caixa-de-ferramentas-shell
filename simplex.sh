#!/bin/bash

RED='\033[0;31m'
VERDE='\033[0;32m'
CINZA='\033[1;36m'
NC='\033[0m' # No Color
barra="  ${CINZA}#######################################################${NC}"

if [ $# -ne 2 ] || [ ! -r $2 ]
then

  echo -e "$barra" >&2
  echo "  DNSECDNS RECON...."                                      >&2 
  echo "  KowaBulver Security - Ezekiel Bulver"                    >&2 
  echo "  $0 alvo.com.br subdominios.txt"                          >&2 
  echo -e "$barra" >&2

  echo Não foi passados os argumentos ou o arquivo com os subdominios >&2
  exit 1

else
  site=$1
  subs=$2
fi
  
if ! . funcoes
then

  echo Não foi possivel importar o arquivo com as funções >&2
  exit 1

fi

# if ! CasaSite "$1"
# then
#   echo não casou
# fi

echo -e "$barra"
echo -e "  ${RED}Encontrando Name Servers${NC}"
echo -e "$barra"

nss=$(host -t ns $site | grep -v "alias" | grep -v "not found" | grep -v "has no NS" | cut -d " " -f4 | sed 's/\.$//')

echo $nss

echo -e "$barra"
echo -e "  ${RED}Encontrando Mail Servers${NC}"
echo -e "$barra"
mxs=$(host -t mx $site | grep -v "alias" | grep -v "not found" | grep -v "has no MX" | grep -o "[^ ]*$" | sed 's/\.$//')

echo $mxs

echo -e "$barra"
echo -e "  ${RED}Tentando transferir zona${NC}"
echo -e "$barra"
./transferZoneitor.sh $site

echo -e "$barra"
echo -e "  ${RED}Descobrindo subdominios...${NC}"
echo -e "$barra"
./dnsBrutos.sh -sem $site $subs 




