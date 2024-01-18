#!/bin/bash

interface="ens33"
gateway="192.168.0.1"
netmask="255.255.255.0"
dns="8.8.8.8"
start_ip=21   
end_ip=254   

# A function to set a new IP address
set_ip() {
  new_ip="192.168.0.$1"
  echo "Setting new IP: $new_ip"
  
  # Bring interface down, set new IP, update gateway and bring interface up
  ifconfig $interface down
  ifconfig $interface $new_ip netmask $netmask
  route add default gw $gateway
  echo "nameserver $dns" > /etc/resolv.conf
  ifconfig $interface up
}

# Read the last IP used from file
last_ip_file="last_ip.txt"
if [[ -f $last_ip_file ]]; then
  last_ip=$(cat $last_ip_file)
else
  last_ip=$start_ip
fi

# Next IP
next_ip=$((last_ip + 1))

# Check if reached the end of the IP range
if [[ $next_ip -gt $end_ip ]]; then
  echo "Reached the end of the IP range."
  exit 1
fi

# Set the new IP address
set_ip $next_ip

# Save the new IP for next iteration
echo $next_ip > $last_ip_file
