# sops in docker ( mozilla sops the gopass way )


## How to

- `make build-alpine-sops-container` to build the sops docker image  
- `make run-alpine-container` to start the docker container  

*or execute the commands under each make recipe from the makefile

## Sops

SOPS or secret operations i a way to store secrets in a git repo, for example keeping the secrets in a gitops repo. In order to decrypt a file you only need a master key, all other public keys are not needed in the key ring. To encrypt a file you need a master key and all public keys that can decrypt the files.

## From the Docker Container

Chaos engineering SOPS or testing assumptions from a docker container. 

- some bash scripts are available to easily get what is needed for sops 
- For some reason sops encryption/decryption does not work in the sops container if the pgp key uses a passphrase.

### Generate private/public keys.

Foo, Bar and Quz are our test user they will have it's own pgp key. 
Since Buz does not have a pgp key. He will not have access to the encrypted files.  
A little metasyntactic variable joke :).


```bash
PGP_EMAIL=foo.test@example.com ./scripts/gpg-generate-key-pair.sh
PGP_EMAIL=bar.test@example.com ./scripts/gpg-generate-key-pair.sh
PGP_EMAIL=quz.test@example.com ./scripts/gpg-generate-key-pair.sh
```

### Remove key ring (start fresh).

After the key generation it makes sense to start fresh. the test is not viable if all the public/private keys are in the same key ring. Do this either by destroying the container and starting a new one or remove the `.gnupg` directory. 

```bash
rm -r /root/.gnupg/
```

### Import public keys.

Import all public keys from the public folder (gopass style).

```bash
./scripts/gpg-import-public-keys.sh
```

### Import a master key.

Import one of the private keys also known as master key. 
Without a private key there is no way to encrypt/decrypt files.

```bash
gpg --yes --import .private-keys/foo.test\@example.com.asc
```

### Generate the key list for `.sops.yaml` file.

Sops needs to know the list of key used to encrypt files. 
Exec the script and manually add the keys to the `.sops.yaml` file.

```bash
 ./scripts/gpg-sops-import-keys.sh 
INFO: .sopas.yaml file gpg public keys

 - pgp: 38A72FA4C54DDC50,469142157BED552C,BB72787C9E992BFE

```

### Use sops to encrypt/decrypt files.

Now that all the public keys are imported and a master key is available 
you can encrypt or decrypt files.

```bash
sops --encrypt test.env > test.enc.env
sops --encrypt test.yaml > test.enc.yaml
sops --encrypt test.json > test.enc.json
```

### Other test

- Destroy the container, import another private key and run encrypt/decrypt commands.
- Generate another pgp file and encrypt the files using all keys.
- etc


### In case some bad keys are exported.

This happened only in one iteration out of ... many. 
I was to fix the errors using the solution from below gist.

```bash
# https://gist.github.com/m-rey/b981b214a8936e889dc3675557ad5b22
gpg --check-trustdb 2>&1| grep 'not found' | awk '{print $8}' >bad-keys.txt
gpg --export-ownertrust > ownertrust-gpg.txt
mv ~/.gnupg/trustdb.gpg ~/.gnupg/trustdb.gpg-broken
for KEY in `cat bad-keys.txt` ; do sed -i "/$KEY/d" ownertrust-gpg.txt ; done
gpg --import-ownertrust ownertrust-gpg.txt
rm bad-keys.txt ownertrust-gpg.txt
```
