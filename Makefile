git_branch=6.0
git_repo=https://github.com/kamailio/kamailio
include_modules=db_mysql tls kafka

image_name=kamailio:$(git_branch)

dev_libs=	abuild git gcc build-base pkgconfig bison db-dev gawk flex expat-dev \
			perl-dev postgresql-dev python3-dev pcre2-dev mariadb-dev \
			libxml2-dev curl-dev unixodbc-dev confuse-dev ncurses-dev \
			sqlite-dev lua-dev openldap-dev net-snmp-dev libuuid libev-dev \
			jansson-dev json-c-dev libevent-dev linux-headers \
         	libmemcached-dev rabbitmq-c-dev hiredis-dev libmaxminddb-dev \
			libunistring-dev freeradius-client-dev lksctp-tools-dev ruby-dev \
         	wireshark-common tcpdump mongo-c-driver-dev sudo libwebsockets-dev \
         	mosquitto-dev librdkafka-dev nghttp2-dev libjwt-dev

build:
	docker build -t $(image_name) \
	--build-arg GIT_BRANCH=$(git_branch) \
	--build-arg GIT_REPO=$(git_repo) \
	--build-arg INCLUDE_MODDULES="$(include_modules)" \
	--build-arg DEV_LIBS="$(dev_libs)" \
	--progress plain .

copy-etc:
	docker cp km:/usr/local/etc/kamailio ./kamailio
dev0:
	docker run --name km $(image_name)
run:
	docker run --name km \
	-v $$PWD/kamailio:/usr/local/etc/kamailio \
	$(image_name)
rm:
	docker rm -f km
