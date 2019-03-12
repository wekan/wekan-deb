# wekan-deb
Debian Package for Wekan

Supported operating systems :

* [Debian Wheezy 7.x amd64](https://www.debian.org/)
* [Devuan Jessie 1.x amd64](https://devuan.org/)

Provides : Wekan (OFT Packages)

# Build debian package with docker

## 1. Prerequisites

* [Docker](https://docs.docker.com/install/) must be installed.

## 2. Build the docker image

* Clone this repository: `git clone https://github.com/soohwa/wekan-deb.git && cd wekan-deb`
* Build the image: `make image`
* Build the debian package: `make deb`
* Clean the build repository: `make clean`
* You can do that in one command: `make image deb clean`
* The wekan debian package is created inside the build folder.

## 3. Release number configuration

* Nodejs: `NODE_RELEASE` in `Dockerfile` (do `make image` after the change)
* AppImage: `APPIMAGE_RELEASE` in `Dockerfile` (do `make image` after the change)
* Wekan: `wekan-release` in `Makefile` (do `make deb` after the change)

## 4. Notes

* On the docker command:
    * `--device /dev/fuse` in order to use AppImage inside docker
    * `--privileged` in order to allow fuse inside docker

# Install [Wekan](https://wekan.github.io/) on Debian with unofficial packages (OFT)

> OFT Packages = Only For Testing Packages : This packages are not suitable for production.

> Due to a [limitation of mongodb on 32 bit systems](https://www.mongodb.com/blog/post/32-bit-limitations) only 64 bit packages are provided.

## 1. Needed packages
```shell
# (root)
apt-get update
apt-get install apt-transport-https gdebi-core
# dirmngr is needed on Devuan 2 Ascii
apt-get install dirmngr
```

## 2. Add [MongoDB repository](https://docs.mongodb.com/v3.2/tutorial/install-mongodb-on-debian/)

Do not add this repository for Debian Stretch 9

```shell
# (root)
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb https://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.2 main" > /etc/apt/sources.list.d/mongodb-org-3.2.list
apt-get update
```

## 3. Install Wekan

```shell
# (root)
export WEKAN_RELEASE=2.38
wget https://github.com/soohwa/wekan-deb/releases/download/v${WEKAN_RELEASE}/wekan-oft-0_${WEKAN_RELEASE}.0-1_amd64.deb
gdebi wekan-oft-0_${WEKAN_RELEASE}.0-1_amd64.deb
```

## 4. Configuration

Default values are in `/etc/default/wekan-oft-0`

Please, modifiy the default values in `/etc/wekan/wekan-oft-0`

```shell
export MONGO_URL='mongodb://127.0.0.1:27017/wekan'
export ROOT_URL='http://127.0.0.1:3000'
export MAIL_FROM='wekan-admin@localhost'
export PORT=3000
```

And restart the server :

```shell
/etc/init.d/wekan-oft-0 restart
```

So now, you can access to wekan at http://localhost:3000/
