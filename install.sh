#!/bin/bash
# auth : gfw-breaker

rpm -ihv http://installrepo.kaltura.org/releases/kaltura-release.noarch.rpm
yum install -y kaltura-nginx

rm -fr /etc/nginx/conf.d/*

mkdir -p /usr/local/nginx/content/cache
mkdir -p /usr/share/nginx/html

server_ip=$(curl -4 ip.sb)

for f in $(ls sites/*.conf); do
	sed -i "s/local_server_ip/$server_ip/g" $f
done

for f in $(ls pages/*.html); do
	sed -i "s/local_server_ip/$server_ip/g" $f
done

cp common/* /etc/nginx/
cp sites/* /etc/nginx/conf.d
cp pages/* /usr/share/nginx/html

mv /etc/init.d/kaltura-nginx /etc/init.d/nginx

chkconfig nginx on
service nginx restart

