#!/bin/bash


set -euo pipefail
set -x


# get CIDR from list
get_prefix() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv4_merged.txt > /tmp/"$1".txt
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv6_merged.txt >> /tmp/"$1".txt
}

get_prefix 'ionos' || echo 'failed'

# save ipv4
grep -v ':' /tmp/ionos.txt | sed 's/\/32//g' > /tmp/ionos-ipv4.txt

# save ipv6
#grep ':' /tmp/ionos.txt > /tmp/ionos-ipv6.txt

# Create/Prepare ACL List for Shadowsocks IPv4
echo -e "[bypass_all]\n[proxy_list]" | tee ionos/ipv4.acl

# Create/Prepare ACL List for Shadowsocks IPv6
#echo -e "[bypass_all]\n[proxy_list]" | tee ionos/ipv6.acl

# sort & uniq
sort -h /tmp/ionos-ipv4.txt | uniq >> ionos/ipv4.acl
#sort -h /tmp/ionos-ipv6.txt | uniq >> ionos/ipv6.acl
