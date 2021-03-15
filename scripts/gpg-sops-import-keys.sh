#!/bin/bash

# gpg --list-keys --with-colons | grep pub | awk -F ":" '{print $5}' | \
# while read KEY_FINGERPRINT; do \
# echo sops updatekeys --add-pgp $KEY_FINGERPRINT ; done


declare -a GPG_KEY_IDS
while read GPG_PUBLIC_KEY; do \
GPG_KEY_ID=$(gpg --with-colons $GPG_PUBLIC_KEY 2>/dev/null | grep pub | awk -F":" '{print $5}'); \
GPG_KEY_IDS+=("$GPG_KEY_ID")
done < <(ls .public-keys/*.asc)


GPG_PUBLIC_KEYS=""
for (( i=0; i<"${#GPG_KEY_IDS[@]}"; i++ ))
do 
    if [ "$i" -eq "0" ]
    then
        GPG_PUBLIC_KEYS=${GPG_KEY_IDS[$i]}
    else
        GPG_PUBLIC_KEYS=$GPG_PUBLIC_KEYS,${GPG_KEY_IDS[$i]}
    fi
done

printf "INFO: .sopas.yaml file gpg public keys\n\n"
printf " - pgp: %s\n\n" "${GPG_PUBLIC_KEYS}"
