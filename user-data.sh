#!/bin/bash
yum update -y
yum install -y httpd
echo "yooloo" > /var/www/html/index.html
systemctl enable httpd ; systemctl start httpd