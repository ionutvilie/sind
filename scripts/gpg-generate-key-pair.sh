#!/bin/bash

# remove gpg keyring
if [ -d "/root/.gnupg/" ]
then
    rm -r /root/.gnupg/
fi

# https://www.gnupg.org/documentation/manuals/gnupg-devel/Unattended-GPG-key-generation.html
cat > "default-key" <<-EOF
    %echo Generating a default key
    %no-protection
    Key-Type: default
    Subkey-Type: default
    Name-Real: $PGP_EMAIL
    Name-Comment: $PGP_EMAIL
    Name-Email: $PGP_EMAIL
    Expire-Date: 0
    %echo No Passphrase: $PGP_PASSPHRASE
    %commit
    %echo done
EOF

gpg --batch --generate-key default-key

# it will faill if more than one keys are in the keyring.
# the container should generate only one key per run
GPG_KEY_ID=$(gpg --list-keys --with-colons | awk -F: '/^pub:/ { print $5 }' | head -1)
printf "INFO: GPG_KEY_ID = %s\n" "$GPG_KEY_ID"

# export public-key
gpg  --armor \
--output ".public-keys/$GPG_KEY_ID.asc" \
--export $PGP_EMAIL

# export private-key
echo $PGP_PASSPHRASE | gpg \
--pinentry-mode loopback \
--batch --passphrase-fd 0 \
--output ".private-keys/${PGP_EMAIL}.asc" \
--armor --yes \
--export-secret-key $PGP_EMAIL