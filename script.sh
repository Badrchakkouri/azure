sudo apt-get -y install nginx
cd /etc/nginx/sites-enabled
sudo sed -i 's/listen 80 default_server;/listen 8080 default_server;/g' default
cd /var/www/html
sudo mv index.html index.html.old
sudo echo "
<h1 style=\"text-align: center;\"><span>Badr says hello from Azure!&nbsp;</span></h1>
<p><strong><img src=\"https://media.giphy.com/media/Cmr1OMJ2FN0B2/giphy.gif\" alt=\"\" width=\"500\" height=\"500\" style=\"display: block; margin-left: auto; margin-right: auto;\" /></strong></p>
" > index.html
sudo systemctl restart nginx


