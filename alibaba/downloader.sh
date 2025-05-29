#!/bin/bash


set -euo pipefail
set -x


# get CIDR from list
get_prefix() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv4_merged.txt > /tmp/"$1".txt
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv6_merged.txt >> /tmp/"$1".txt
}

get_prefix 'alibaba' || echo 'failed'

# save ipv4
grep -v ':' /tmp/alibaba.txt | sed 's/\/32//g' > /tmp/alibaba-ipv4.txt

# save ipv6
#grep ':' /tmp/alibaba.txt > /tmp/alibaba-ipv6.txt

# Create/Prepare ACL List for Shadowsocks IPv4
echo -e "[bypass_all]\n[proxy_list]" | tee alibaba/ipv4.acl

# Create/Prepare ACL List for Shadowsocks IPv6
#echo -e "[bypass_all]\n[proxy_list]" | tee alibaba/ipv6.acl

# sort & uniq
sort -h /tmp/alibaba-ipv4.txt | uniq >> alibaba/ipv4.acl
#sort -h /tmp/alibaba-ipv6.txt | uniq >> alibaba/ipv6.acl
