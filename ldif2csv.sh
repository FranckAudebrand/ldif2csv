#!/bin/bash

##################################################
#              L D I F 2 C S V                   #
# F. AUDEBRAND   01-2022  chaptivaloin@orange.fr #
#          Version 0.2 "Mbandaka"                #
##################################################

version="0.2 \"Mbandaka\""

csvheader="First Name,Middle Name,Last Name,Title,Suffix,Nickname,Given Yomi,Surname Yomi,E-mail Address,E-mail 2 Address,E-mail 3 Address,Home Phone,Home Phone 2,Business Phone,Business Phone 2,Mobile Phone,Car Phone,Other Phone,Primary Phone,Pager,Business Fax,Home Fax,Other Fax,Company Main Phone,Callback,Radio Phone,Telex,TTY/TDD Phone,IMAddress,Job Title,Department,Company,Office Location,Manager's Name,Assistant's Name,Assistant's Phone,Company Yomi,Business Street,Business City,Business State,Business Postal Code,Business Country/Region,Home Street,Home City,Home State,Home Postal Code,Home Country/Region,Other Street,Other City,Other State,Other Postal Code,Other Country/Region,Personal Web Page,Spouse,Schools,Hobby,Location,Web Page,Birthday,Anniversary,Notes"

i=0
qt='"'

raz() {
csvline="FirstName,MiddleName,LastName,Title,Suffix,Nickname,GivenYomi,SurnameYomi,E-mailAddress,E-mail2Address,E-mail3Address,HomePhone,HomePhon2,BusinessPhone,BusinessPhon2,MobilePhone,CarPhone,OtherPhone,PrimaryPhone,Pager,BusinessFax,HomeFax,OtherFax,CompMainPhone,Callback,RadioPhone,Telex,TTYTDDPhone,IMAddress,Fonction,Department,Company,OfficeLocation,
ManagersName,AssistantsName,AssistantsPhone,CompYomi,BusinessStreet,BusinessCity,BusinessState,BusinessPostalCode,BusinessCountryRegion,HomeStreet,HomeCity,HomeState,HomePostalCode,HomeCountryRegion,OtherStreet,OtherCity,OtherState,
OtherPostalCode,OtherCountryRegion,PersonalWebPage,Spouse,Schools,Hobby,Location,WebPage,Birthday,Anniversary,Notes"

insection=0
dn=""
nomaffiche=""
mail=""
nom=""
prenom=""
pays=""
mobile=""
ville=""
telfixe=""
societe=""
fax=""
adresse=""
objectClass=0
}

canalplus() {

retour="$1"

#if [ "${1:0:2}" == ": " ]; then retour=$(echo "${1:2:999}" | base64 --decode ); echo "Décodage de ${1:0:10}... pour $retour"; fi

if [ "${1:0:2}" == ": " ]; then retour=$(echo "${1:2:999}" | base64 --decode ); else retour=${retour:1:999}; fi

# S'il y a des virgules et des " dans la chaine, ben non, et on supprime le 1er espace

retour=$(echo "$retour" | tr "\"," " ");


 
}


if [ -f "$1" ] && [ "$2" != "" ]; then

raz

echo $csvheader > $2

while IFS= read -r line
do

e=$(expr index "$line" "dn: ")
##echo $e
if [ $e == 1 ]; then insection=1;fi

if [ "$line" == "" ]; then insection=2;fi 

#echo $insection

# echo "Ligne : $line (insection : $insection)"

if [ $insection == 1 ]; then
 
	# DN
	if [ "${line:0:3}" == "dn:" ]; then
		canalplus "${line:3:999}"
		dn="$retour"
	fi
	
	# nomaffiche
	if [ "${line:0:12}" == "displayname:" ] ; then
		canalplus "${line:12:999}"
		nomaffiche="$retour"
	fi

	# Mail
	if [ "${line:0:5}" == "mail:" ] ; then
		canalplus "${line:5:999}"
		mail="$retour"
	fi

	# nom
	if [ "${line:0:3}" == "sn:" ] ; then
		canalplus "${line:3:999}"
		nom="$retour"
	fi
	
	# Prénom
	if [ "${line:0:10}" == "givenname:" ] ; then
		canalplus "${line:10:999}"
		prenom="$retour"
	fi
	
	# Pays
	if [ "${line:0:2}" == "c:" ] ; then
		canalplus "${line:2:999}"
		pays="$retour"
	fi
	
	# mobile
	if [ "${line:0:7}" == "mobile:" ] ; then
		canalplus "${line:7:999}"
		mobile="$retour"
	fi	
	
	# Ville
	if [ "${line:0:2}" == "l:" ] ; then
		canalplus "${line:2:999}"
		ville="$retour"
	fi

	# Telfixe
	if [ "${line:0:16}" == "telephonenumber:" ] ; then
		canalplus "${line:16:999}"
		telfixe="$retour"
	fi

	# societe
	if [ "${line:0:2}" == "o:" ] ; then
		canalplus "${line:2:999}"
		societe="$retour"
	fi

	# fax
	if [ "${line:0:25}" == "facsimiletelephonenumber:" ] ; then
		canalplus "${line:25:999}"
		fax="$retour"
	fi
	
	# adresse
	if [ "${line:0:7}" == "street:" ] ; then
		canalplus "${line:7:999}"
		adresse="$retour"
	fi
	
	# cn
	if [ "${line:0:3}" == "cn:" ] ; then
		canalplus "${line:3:999}"
		cn="$retour"
	fi
	
	# title (fonction)
	if [ "${line:0:6}" == "title:" ] ; then
		canalplus "${line:6:999}"
		fonction="$retour"
	fi
	
	# objectClass : on ne traite que les objectClass: inetOrgPerson
	if [ "$line" == "objectClass: inetOrgPerson" ] ; then
		objectClass=1
	fi
	
	
		
