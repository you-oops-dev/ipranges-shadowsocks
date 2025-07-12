#!/bin/bash


set -euo pipefail
set -x


# get CIDR from list
get_prefix() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv4_merged.txt > /tmp/"$1".txt
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv6_merged.txt >> /tmp/"$1".txt
}

get_prefix 'azure' || echo 'failed'

# save ipv4
grep -v ':' /tmp/azure.txt | sed 's/\/32//g' > /tmp/azure-ipv4.txt

# save ipv6
#grep ':' /tmp/azure.txt > /tmp/azure-ipv6.txt

# Create/Prepare ACL List for Shadowsocks IPv4
echo -e "[bypass_all]\n[proxy_list]" | tee azure/ipv4.acl

# Create/Prepare ACL List for Shadowsocks IPv6
#echo -e "[bypass_all]\n[proxy_list]" | tee azure/ipv6.acl

# sort & uniq
sort -h /tmp/azure-ipv4.txt | uniq >> azure/ipv4.acl
#sort -h /tmp/azure-ipv6.txt | uniq >> azure/ipv6.acl
