#!/bin/bash


set -euo pipefail
set -x


# get CIDR from list
get_prefix() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv4_merged.txt > /tmp/"$1".txt
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv6_merged.txt >> /tmp/"$1".txt
}

get_prefix 'apple' || echo 'failed'

# save ipv4
grep -v ':' /tmp/apple.txt | sed 's/\/32//g' > /tmp/apple-ipv4.txt

# save ipv6
#grep ':' /tmp/apple.txt > /tmp/apple-ipv6.txt

# Create/Prepare ACL List for Shadowsocks IPv4
echo -e "[bypass_all]\n[proxy_list]" | tee apple/ipv4.acl

# Create/Prepare ACL List for Shadowsocks IPv6
#echo -e "[bypass_all]\n[proxy_list]" | tee apple/ipv6.acl

# sort & uniq
sort -h /tmp/apple-ipv4.txt | uniq >> apple/ipv4.acl
#sort -h /tmp/apple-ipv6.txt | uniq >> apple/ipv6.acl
