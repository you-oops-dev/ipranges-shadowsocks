#!/bin/bash


set -euo pipefail
set -x


# get CIDR from list
get_prefix() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv4_smart.txt > /tmp/"$1".txt
#curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv6_merged.txt >> /tmp/"$1".txt
}

get_prefix 'cachefly' || echo 'failed'

# save ipv4
grep -v ':' /tmp/cachefly.txt | sed 's/\/32//g' > /tmp/cachefly-ipv4.txt

# save ipv6
#grep ':' /tmp/cachefly.txt > /tmp/cachefly-ipv6.txt

# Create/Prepare ACL List for Shadowsocks IPv4
echo -e "[bypass_all]\n[proxy_list]" | tee cachefly/ipv4.acl

# Create/Prepare ACL List for Shadowsocks IPv6
#echo -e "[bypass_all]\n[proxy_list]" | tee cachefly/ipv6.acl

# sort & uniq
sort -h /tmp/cachefly-ipv4.txt | uniq >> cachefly/ipv4.acl
#sort -h /tmp/cachefly-ipv6.txt | uniq >> cachefly/ipv6.acl
