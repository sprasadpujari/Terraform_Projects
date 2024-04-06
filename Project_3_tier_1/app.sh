#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
#cat " APPLICATION Hosted !!" >> /var/www/html/app.html
sudo systemctl start httpd
sudo systemctl enable httpd
#chkconfig httpd on
echo "<h1>This terraform 3-tier Module project is finally Worked.EC2 instance launched in us-west-2a!!!</h1>" > var/www/html/index.htmlyes