fi


if [ $insection == 2 ] && [ "$dn" != "" ] && [ $objectClass == 1 ] ; then

	# Traitemente des absences de valeur
	
	if [ "$dn" == "" ] ; then
	echo "DN Vide $dn"
	exit
	fi

	echo "$i - Mail : $mail Prénom : $prenom Nom : $nom (DN=$dn)"
	
	((i++))

	# protection du mail contre les carateres a la con
	
	mail=${mail//["\\/"]/""}
	
	if [ $(expr index "$mail" "=") != 0 ]; then echo "Suppression du mail $mail"; mail="" ;fi
	
	
	csvline=${csvline//FirstName/$qt$prenom$qt}
	csvline=${csvline//LastName/$qt$nom$qt}
	csvline=${csvline//E-mailAddress/$qt$mail$qt}
	csvline=${csvline//BusinessCountryRegion/$qt$pays$qt}
	csvline=${csvline//MobilePhone/$qt$mobile$qt}	
	csvline=${csvline//BusinessCity/$qt$ville$qt}	
	csvline=${csvline//BusinessStreet/$qt$adresse$qt}	
	csvline=${csvline//BusinessPhone/$qt$telfixe$qt}	
	csvline=${csvline//Company/$qt$societe$qt}	
	csvline=${csvline//BusinessFax/$qt$fax$qt}
	csvline=${csvline//BusinessPostalCode/$qt$codepostal$qt}
	csvline=${csvline//Fonction/$qt$fonction$qt}
	
	# Champs non gérés
	
	csvline=${csvline//MiddleName/""}

csvline=${csvline//Title/""}
csvline=${csvline//Suffix/""}
csvline=${csvline//Nickname/""}
csvline=${csvline//GivenYomi/""}
csvline=${csvline//SurnameYomi/""}
csvline=${csvline//E-mail2Address/""}
csvline=${csvline//E-mail3Address/""}
csvline=${csvline//HomePhone/""}
csvline=${csvline//HomePhon2/""}
csvline=${csvline//BusinessPhon2/""}
csvline=${csvline//CarPhone/""}
csvline=${csvline//OtherPhone/""}
csvline=${csvline//PrimaryPhone/""}
csvline=${csvline//Pager/""}
csvline=${csvline//HomeFax/""}
csvline=${csvline//OtherFax/""}
csvline=${csvline//CompMainPhone/""}
csvline=${csvline//Callback/""}
csvline=${csvline//RadioPhone/""}
csvline=${csvline//Telex/""}
csvline=${csvline//TTYTDDPhone/""}
csvline=${csvline//IMAddress/""}
csvline=${csvline//Department/""}
csvline=${csvline//OfficeLocation/""}
csvline=${csvline//ManagersName/""}
csvline=${csvline//AssistantsName/""}
csvline=${csvline//AssistantsPhone/""}
csvline=${csvline//CompYomi/""}
csvline=${csvline//BusinessStreet/""}
csvline=${csvline//BusinessState/""}
csvline=${csvline//BusinessCountryRegion/""}
csvline=${csvline//HomeStreet/""}
csvline=${csvline//HomeCity/""}
csvline=${csvline//HomeState/""}
csvline=${csvline//HomePostalCode/""}
csvline=${csvline//HomeCountryRegion/""}
csvline=${csvline//OtherStreet/""}
csvline=${csvline//OtherCity/""}
csvline=${csvline//OtherState/""}
csvline=${csvline//OtherPostalCode/""}
csvline=${csvline//OtherCountryRegion/""}
csvline=${csvline//PersonalWebPage/""}
csvline=${csvline//Spouse/""}
csvline=${csvline//Schools/""}
csvline=${csvline//Hobby/""}
csvline=${csvline//Location/""}
csvline=${csvline//WebPage/""}
csvline=${csvline//Birthday/""}
csvline=${csvline//Anniversary/""}
csvline=${csvline//Notes/""}
		
		# echo $csvline	
	#echo ${csvline:2:9999} >> $2
	echo $csvline >> $2	
raz
	
fi

done < $1

echo -e "\r\n# L D I F 2 C S V # v $version F Audebrand - chaptivaloin@orange.fr \r\n"

echo "Traitement terminé, commentaires/bugs/besoin de mieux, mais oui c'est clair ! --> franck.audebrand@apca.chambagri.fr"

else

echo "# L D I F 2 C S V # v $version - F Audebrand - chaptivaloin@orange.fr"
echo Faites suivre la commande du fichier source LDIF et du fichier destination CSV
echo Exemple : eddy_malou.sh moncarnet.ldif moncarnet.csv


fi

