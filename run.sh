#!/bin/bash

# Error handling
function OwnError()
{
	echo -e "[ `date` ] $(tput setaf 1)$@$(tput sgr0)"
	exit $2
}

# Repository for rethinkdb
echo "Setup Repository For Rethinkdb, Please Wait..."
source /etc/lsb-release \
&& echo "deb http://download.rethinkdb.com/apt $DISTRIB_CODENAME main" > /etc/apt/sources.list.d/rethinkdb.list \
&& wget -qO- http://download.rethinkdb.com/apt/pubkey.gpg | sudo apt-key add - \
|| OwnError "Unable to setup rethinkdb repository, exit status = " $?

# Install wget and curl
echo "Executing: apt-get update, Please wait..."
apt-get update \
|| OwnError "Unable to execute apt-get update command, exit status = " $?

echo "Installing required packages, Please wait..."
apt-get -y install wget curl git rethinkdb android-tools-adb python autoconf automake libtool build-essential ninja-build libzmq3-dev libprotobuf-dev git graphicsmagick \
|| OwnError "Unable to install required packages, exit status = " $?

echo "Donwloading Node.js, Please Wait..."
cd /tmp && \
wget -c https://nodejs.org/dist/v8.6.0/node-v8.6.0.tar.gz \
|| OwnError "Unable to download Node.js, exit status = " $?

echo "Installing Node.js, Please Wait..."
tar xzf node-v*.tar.gz && \
rm node-v*.tar.gz && \
cd node-v* && \
export CXX="g++ -Wno-unused-local-typedefs" && \
./configure --ninja && \
make && \
make install && \
rm -rf /tmp/node-v* && \
cd /tmp && \
/usr/local/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js install \
|| OwnError "Unable to install Node.js, exit status = " $?

echo "Installing Bower, Please Wait..."
npm install -g bower \
|| OwnError "Unable to install Bower, exit status = " $?

echo "Installing ZeroMQ, Please wait..."
cd /opt
wget http://download.zeromq.org/zeromq-4.1.2.tar.gz \
&& tar -zxvf zeromq-4.1.2.tar.gz \
&& cd zeromq-4.1.2 \
&& ./configure --without-libsodium \
&& make \
&& make install \
|| OwnError "Unable to install ZeroMQ, exit status = " $?

echo "Setup Protocol Buffers, Please wait..."
cd /opt \
&& git clone https://github.com/google/protobuf.git \
&& cd protobuf \
&& ./autogen.sh \
&& ./configure \
&& make \
&& make install \
|| OwnError "Unable to Setup Protocol Buffers, exit status = " $?

echo "Installing STF, Please wait..."
npm install -g stf --unsafe-perm --allow-root \
|| OwnError "Unable to Installing STF, exit status = " $?