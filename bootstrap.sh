#!/usr/bin/env bash

# Prevent
export DEBIAN_FRONTEND=noninteractive

# Install Git
printf "Step 1 of 19: Installing git & cloning netbox-vagrant..."
apt-get install git -y -qq > /dev/null
cd /tmp/ && git clone -b master https://github.com/ryanmerolle/netbox-vagrant.git

# Update Ubuntu
printf "Step 2 of 19: Updating Ubuntu..."
apt-get update -y -qq > /dev/null

# Install Postgres & start service
printf "Step 3 of 19: Installing & starting Postgres..."
apt-get install postgresql libpq-dev -y -qq > /dev/null
sudo service postgresql start

# Setup Postgres with netbox user, database, and permissions
printf "Step 4 of 19: Setup Postgres with netbox user, database, & permissions."
sudo -u postgres psql -c "CREATE DATABASE netbox"
sudo -u postgres psql -c "CREATE USER netbox WITH PASSWORD 'J5brHrAXFLQSif0K'"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE netbox TO netbox"

# Install Apache
printf "Step 5 of 19: Installing Apache..."
apt-get install apache2 -y -qqm> /dev/null

# Install Python 2
printf "Step 6 of 19: Installing Python 2..."
apt-get install python2.7 python-dev python-pip libxml2-dev libxslt1-dev libffi-dev graphviz libpq-dev libssl-dev -y -qq > /dev/null

# Install gunicorn & supervisor
printf "Step 7 of 19: Installing gunicorn & supervisor..."
apt-get install gunicorn supervisor -y -qq > /dev/null

printf "Step 8 of 19: Cloning NetBox repo..."
# Create netbox base directory & navigate to it
mkdir -p /opt/netbox/ && cd /opt/netbox/
# git clone netbox master branch
git clone -b master https://github.com/digitalocean/netbox.git .

# Upgrade pip
printf "Step 8 of 19: Cloning NetBox repo..."
pip install --upgrade pip

# Install NetBox requirements
printf "Step 9 of 19: Installing NetBox requirements..."
pip install -r requirements.txt

# Use configuration.example.py to create configuration.py
printf "Step 10 of 19: Configuring Netbox..."
cp /opt/netbox/netbox/netbox/configuration.example.py /opt/netbox/netbox/netbox/configuration.py
# Update configuration.py with database user, database password, netbox generated SECRET_KEY, & Allowed Hosts
sed -i "s/'USER': '',  /'USER': 'netbox',  /g" /opt/netbox/netbox/netbox/configuration.py
sed -i "s/'PASSWORD': '',  /'PASSWORD': 'J5brHrAXFLQSif0K',  /g" /opt/netbox/netbox/netbox/configuration.py
sed -i "s/ALLOWED_HOSTS \= \[\]/ALLOWED_HOSTS \= \['netbox.internal.local', 'netbox.localhost', 'localhost', '127.0.0.1'\]/g" /opt/netbox/netbox/netbox/configuration.py
SECRET_KEY=$( python /opt/netbox/netbox/generate_secret_key.py )
sed -i "s/SECRET_KEY \= ''/SECRET_KEY = '$SECRET_KEY'/g" /opt/netbox/netbox/netbox/configuration.py
# Clear SECRET_KEY variable
unset SECRET_KEY

# Setup apache, gunicorn, & supervisord config using premade examples (need to change netbox-setup)
printf "Step 11 of 19: Configuring Apache..."
cp /tmp/netbox-vagrant/config_files/apache-netbox.example.conf /etc/apache2/sites-available/netbox.conf
printf "Step 12 of 19: Configuring gunicorn..."
cp /tmp/netbox-vagrant/config_files/gunicorn_config.example.py /opt/netbox/gunicorn_config.py
printf "Step 13 of 19: Configuring supervisor..."
cp /tmp/netbox-vagrant/config_files/supervisord-netbox.example.conf /etc/supervisor/conf.d/netbox.conf

# Apache Setup (enable the proxy and proxy_http modules, and reload Apache)
printf "Step 14 of 19: Completing web service setup..."
a2enmod proxy
a2enmod proxy_http
a2ensite netbox
service apache2 restart
service supervisor restart

# Install the database schema
printf "Step 15 of 19: Install the database schema..."
python /opt/netbox/netbox/manage.py migrate

# Create admin / admin superuser
printf "Step 16 of 19: Create NetBox superuser..."
echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin@example.com', 'admin', 'admin')" | python /opt/netbox/netbox/manage.py shell

# Collect Static Files
printf "Step 17 of 19: collectstatic"
python /opt/netbox/netbox/manage.py collectstatic --no-input <<<yes

# Load Initial Data (Optional) Comment out if you like
printf "Step 18 of 19: Load intial data."
python /opt/netbox/netbox/manage.py loaddata initial_data

# Cleanup netbox-vagrant setup
printf "Step 19 of 19: Cleaning up netbox-vagrant setup files..."
rm -rf /tmp/netbox-vagrant/
printf "netbox-vagrant setup files deleted...\n"

# Status Complete
printf "COMPLETE: NetBox-Demo Provisioning COMPLETE!!"
printf "To login to the Vagrant VM use vagrant ssh in the current directory"
printf "To login to the Netbox-Demo webportal go to http://netbox.localhost:8080"