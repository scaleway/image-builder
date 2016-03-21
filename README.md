# Official Image Builder on Scaleway

[![Run on Scaleway](https://img.shields.io/badge/Scaleway-run-69b4ff.svg)](http://cloud.scaleway.com/#/servers/new?image=49eb4659-44a2-4d9c-bcc4-142185379e6e)

Scripts to build the official Image Builder on Scaleway

![](http://s10.postimg.org/fw962sxkp/builder.png)
---

**This image is meant to be used on a Scaleway server.**

We use the Docker's building system and convert it at the end to a disk image that will boot on real servers without Docker.

> Note that the image is still runnable as a Docker container for debug or for inheritance.

[More info](https://github.com/scaleway/image-tools)


## How to build a custom image using [scw](https://github.com/scaleway/scaleway-cli)

**My custom image's description**
- based on the official [Ubuntu Wily](https://github.com/scaleway/image-ubuntu)
- with `cowsay` pre-installed

---

##### 1. Making the environment

```console
root@yourmachine> scw run --name="buildcowsay" image-builder
               _
 ___  ___ __ _| | _____      ____ _ _   _
/ __|/ __/ _` | |/ _ \ \ /\ / / _` | | | |
\__ \ (_| (_| | |  __/\ V  V / (_| | |_| |
|___/\___\__,_|_|\___| \_/\_/ \__,_|\__, |
                                    |___/
...

*****************************************************************************

   Welcome on the image-builder.
   Here, you'll be able to craft your own images.

   To configure your environment run:

   $> image-builder-configure

*****************************************************************************

...

root@buildcowsay:~# image-builder-configure
Login (cloud.scaleway.com):                     # yourmail
Password:                                       # yourpassword
root@buildcowsay:~# mkdir cowsay
root@buildcowsay:~# cp Makefile.sample cowsay/Makefile
root@buildcowsay:~# cp Dockerfile.sample cowsay/Dockerfile
root@buildcowsay:~# cd cowsay
root@buildcowsay:~/cowsay# ls -l
total 4
-rw-r--r-- 1 root root  562 Mar 18 10:37 Dockerfile
-rw-r--r-- 1 root root  556 Mar 18 10:38 Makefile
```
##### 2. Configuring your Makefile
```console
NAME =                  cowsay
VERSION =               latest
VERSION_ALIASES =       1.2.3 1.2 1
TITLE =                 wily-cowsay
DESCRIPTION =           wily with cowsay pre-installed
DOC_URL =
SOURCE_URL =            https://github.com/scaleway-community/...
VENDOR_URL =
DEFAULT_IMAGE_ARCH =	x86_64


IMAGE_VOLUME_SIZE =     50G
IMAGE_BOOTSCRIPT =      stable
IMAGE_NAME =            cowsay

## Image tools  (https://github.com/scaleway/image-tools)
all:	docker-rules.mk
docker-rules.mk:
	wget -qO - http://j.mp/scw-builder | bash
-include docker-rules.mk
```


##### 3. Configuring your Dockerfile

> Note: Don't remove the comments #FROM scaleway/distribution:arch-version # arch=arch

> These lines are used by Makefile to handle the multiarch

```dockerfile
FROM scaleway/ubuntu:amd64-wily
# following 'FROM' lines are used dynamically thanks do the image-builder
# which dynamically update the Dockerfile if needed.
#FROM scaleway/ubuntu:armhf-wily       # arch=armv7l
#FROM scaleway/ubuntu:arm64-wily       # arch=arm64
#FROM scaleway/ubuntu:i386-wily        # arch=i386
#FROM scaleway/ubuntu:mips-wily        # arch=mips

# Prepare rootfs
RUN /usr/local/sbin/scw-builder-enter

# install cowsay
RUN apt-get install -y cowsay

# Clean rootfs
RUN /usr/local/sbin/scw-builder-leave
```

You can see other Dockerfiles [here](https://github.com/scaleway/image-tools#official-images-built-with-image-tools)

##### 4. Building the custom image
```console
root@buildcowsay> make image_on_local
...
[+] URL of the tarball: http://YOUR_IP:8000/x86_64-cowsay-latest/x86_64-cowsay-latest.tar
[+] Target name: x86_64-cowsay-latest.tar
[+] Creating new server in rescue mode with a secondary volume...
[+] Server created: 3e801785-4e62-425f-bb5a-04eac555ff79
[+] Booting...
Linux vm-10-2-12-155 4.4.4-std-3 #1 SMP Tue Mar 8 17:31:34 UTC 2016 x86_64 GNU/Linux
[+] Server is booted
[+] Formating and mounting disk...
mke2fs 1.42.12 (29-Aug-2014)
ext2fs_check_if_mount: Can't check if filesystem is mounted due to missing mtab file while determining whether /dev/vda is mounted.
Creating filesystem with 12207031 4k blocks and 3055616 inodes
Filesystem UUID: 0201e6cd-4848-4118-b762-297968e776af
Superblock backups stored on blocks:
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
	4096000, 7962624, 11239424

Allocating group tables: done
Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done

[+] /dev/nbd1 formatted in ext4 and mounted on /mnt
[+] Download tarball and write it to /mnt
[+] Tarball extracted on disk
[+] Stopping the server
[+] Server stopped
[+] Creating a snapshot of disk 1
[+] Snapshot ae6f1ed9-6b77-46f9-861a-2b4d66cb38b5 created
[+] Creating an image based of the snapshot
[+] Image created: 53962798-2933-4cc9-b6c9-1e05f6ff7051   # IMAGE_ID
[+] Deleting temporary server
[+] Server deleted
```
Your custom image is now available [here](https://cloud.scaleway.com/#/images)

##### 4. Running your custom image
```console
root@buildcowsay:~/cowsay# scw run --tmp-ssh-key --name="cowsay-app"  IMAGE_ID
               _
 ___  ___ __ _| | _____      ____ _ _   _
/ __|/ __/ _` | |/ _ \ \ /\ / / _` | | | |
\__ \ (_| (_| | |  __/\ V  V / (_| | |_| |
|___/\___\__,_|_|\___| \_/\_/ \__,_|\__, |
                                    |___/
...

root@cowsay-app:~# cowsay "Hello from my app"
 ____________________________
< Hello from my app >
 ----------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

---

## Multiarch

By default `make image_on_local` use your architecture (x86_64 on C2/VPS and armv7l on C1), if you want to craft your image in arm you must specify the architecture with `armv7l`

```console
# works only on C2/VPS
ARCH=armv7l make image_on_local
```

Or run image-builder with C1

```console
root@yourmachine> scw run --name="arm-builder" --commercial-type=C1 image-builder
```


## Know issues

- if you have an error when you try to connect on your Scaleway account, remove `~/.scwrc` and retry

## Changelog

### Unreleased
* Multiarch documentation
* Bump scw to 1.8.0
* Improved image-builder-configure (now he don't ask for login/password is ~/.scwrc already exist)

### 1.3.0 (2015-09-11)

* Bumped scw to 1.5.0
* Added a local webserver
* Put the generation of the key in rc.local

### 1.2.0 (2015-08-28)

* Bumped scw to 1.4.0
* Improved image-builder-configure

### 1.1.0 (2015-08-06)

* Improved image-builder-configure (bash now)
* Added the S3_URL in the image-builder-configure script
* Added new script to check if your environment is configured as well

### 1.0.0 (2015-08-05)

This initial version contains:

* Added scw s3cwd
* Added ssh key
* Added script to preconfigure your environment

---

A project by [![Scaleway](https://avatars1.githubusercontent.com/u/5185491?v=3&s=42)](https://www.scaleway.com/)
