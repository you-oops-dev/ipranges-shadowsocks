#!/bin/bash


set -euo pipefail
set -x


# get CIDR from list
get_prefix() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv4_merged.txt > /tmp/"$1".txt
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv6_merged.txt >> /tmp/"$1".txt
}

get_prefix 'zenlayer' || echo 'failed'

# save ipv4
grep -v ':' /tmp/zenlayer.txt | sed 's/\/32//g' > /tmp/zenlayer-ipv4.txt

# save ipv6
#grep ':' /tmp/zenlayer.txt > /tmp/zenlayer-ipv6.txt

# Create/Prepare ACL List for Zenlayer IPv4
echo -e "[bypass_all]\n[proxy_list]" | tee zenlayer/ipv4.acl

# Create/Prepare ACL List for Zenlayer IPv6
#echo -e "[bypass_all]\n[proxy_list]" | tee zenlayer/ipv6.acl

# sort & uniq
sort -h /tmp/zenlayer-ipv4.txt | uniq >> zenlayer/ipv4.acl
#sort -h /tmp/zenlayer-ipv6.txt | uniq >> zenlayer/ipv6.acl
