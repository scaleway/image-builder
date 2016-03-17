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
- based on the official [Ubuntu Vivid](https://github.com/scaleway/image-ubuntu)
- with `cowsay` pre-installed

---

##### 1. Making the environment

> Note if you have an error when you try to connect on your Scaleway account, remove ~/.scwrc and retry

```console
root@yourmachine> scw run --name="buildcowsay" builder
               _
 ___  ___ __ _| | _____      ____ _ _   _
/ __|/ __/ _` | |/ _ \ \ /\ / / _` | | | |
\__ \ (_| (_| | |  __/\ V  V / (_| | |_| |
|___/\___\__,_|_|\___| \_/\_/ \__,_|\__, |
                                    |___/

Welcome on An image to build other images (GNU/Linux 4.4.4-docker-3 x86_64 )

System information as of: Thu Mar 17 16:04:37 UTC 2016

System load:	0.09		Int IP Address:	X.X.X.X
Memory usage:	3.7%		Pub IP Address:	YOUR_IP
Usage on /:	1%		Swap usage:	0.0%
Local Users:	0		Processes:	92
Image build:	2016-03-17	System uptime:	5 min
Disk nbd0:	l_ssd 150G

Documentation:	https://scaleway.com/docs
Community:	https://community.scaleway.com
Image source:	https://github.com/scaleway/image-tools/tree/master/image-builder


Docker 1.10.3 is running using the 'aufs' storage driver.
Installed tools: docker-compose, nsenter, gosu and pipework are installed.

*****************************************************************************

   Welcome on the image-builder.
   Here, you'll be able to craft your own images.

   To configure your environment please run:

   $> image-builder-configure

*****************************************************************************


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

root@buildcowsay:~# image-builder-configure
Login (cloud.scaleway.com):                     # yourmail
Password:                                       # yourpassword
root@buildcowsay:~# mkdir vivid-cowsay
root@buildcowsay:~# cp Makefile vivid-cowsay
root@buildcowsay:~# cd vivid-cowsay
root@buildcowsay:~/vivid-cowsay# touch Dockerfile
root@buildcowsay:~/vivid-cowsay# ls -l
total 4
-rw-r--r-- 1 root root   0 Aug 28 15:35 Dockerfile
-rw-r--r-- 1 root root 146 Aug 28 15:19 Makefile
```
##### 2. Configuring your Makefile
```console
NAME =                  YOUR_NAME
VERSION =               latest
VERSION_ALIASES =       X.X.X X.X X
TITLE =                 YOUR_TITLE
DESCRIPTION =           YOUR_DESCRIPTION
DOC_URL =
SOURCE_URL =            https://github.com/scaleway-community/...
VENDOR_URL =
DEFAULT_IMAGE_ARCH =	x86_64


IMAGE_VOLUME_SIZE =     50G
IMAGE_BOOTSCRIPT =      stable
IMAGE_NAME =            YOUR_IMAGE_NAME

## Image tools  (https://github.com/scaleway/image-tools)
all:	docker-rules.mk
docker-rules.mk:
	wget -qO - http://j.mp/scw-builder | bash
-include docker-rules.mk
```


##### 3. Generating a Dockerfile

**Copy-Paste** this in your `Dockerfile` [see more](https://docs.docker.com/reference/builder/)

> Note: Please don't remove the comments #FROM scaleway/distribution:arch-version # arch=arch

> These lines are used by Makefile to handle the multiarch

```dockerfile
FROM scaleway/ubuntu:amd64-vivid
# following 'FROM' lines are used dynamically thanks do the image-builder
# which dynamically update the Dockerfile if needed.
#FROM scaleway/ubuntu:armhf-vivid       # arch=armv7l
#FROM scaleway/ubuntu:arm64-vivid       # arch=arm64
#FROM scaleway/ubuntu:i386-vivid        # arch=i386
#FROM scaleway/ubuntu:mips-vivid        # arch=mips

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
wget -qO - http://j.mp/scw-builder | bash
--2016-03-17 16:10:16--  https://raw.githubusercontent.com/scaleway/image-tools/master/builder/docker-rules.mk
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 23.235.43.133
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|23.235.43.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 15555 (15K) [text/plain]
Saving to: ‘docker-rules.mk’

docker-rules.mk                 100%[======================================================>]  15.19K  --.-KB/s   in 0s

2016-03-17 16:10:16 (191 MB/s) - ‘docker-rules.mk’ saved [15555/15555]

test -f /tmp/create-image-from-http.sh \
	|| wget -qO /tmp/create-image-from-http.sh https://github.com/scaleway/scaleway-cli/raw/master/examples/create-image-from-http.sh
chmod +x /tmp/create-image-from-http.sh
touch .overlays
test x86_64 = x86_64 || make setup_binfmt
docker build  -t scaleway/vivi-cowsay:amd64-latest .
Sending build context to Docker daemon 20.48 kB
Step 1 : FROM scaleway/ubuntu:amd64-vivid
amd64-vivid: Pulling from scaleway/ubuntu
e9586e5b9ad2: Pull complete
a3ed95caeb02: Pull complete
37a44f3d6a30: Pull complete
0a9b3a409bb2: Pull complete
1565b658a7d3: Pull complete
18fdd013ceef: Pull complete
495ce841461d: Pull complete
720f0eb3ddb4: Pull complete
3dd2a69f65c5: Pull complete
44e34986b9ca: Pull complete
e19bd2502ccc: Pull complete
50b6002165c9: Pull complete
790438461d3e: Pull complete
25094c3e11d6: Pull complete
19710586a54e: Pull complete
e3fb4b95b6ce: Pull complete
Digest: sha256:ff4cbc6da93ac019ed774c9ebf62e7282fc4affa223406bfca987425dde370dd
Status: Downloaded newer image for scaleway/ubuntu:amd64-vivid
 ---> ed908762e95f
Step 2 : RUN /usr/local/sbin/scw-builder-enter
 ---> Running in 989d6f290423
Adding 'local diversion of /sbin/initctl to /sbin/initctl.distrib'
 ---> ea2155d26339
Removing intermediate container 989d6f290423
Step 3 : RUN apt-get install -y cowsay
 ---> Running in 47c2705b5a32
Reading package lists...
Building dependency tree...
Reading state information...
Suggested packages:
  filters
The following NEW packages will be installed:
  cowsay
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 18.3 kB of archives.
After this operation, 91.1 kB of additional disk space will be used.
Get:1 http://archive.ubuntu.com/ubuntu/ vivid/universe cowsay all 3.03+dfsg1-10 [18.3 kB]
debconf: delaying package configuration, since apt-utils is not installed
Fetched 18.3 kB in 0s (64.0 kB/s)
Selecting previously unselected package cowsay.
(Reading database ... 19694 files and directories currently installed.)
Preparing to unpack .../cowsay_3.03+dfsg1-10_all.deb ...
Unpacking cowsay (3.03+dfsg1-10) ...
Processing triggers for man-db (2.7.0.2-5) ...
Setting up cowsay (3.03+dfsg1-10) ...
 ---> 964dd2187c42
Removing intermediate container 47c2705b5a32
Step 4 : RUN /usr/local/sbin/scw-builder-leave
 ---> Running in 926a6f8e066d
Removing 'local diversion of /sbin/initctl to /sbin/initctl.distrib'
 ---> c13d01959fc8
Removing intermediate container 926a6f8e066d
Successfully built c13d01959fc8
for tag in 2016-03-17 1; do							                                   \
  echo docker tag -f scaleway/vivi-cowsay:amd64-latest scaleway/vivi-cowsay:amd64-$tag;   \
  docker tag -f scaleway/vivi-cowsay:amd64-latest scaleway/vivi-cowsay:amd64-$tag;	   \
done
docker tag -f scaleway/vivi-cowsay:amd64-latest scaleway/vivi-cowsay:amd64-2016-03-17
Warning: '-f' is deprecated, it will be removed soon. See usage.
docker tag -f scaleway/vivi-cowsay:amd64-latest scaleway/vivi-cowsay:amd64-1
Warning: '-f' is deprecated, it will be removed soon. See usage.
docker inspect -f '{{.Id}}' scaleway/vivi-cowsay:amd64-latest > .docker-container-x86_64.built
mkdir -p /tmp/build/x86_64-vivi-cowsay-latest/
docker run --name vivi-cowsay-latest-export --entrypoint /dontexists scaleway/vivi-cowsay:amd64-latest 2>/dev/null || true
docker export vivi-cowsay-latest-export > /tmp/build/x86_64-vivi-cowsay-latest/export.tar.tmp
docker rm vivi-cowsay-latest-export
vivi-cowsay-latest-export
mv /tmp/build/x86_64-vivi-cowsay-latest/export.tar.tmp /tmp/build/x86_64-vivi-cowsay-latest/export.tar
rm -rf /tmp/build/x86_64-vivi-cowsay-latest/rootfs /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tmp
mkdir -p /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tmp
tar -C /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tmp -xf /tmp/build/x86_64-vivi-cowsay-latest/export.tar
rm -f /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tmp/.dockerenv /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tmp/.dockerinit
chmod 1777 /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tmp/tmp
chmod 755 /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tmp/etc /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tmp/usr /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tmp/usr/local /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tmp/usr/sbin
chmod 555 /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tmp/sys
chmod 700 /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tmp/root
mv /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tmp/etc/hosts.default /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tmp/etc/hosts || true
echo "IMAGE_ID=\"vivid-cowsay\"" >> /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tmp/etc/scw-release
echo "IMAGE_RELEASE=2016-03-17" >> /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tmp/etc/scw-release
echo "IMAGE_CODENAME=vivi-cowsay" >> /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tmp/etc/scw-release
echo "IMAGE_DESCRIPTION=\"\"" >> /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tmp/etc/scw-release
echo "IMAGE_HELP_URL=\"https://community.scaleway.com\"" >> /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tmp/etc/scw-release
echo "IMAGE_SOURCE_URL=\"https://github.com/scaleway-community/...\"" >> /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tmp/etc/scw-release
echo "IMAGE_DOC_URL=\"\"" >> /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tmp/etc/scw-release
mv /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tmp /tmp/build/x86_64-vivi-cowsay-latest/rootfs
tar --format=gnu -C /tmp/build/x86_64-vivi-cowsay-latest/rootfs -cf /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tar.tmp .
mv /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tar.tmp /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tar
ln -sf /tmp/build/x86_64-vivi-cowsay-latest/rootfs.tar /tmp/build/x86_64-vivi-cowsay-latest/x86_64-vivi-cowsay-latest.tar
IMAGE_ARCH="x86_64" VOLUME_SIZE="50G" IMAGE_NAME="vivid-cowsay 1.0" IMAGE_BOOTSCRIPT="stable" /tmp/create-image-from-http.sh http://YOUR_IP:8000/x86_64-vivi-cowsay-latest/x86_64-vivi-cowsay-latest.tar
[+] URL of the tarball: http://YOUR_IP:8000/x86_64-vivi-cowsay-latest/x86_64-vivi-cowsay-latest.tar
[+] Target name: x86_64-vivi-cowsay-latest.tar
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
[+] Image created: 53962798-2933-4cc9-b6c9-1e05f6ff7051   # YOUR_IMAGE_ID
[+] Deleting temporary server
[+] Server deleted
```
Your custom image is now available [here](https://cloud.scaleway.com/#/images)

##### 4. Running your custom image
```console
root@buildcowsay:~/vivid-cowsay# scw run --tmp-ssh-key --name="my-vivid-with-cowsay"  YOUR_IMAGE_ID
               _
 ___  ___ __ _| | _____      ____ _ _   _
/ __|/ __/ _` | |/ _ \ \ /\ / / _` | | | |
\__ \ (_| (_| | |  __/\ V  V / (_| | |_| |
|___/\___\__,_|_|\___| \_/\_/ \__,_|\__, |
                                    |___/

Welcome on  (GNU/Linux 4.4.4-std-3 x86_64 )

System information as of: Thu Mar 17 16:19:29 UTC 2016

System load:	0.00		Int IP Address:	X.X.X.X
Memory usage:	2.7%		Pub IP Address:	X.X.X.X
Usage on /:	2%		Swap usage:	0.0%
Local Users:	0		Processes:	106
Image build:	2016-03-17	System uptime:	0 min
Disk nbd0:	l_ssd 50G

Documentation:
Community:	https://community.scaleway.com
Image source:	https://github.com/scaleway-community/...


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

root@my-vivid-with-cowsay:~# cowsay "Hello from my custom vivid"
 ____________________________
< Hello from my custom vivid >
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

Or run builder with C1

```console
root@yourmachine> scw run --name="buildcowsay" --commercial-type=C1 builder
```


## Changelog

### Unreleased
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
