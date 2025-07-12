#!/bin/bash


set -euo pipefail
set -x


# get CIDR from list
get_prefix() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv4_merged.txt > /tmp/"$1".txt
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv6_merged.txt >> /tmp/"$1".txt
}

get_prefix 'qrator' || echo 'failed'

# save ipv4
grep -v ':' /tmp/qrator.txt | sed 's/\/32//g' > /tmp/qrator-ipv4.txt

# save ipv6
#grep ':' /tmp/qrator.txt > /tmp/qrator-ipv6.txt

# Create/Prepare ACL List for Shadowsocks IPv4
echo -e "[bypass_all]\n[proxy_list]" | tee qrator/ipv4.acl

# Create/Prepare ACL List for Shadowsocks IPv6
#echo -e "[bypass_all]\n[proxy_list]" | tee qrator/ipv6.acl

# sort & uniq
sort -h /tmp/qrator-ipv4.txt | uniq >> qrator/ipv4.acl
#sort -h /tmp/qrator-ipv6.txt | uniq >> qrator/ipv6.acl
