#!/bin/bash
# Simple Port Forwarding Installer for Ubuntu
# Author: shady
# GitHub: https://github.com/Vedoxion/Portforwarding-by-Victus

echo "=== Port Forwarding Installer ==="

# Ask user for source port
read -p "Enter the source port (incoming): " SRC_PORT

# Ask user for destination IP
read -p "Enter the destination IP: " DEST_IP

# Ask user for destination port
read -p "Enter the destination port: " DEST_PORT

# Enable IP forwarding
sudo sysctl -w net.ipv4.ip_forward=1

# Flush existing iptables rules (optional)
sudo iptables -F
sudo iptables -t nat -F

# Add port forwarding rules
sudo iptables -t nat -A PREROUTING -p tcp --dport $SRC_PORT -j DNAT --to-destination $DEST_IP:$DEST_PORT
sudo iptables -t nat -A POSTROUTING -j MASQUERADE

echo "✅ Port forwarding from $SRC_PORT → $DEST_IP:$DEST_PORT is now active!"
echo "You can save your rules with: sudo iptables-save > /etc/iptables/rules.v4"
