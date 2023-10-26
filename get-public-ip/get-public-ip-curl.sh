#!/bin/bash
#
# A Schmid IT
#
# Script to show the public IP of the network based on curl response from icanhazip
#
##

# IPv4
ipv4_cmd="curl -4 -s http://icanhazip.com"
ipv4_output=$($ipv4_cmd)
echo "- IPv4: $ipv4_output"

# IPv6
ipv6_cmd="curl -6 -s http://icanhazip.com"
ipv6_output=$($ipv6_cmd)
echo "- IPv6: $ipv6_output"

