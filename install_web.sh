#!/bin/bash
sudo dnf update -y
sudo dnf install -y postgresql15 git ruby ruby-devel gcc zlib zlib-devel postgresql-devel iptables

gem install bundler
gem install rails

rails new myapp -d postgresql

cd myapp
bundle install

# todo: configure database
# config/database.yml
# db_endpoint=${db_endpoint}
# sed -n 's/#host: localhost/host: $db_endpoint/g' config/database.yml
# db_username=${db_username}
# sed -n 's/username: app/username: $db_username/g' config/database.yml

#sed -n '5 i config.hosts << \/[a-z0-9\-.]+\.amazonaws\.com\/' config/environments/development.rb

sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 3000

rails server -b 0.0.0.0
