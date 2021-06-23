#!/bin/bash
yum update
yum -y install httpd

systemctl start httpd

echo "<h2>Instance-id:$(curl -s http://169.254.169.254/latest/meta-data/instance-id)</h2>" >> /var/www/html/index.html
echo "<h3>Local-ipv4:$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)</h3>" >> /var/www/html/index.html

