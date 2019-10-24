sudo apt-get -y install nginx
cd /etc/nginx/sites-enabled
sudo sed -i 's/listen 80 default_server;/listen 8080 default_server;/g' default
cd /var/www/html
sudo chown badr .
sudo mv index.nginx-debian.html index.html.old
sudo echo "Hello world! A message from Badr on Azure" > index.html
sudo systemctl restart nginx
