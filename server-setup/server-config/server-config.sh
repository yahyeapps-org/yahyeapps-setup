#!/bin/bash
 
echo "$MYecho "$MYSUDOPASS" | sudo -S COMMANDPASS" | suddo -S -v

while true; do
  echo "$MYecho "$MYSUDOPASS" | sudo -S COMMANDPASS" | suddo -S -v
  sleep 60
done &


echo "soodhoow yahye" | echo "$MYSUDOPASS" | sudo -S COMMAND tee /etc/motd

echo "$MYSUDOPASS" | sudo -S COMMAND apt update -y 
echo "$MYSUDOPASS" | sudo -S COMMAND apt-get update -y 

# install ufw 
echo "$MYSUDOPASS" | sudo -S COMMAND apt install ufw -y
echo "$MYSUDOPASS" | sudo -S COMMAND cp ~/server-setup/server-config/update-cloudflare-ufw.sh /usr/local/bin/ 
echo "$MYSUDOPASS" | sudo -S COMMAND chmod +x /usr/local/bin/update-cloudflare-ufw.sh
echo "0 0 * * * /usr/local/bin/update-cloudflare-ufw.sh >/dev/null 2>&1" | echo "$MYSUDOPASS" | sudo -S COMMAND crontab -u root -


bash /usr/local/bin/update-cloudflare-ufw.sh 

# install cron
echo "$MYSUDOPASS" | sudo -S COMMAND apt install cron -y
#install git
echo "$MYSUDOPASS" | sudo -S COMMAND apt install git -y
git config --global user.name "yahyeapps2022"
git config --global user.email "yahyeapps2022@gmail.com"

#install k3s
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable traefik" sh -
echo "$MYSUDOPASS" | sudo -S COMMAND chmod 644 /etc/rancher/k3s/k3s.yaml
echo "$MYSUDOPASS" | sudo -S COMMAND chown $USER:$USER /etc/rancher/k3s/k3s.yaml
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' >> ~/.bashrc
source ~/.bashrc

# install helm 
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version


#!/bin/bash
echo "🚀 Optimizing WebSockets for 10,000+ connections..."

# --- Step 1: Kernel Limits (sysctl) ---
echo "🔧 Updating kernel parameters..."

# Remove old block if exists
echo "$MYSUDOPASS" | sudo -S COMMAND sed -i '/# WEB SOCKET TUNING START/,/# WEB SOCKET TUNING END/d' /etc/sysctl.conf

# Add new block
echo "$MYSUDOPASS" | sudo -S COMMAND tee -a /etc/sysctl.conf > /dev/null <<EOF
# WEB SOCKET TUNING START
# Increase pending connections queue
net.core.somaxconn=65535
net.ipv4.tcp_max_syn_backlog=65535

# Allow more TCP connections
net.ipv4.ip_local_port_range=1024 65535

# Optimize TIME_WAIT sockets
net.ipv4.tcp_fin_timeout=10
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_max_tw_buckets=5000000

# Increase available file descriptors
fs.file-max=5000000
# WEB SOCKET TUNING END
EOF

echo "$MYSUDOPASS" | sudo -S COMMAND sysctl --system

# --- Step 2: File Descriptors and Process Limits ---
echo "🔧 Updating user limits..."

for file in /etc/security/limits.conf /etc/systemd/system.conf /etc/systemd/user.conf; do
  echo "$MYSUDOPASS" | sudo -S COMMAND sed -i '/# WEB SOCKET TUNING START/,/# WEB SOCKET TUNING END/d' "$file"

  echo "$MYSUDOPASS" | sudo -S COMMAND tee -a "$file" > /dev/null <<EOF
# WEB SOCKET TUNING START
* soft nofile 1000000
* hard nofile 1000000
* soft nproc 100000
* hard nproc 100000
DefaultLimitNOFILE=1000000
DefaultLimitNPROC=100000
# WEB SOCKET TUNING END
EOF
done

echo "$MYSUDOPASS" | sudo -S COMMAND systemctl daemon-reexec
echo "✅ WebSocket tuning applied!"
