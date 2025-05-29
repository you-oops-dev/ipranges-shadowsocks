#!/bin/bash


set -euo pipefail
set -x


# get CIDR from list
get_prefix() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv4_merged.txt > /tmp/"$1".txt
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv6_merged.txt >> /tmp/"$1".txt
}

get_prefix 'atom86' || echo 'failed'

# save ipv4
grep -v ':' /tmp/atom86.txt | sed 's/\/32//g' > /tmp/atom86-ipv4.txt

# save ipv6
#grep ':' /tmp/atom86.txt > /tmp/atom86-ipv6.txt

# Create/Prepare ACL List for atom86 IPv4
echo -e "[bypass_all]\n[proxy_list]" | tee atom86/ipv4.acl

# Create/Prepare ACL List for atom86 IPv6
#echo -e "[bypass_all]\n[proxy_list]" | tee atom86/ipv6.acl

# sort & uniq
sort -h /tmp/atom86-ipv4.txt | uniq >> atom86/ipv4.acl
#sort -h /tmp/atom86-ipv6.txt | uniq >> atom86/ipv6.acl
