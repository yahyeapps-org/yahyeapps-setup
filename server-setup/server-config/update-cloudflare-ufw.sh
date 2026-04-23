#!/bin/bash

# Flush old Cloudflare rules
  ufw --force reset

# Re-allow SSH
  ufw allow ssh

# Allow Cloudflare IPv4 on all ports
for ip in $(curl -s https://www.cloudflare.com/ips-v4); do
      ufw allow from $ip
done

# Allow Cloudflare IPv6 on all ports
for ip in $(curl -s https://www.cloudflare.com/ips-v6); do
      ufw allow from $ip
done

# Enable UFW
  ufw --force enable
