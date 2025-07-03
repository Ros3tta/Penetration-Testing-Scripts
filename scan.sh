#!/bin/bash

# Check for CIDR range argument
if [ -z "$1" ]; then
    echo "Usage: $0 <cidr_range>"
    exit 1
fi

CIDR="$1"

# Temporary files
FPING_OUT=$(mktemp)
NMAP_OUT=$(mktemp)

# -----[fping]-----
echo "-----[fping - host discovery]-----"
fping -agq "$CIDR" 2>/dev/null | tee "$FPING_OUT"

# -----[nmap]-----
echo -e "\n-----[nmap - host discovery]-----"
nmap -sn "$CIDR" | grep "scan report" | cut -d " " -f 5 | tee "$NMAP_OUT"

# Combine and deduplicate
cat "$FPING_OUT" "$NMAP_OUT" | sort -u > targets

# Cleanup temp files
rm "$FPING_OUT" "$NMAP_OUT"

# Run full nmap scan
echo -e "\n-----[nmap - target scanning]-----"
nmap -sVC -Pn -iL targets | grep -vE "Host is up|Not shown|report any|Nmap done"
