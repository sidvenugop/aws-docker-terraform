#Create a systemd service file to run script docker.sh everytime system reboots

sudo cat > /etc/systemd/system/dunhumby-container.service << EOF
[Unit]
Description=Run docker.sh

[Service]
ExecStart=/tmp/docker.sh
Restart=on-failure
EOF

# Restart daemon, enable and start service
    echo "Reloading daemon and enabling service"
    sudo systemctl daemon-reload 
    sudo systemctl enable dunhumby-container.service
    sudo systemctl start dunhumby-container.service
    echo "Service Started"
