#!/bin/bash

# test if dir exists
PGP_PUBLIC_KEYS_DIR=.public-keys
if [ ! -d "${PGP_PUBLIC_KEYS_DIR}" ]
then
    printf "ERROR: folder %s not found\n" "${PGP_PUBLIC_KEYS_DIR}"
    exit 1
fi

ls ${PGP_PUBLIC_KEYS_DIR}/*asc | while read PUBLIC_KEY; do \
gpg --yes --import ${PUBLIC_KEY} ;\
done
