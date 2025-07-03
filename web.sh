#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <target_ip> <port>"
    exit 1
fi

target="$1"
port="$2"

# Use HTTPS by default on common HTTPS ports
if [[ "$port" == "443" || "$port" == "8443" || "$port" == "9443" ]]; then
    proto="https"
else
    proto="http"
fi

url="$proto://$target:$port"

echo "Scanning $url"

wafw00f -a "$url" | sed -n '/Checking/,$p'
echo -e ""
curl -skIL "$url"
curl -skIL -X OPTIONS "$url"
whatweb -a 3 "$url"
