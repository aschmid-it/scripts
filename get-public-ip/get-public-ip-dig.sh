#!/bin/bash
#
# A Schmid IT
#
# Script to show the public IP of the network based on dig response 
#
##

# Cloudflare
echo "Cloudflare:"
echo "- IPv4: `dig -4 +short @1.1.1.1 ch txt whoami.cloudflare | awk -F'"' '{ print $2}'`"
echo "- IPv6: `dig -6 +short @2606:4700:4700::1111 ch txt whoami.cloudflare | awk -F'"' '{ print $2}'`"

# Google
echo "Google:"
echo "- IPv4: `dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}'`"
echo "- IPv6: `dig -6 TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}'`"
