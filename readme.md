# Budowanie obrazów na wiele platform

Testowane na Linux Mint 20.1, kernel 5.4.0-70-generic, Docker: 20.10.5 Community Edition

Jeśli w Docker jest dostępny buildx to możliwe jest budowanie obrazu na rózne platformy sprzętowe jednak nie jest możliwe wygodne budowanie obrazów wieloplatformowych. Do tego celu potrzeby jest dodatkowy builder oraz oprogramowanie QUEMU.

W innym przypadku otrzymamy poniższy błąd

```
error: multiple platforms feature is currently not supported for docker driver. Please switch to a different driver (eg. "docker buildx create --use")
```

## Źródło

https://medium.com/@artur.klauser/building-multi-architecture-docker-images-with-buildx-27d80f7e2408

Z opisanego w artylule na moim systemie było potrzebne tylko doinstalowanie QEMU i dodanie buildera

Podziękowania dla Artura Klauser za dogłębne wyjaśnienie i opisanie tematu — szkoda, że dokumentacja Docker nie tłumaczy tego zagadnienia w ten sposób. 

## instalacja QEMU

```
sudo apt-get install -y qemu-user-static
```

weryfikacja: `check-quemu-binfmt` 
w razie problemów: `reregister-qemu-binfmt.sh`

## Alternative

As an alternative to installing the QEMU and binfmt-support packages on your host system you can use a docker image to satisfy the corresponding requirements.
Using those images doesn’t release you from having the right docker and kernel version on the host system, but you do get around installing QEMU and binfmt-support packages on the host. I like to use multiarch/qemu-user-static:

docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

## konfiguracja buildera

```
docker buildx create --name mybuilder
docker buildx use mybuilder
```

You can check your newly created mybuilder with:

```
docker buildx inspect --bootstrap
```

Teraz można buwować wieloplatformowe obrazy

```
docker buildx build --push --platform=linux/arm/v7,linux/arm64/v8,linux/amd64 -t lapierre/multiarch-java-alpine:8.252.09-r0-a3.12.2 .
```

Powyższe polecenie zbuduje i wypchnie do Docker Registry wieloplatformową wersję obrazu (amd64, arm i arm64). Bez przełączika `--push` obraz nie zostanie umeszczony w loalnym image registry Dockera - dlatego użycie przełącznika jest zalecane. Zamiast linux/amd64 można wskazać `local`. 
