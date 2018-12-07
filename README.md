# wekan-deb
Debian Package for Wekan

Supported operating systems :

* [Debian Wheezy 7.x amd64](https://www.debian.org/)
* [Devuan Jessie 1.x amd64](https://devuan.org/)

Provides : Wekan (OFT Packages)

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
wget https://github.com/soohwa/wekan-deb/releases/download/v1.84/wekan-oft-0_1.84.0-1_amd64.deb
gdebi wekan-oft-0_1.84.0-1_amd64.deb
```

## 4. Configuration

Default values are in `/etc/default/wekan-oft-0`

Please, modifiy the default values in `/etc/wekan-oft-0`

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
