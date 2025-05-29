#!/bin/bash


set -euo pipefail
set -x


# get CIDR from list
get_prefix() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv4_merged.txt > /tmp/"$1".txt
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv6_merged.txt >> /tmp/"$1".txt
}

get_prefix 'amazoncloudfront' || echo 'failed'

# save ipv4
grep -v ':' /tmp/amazoncloudfront.txt | sed 's/\/32//g' > /tmp/amazoncloudfront-ipv4.txt

# save ipv6
#grep ':' /tmp/amazoncloudfront.txt > /tmp/amazoncloudfront-ipv6.txt

# Create/Prepare ACL List for amazoncloudfront IPv4
echo -e "[bypass_all]\n[proxy_list]" | tee amazoncloudfront/ipv4.acl

# Create/Prepare ACL List for amazoncloudfront IPv6
#echo -e "[bypass_all]\n[proxy_list]" | tee amazoncloudfront/ipv6.acl

# sort & uniq
sort -h /tmp/amazoncloudfront-ipv4.txt | uniq >> amazoncloudfront/ipv4.acl
#sort -h /tmp/amazoncloudfront-ipv6.txt | uniq >> amazoncloudfront/ipv6.acl
