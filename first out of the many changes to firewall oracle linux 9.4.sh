# Flush 
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

# Allow incoming Splunk forwarder traffic on port 9997
sudo iptables -A INPUT -p tcp --dport 9997 -m conntrack --ctstate NEW -j ACCEPT

# Allow rsyslog traffic on ports 1514-1517
sudo iptables -A INPUT -p tcp --dport 1514:1517 -m conntrack --ctstate NEW -j ACCEPT


# Drop all other traffic explicitly
sudo iptables -A INPUT -j DROP

# Save the rules to persist across reboots
sudo iptables-save | sudo tee /etc/iptables/rules.v4