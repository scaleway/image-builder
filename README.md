# Build your server images on Scaleway

This image contains all the requirements to build custom images for Scaleway
servers.


## Usage

Once your server is booted `cd` into the `/src` directory and start your own
image development.

You can test your image with docker by building the container:

```
make IMAGE_DIR=/src/image-foobar/ image
```

When you are satisfied build and release your image:
```
make IMAGE_DIR=/src/image-foobar/ scaleway_image
```

If you want to specify an architecture different from your host one use:
```
make ARCH=arm64 IMAGE_DIR=/src/image-foobar/ scaleway_image
```

For a full documentation on how to build your own images, read the
[https://github.com/scaleway/image-tools](image-tools) page.


## Distribution

You can contact the admins of #scaleway on `irc.online.net`.


## Know issues

- if you have an error when you try to connect on your Scaleway account,
  remove `~/.scwrc` and retry


## Changelog

### 1.5.0 (2018-10-18)

* Use the new build system
* Bump scw @1.17

### 1.4.3 (2016-10-24)

* Bump scw @1.10.1

### 1.4.2 (2016-04-04)

* Bump scw @1.9.0

### 1.4.1 (2016-03-30)

* Use 50GB instead of 150GB
* Bump scw @1.8.1

### 1.4.0 (2016-03-21)
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


## Links
- [Maartje Eyskens: Multiarch Docker images](https://eyskens.me/multiarch-docker-images/)

---

#### A note about the Makefile system

All our images are using a simple Makefile containing only variables and including the [docker-rules.mk](https://github.com/scaleway/image-tools/blob/master/builder/docker-rules.mk) file that is downloaded on the first run.

The `docker-rules.mk` script is [regularly updated](https://github.com/scaleway/image-tools/commits/master/builder/docker-rules.mk), so it is more convenient to keep downloading a fresh copy regularly.

We are using a `curl ... | bash` install method which can be considered as unsafe. But this command is only used in the build step of the image, as soon as you start a Scaleway server, this command won't be run.

---

A project by [![Scaleway](https://avatars1.githubusercontent.com/u/5185491?v=3&s=42)](https://www.scaleway.com/)
