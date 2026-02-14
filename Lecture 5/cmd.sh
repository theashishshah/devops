ifconfig
ip a # check ip data
ethtool -i enX0

# there is a chance of network interface is down -> can't do ssh
ip link set enX0 down # to down the network interface
ip link set virtualInterface up # to make it up
ping ipaddress #
dig domain.com

# How can i stop internet while it is connected to my machine
# What's nginx and why and how do we use it?
# What's DNS at all? and how cloudflare is used

# what's DNS issue? why it is not resolving

ip route

sudo cat /etc/resolv.conf
resolvectl status

dig domai.com ipaddress

sudo lsof -i :portnumber
# check EC2 security group
sudo ufw status # firewall
sudo ufw enable # to enable
sudo ufw allow ssh
sudo ufw status verbose
sudo ufw allow https or http or tch/443

# both level firewall: infra and ec2 level
sudo ufw default deny outgoing # to block outgoing connection from the server
# we can blcok specific IP, PORT and vice versa
sudo ufw default allow outgoing
# we've IP table
hostname
uname -h
sudo hostname name-of-the-machine

# instead of logging using ip address, we can give a name to our machine and map the machine hostname to the given name, so that we don't have to login again with IP address

sudo vim /etc/hosts # map