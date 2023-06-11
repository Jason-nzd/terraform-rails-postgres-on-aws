#!/bin/bash
sudo dnf update -y
sudo dnf install -y postgresql15 git ruby ruby-devel gcc zlib zlib-devel postgresql-devel iptables

gem install bundler
gem install rails

source /etc/profile.d/bundler.sh

cd /home/ec2-user
rails new myapp -d postgresql

cd myapp

# Set DB endpoint in config/database.yml
sed -i "s/#host: localhost/host: ${db_endpoint}/g" config/database.yml

# Set DB username in config/database.yml
sed -i "23 i username: ${db_username}" config/database.yml

# Set DB password to ENV, then ENV to config/database.yml
echo "export MYAPP_DATABASE_PASSWORD=${db_password}" >> ~/.bashrc
source ~/.bashrc
sed -i "24 i password: <%= ENV['MYAPP_DATABASE_PASSWORD'] %>" config/database.yml

# Set DB name in config/database.yml
sed -i "s/database: myapp_development/database: ${db_name}/g" config/database.yml

# Whitelist amazonaws.com dynamic domains
sed -i "5 i config.hosts << \/[a-z0-9\\-.]+\.amazonaws\.com\/" config/environments/development.rb

# Route default port 3000 to 80
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 3000

# Run server bound to 0.0.0.0
rails server -b 0.0.0.0
