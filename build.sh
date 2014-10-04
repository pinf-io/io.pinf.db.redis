#!/bin/bash -e

# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-redis


if [ -d "../../redis-2.8.9" ]; then
	cp -Rf ../../redis-2.8.9 redis
else
	sudo apt-get update
	sudo apt-get -y install build-essential tcl8.5
	wget http://download.redis.io/releases/redis-2.8.9.tar.gz
	tar xzf redis-2.8.9.tar.gz
	mv redis-2.8.9 redis
	cd redis
	make
	cd ..
	cp -Rf redis ../../redis-2.8.9
fi
