#!/bin/bash


set -euo pipefail
set -x


# get CIDR from list
get_prefix() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv4_merged.txt > /tmp/"$1".txt
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv6_merged.txt >> /tmp/"$1".txt
}

get_prefix 'google' || echo 'failed'

# save ipv4
grep -v ':' /tmp/google.txt | sed 's/\/32//g' > /tmp/google-ipv4.txt
sed -i '/^0.0.0.0/d' /tmp/google-ipv4.txt
sed -i '/^127.0.0.1/d' /tmp/google-ipv4.txt
# Exclude Google DNS subnet's
sed -i '/^8.8.4.0/d' /tmp/google-ipv4.txt
sed -i '/^8.8.8.0/d' /tmp/google-ipv4.txt

# save ipv6
#grep ':' /tmp/google.txt > /tmp/google-ipv6.txt

# Create/Prepare ACL List for Shadowsocks IPv4
echo -e "[bypass_all]\n[proxy_list]" | tee google/ipv4.acl

# Create/Prepare ACL List for Shadowsocks IPv6
#echo -e "[bypass_all]\n[proxy_list]" | tee google/ipv6.acl

# sort & uniq
sort -h /tmp/google-ipv4.txt | uniq >> google/ipv4.acl
#sort -h /tmp/google-ipv6.txt | uniq >> google/ipv6.acl
