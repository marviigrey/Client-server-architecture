#!/bin/bash

# Install required packages
sudo apt-get update
sudo apt-get install apache2 -y

# Create a directory for the app
sudo mkdir /var/www/time-ip-display
sudo chown -R $USER:$USER /var/www/time-ip-display
sudo chmod -R 755 /var/www/time-ip-display

# Create the HTML file for the app
cat <<EOT > /var/www/time-ip-display/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Time and IP Display</title>
    <style>
        #time {
            font-size: 48px;
            text-align: center;
        }
        #ip {
            font-size: 24px;
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <h1>Current Time and IP Address:</h1>
    <div id="time"></div>
    <div id="ip"></div>
    <button onclick="displayTimeAndIp()">Display Time and IP</button>
    <script>
        function displayTime() {
            var now = new Date();
            var time = now.toLocaleTimeString();
            document.getElementById('time').innerHTML = time;
        }

        function displayIp() {
            fetch('https://api.ipify.org')
                .then(response => response.text())
                .then(ip => document.getElementById('ip').innerHTML = ip);
        }

        function displayTimeAndIp() {
            displayTime();
            displayIp();
        }
    </script>
</body>
</html>
EOT

# Configure Apache to serve the app
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/time-ip-display.conf
sudo sed -i 's/\/var\/www\/html/\/var\/www\/time-ip-display/g' /etc/apache2/sites-available/time-ip-display.conf
sudo a2ensite time-ip-display.conf
sudo systemctl restart apache2
