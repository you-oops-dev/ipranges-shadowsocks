#!/bin/bash


set -euo pipefail
set -x


# get CIDR from list
get_prefix() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv4_smart.txt > /tmp/"$1".txt
#curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv6_merged.txt >> /tmp/"$1".txt
}

get_prefix 'amazon-all' || echo 'failed'

# save ipv4
grep -v ':' /tmp/amazon-all.txt | sed 's/\/32//g' > /tmp/amazon-all-ipv4.txt

# save ipv6
#grep ':' /tmp/amazon-all.txt > /tmp/amazon-all-ipv6.txt

# Create/Prepare ACL List for Shadowsocks IPv4
echo -e "[bypass_all]\n[proxy_list]" | tee amazon-all/ipv4.acl

# Create/Prepare ACL List for Shadowsocks IPv6
#echo -e "[bypass_all]\n[proxy_list]" | tee roblox/ipv6.acl

# sort & uniq
sort -h /tmp/amazon-all-ipv4.txt | uniq >> amazon-all/ipv4.acl
#sort -h /tmp/amazon-all-ipv6.txt | uniq >> amazon-all/ipv6.acl
