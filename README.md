# ldif2csv
# Version 0.2

Bash script to convert LDIF address books to CSV (O365 compatible)

Usage : ldif2csv myaddresses.ldif myaddresses.csv

This script will create csv o365 compatible file, mapped fileds are :

-FirstName
-LastName
-E-mailAddress
-BusinessCountryRegion
-MobilePhone
-BusinessCity
-BusinessStreet
-BusinessPhone
-Company
-BusinessFax
-BusinessPostalCode
-Fonction

..but this list can be completed adding a section (you should modify PutHereLDAPFiedNameLenght and LDAPFiedNameLenght

        # Fied name
        if [ "${line:0:PutHereLDAPFiedNameLenght}" == "LDAPFiedNameLenght:" ] ; then
                canalplus "${line:PutHereLDAPFiedNameLenght:999}"
                fonction="$retour"
                
List of avalaibles fied (reconized by o365) is in $csvheader (top of the code).

## CHANGELOG

# 0.2
Add email content control and delete value if contains" =" (like "o=somthing") or remove inapropriate char "\"

# 0.1 
Initial version, csv is base from a sample export of outlook365, ldif files tested are Sogo exports.

          

