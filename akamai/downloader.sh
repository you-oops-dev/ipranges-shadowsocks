#!/bin/bash


set -euo pipefail
set -x


# get CIDR from list
get_prefix() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv4_merged.txt > /tmp/"$1".txt
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv6_merged.txt >> /tmp/"$1".txt
}

get_prefix 'akamai' || echo 'failed'

# save ipv4
grep -v ':' /tmp/akamai.txt | sed 's/\/32//g' > /tmp/akamai-ipv4.txt

# save ipv6
#grep ':' /tmp/akamai.txt > /tmp/akamai-ipv6.txt

# Create/Prepare ACL List for Shadowsocks IPv4
echo -e "[bypass_all]\n[proxy_list]" | tee akamai/ipv4.acl

# Create/Prepare ACL List for Shadowsocks IPv6
#echo -e "[bypass_all]\n[proxy_list]" | tee akamai/ipv6.acl

# sort & uniq
sort -h /tmp/akamai-ipv4.txt | uniq >> akamai/ipv4.acl
#sort -h /tmp/akamai-ipv6.txt | uniq >> akamai/ipv6.acl
