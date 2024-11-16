# Flush all existing rules to start fresh
sudo iptables -F
sudo iptables -X

# Set default policies to drop everything by default
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

# Allow loopback traffic
sudo iptables -A INPUT -i lo -j ACCEPT

# Allow established and related connections
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow outgoing DNS traffic (for resolving domain names)
sudo iptables -A OUTPUT -p udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
sudo iptables -A OUTPUT -p tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT

# Allow outgoing HTTP and HTTPS traffic for browsing
sudo iptables -A OUTPUT -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT
sudo iptables -A OUTPUT -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT

# Allow incoming Splunk forwarder traffic on port 9997
sudo iptables -A INPUT -p tcp --dport 9997 -m conntrack --ctstate NEW -j ACCEPT

# Allow rsyslog traffic on ports 1514-1517
sudo iptables -A INPUT -p tcp --dport 1514:1517 -m conntrack --ctstate NEW -j ACCEPT

# Allow access to port 8000
sudo iptables -A INPUT -p tcp --dport 8000 -m conntrack --ctstate NEW -j ACCEPT

# Drop all other traffic explicitly
sudo iptables -A INPUT -j DROP

# Save the rules to persist across reboots
sudo iptables-save | sudo tee /etc/iptables/rules.v4


