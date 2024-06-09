
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
tar xvfz node_exporter-1.5.0.linux-amd64.tar.gz
sudo mv node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/bin/
rm -rf node_exporter-1.5.0.linux-amd64 node_exporter-1.5.0.linux-amd64.tar.gz
sudo useradd -rs /bin/false node_exporter
sudo nano /etc/systemd/system/node_exporter.service



#[Unit]
#Description=Node Exporter
#Wants=network-online.target
#After=network-online.target

#[Service]
#User=node_exporter
#Group=node_exporter
#Type=simple
#ExecStart=/usr/local/bin/node_exporter

#[Install]
#WantedBy=multi-user.target


sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter
sudo systemctl status node_exporter
