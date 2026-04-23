#!/bin/bash

echo "$MYSUDOPASS" | sudo -S bash -c '

set -euo pipefail

echo "soodhoow yahye" | tee /etc/motd

apt update -y
apt install -y ufw cron git curl

cp /tmp/server-setup/server-config/update-cloudflare-ufw.sh /usr/local/bin/
chmod +x /usr/local/bin/update-cloudflare-ufw.sh

echo "0 0 * * * /usr/local/bin/update-cloudflare-ufw.sh >/dev/null 2>&1" | crontab -

bash /usr/local/bin/update-cloudflare-ufw.sh

# ======================
# k3s install
# ======================
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable traefik" sh -

chmod 644 /etc/rancher/k3s/k3s.yaml
chown yahyeapps:yahyeapps /etc/rancher/k3s/k3s.yaml

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# ======================
# sysctl tuning
# ======================
sed -i "/# WEB SOCKET TUNING START/,/# WEB SOCKET TUNING END/d" /etc/sysctl.conf

cat >> /etc/sysctl.conf <<EOF
# WEB SOCKET TUNING START
net.core.somaxconn=65535
net.ipv4.tcp_max_syn_backlog=65535
net.ipv4.ip_local_port_range=1024 65535
net.ipv4.tcp_fin_timeout=10
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_max_tw_buckets=5000000
fs.file-max=5000000
# WEB SOCKET TUNING END
EOF

sysctl --system

# ======================
# limits
# ======================
for file in /etc/security/limits.conf /etc/systemd/system.conf /etc/systemd/user.conf; do
  sed -i "/# WEB SOCKET TUNING START/,/# WEB SOCKET TUNING END/d" "$file"

  cat >> "$file" <<EOF
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

systemctl daemon-reexec

echo "✅ Server setup completed"
'