#!/bin/bash


set -euo pipefail
set -x


# get CIDR from list
get_prefix() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv4_merged.txt > /tmp/"$1".txt
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv6_merged.txt >> /tmp/"$1".txt
}

get_prefix 'CDNvideo' || echo 'failed'

# save ipv4
grep -v ':' /tmp/CDNvideo.txt | sed 's/\/32//g' > /tmp/CDNvideo-ipv4.txt

# save ipv6
#grep ':' /tmp/CDNvideo.txt > /tmp/CDNvideo-ipv6.txt

# Create/Prepare ACL List for CDNvideo IPv4
echo -e "[bypass_all]\n[proxy_list]" | tee CDNvideo/ipv4.acl

# Create/Prepare ACL List for CDNvideo IPv6
#echo -e "[bypass_all]\n[proxy_list]" | tee CDNvideo/ipv6.acl

# sort & uniq
sort -h /tmp/CDNvideo-ipv4.txt | uniq >> CDNvideo/ipv4.acl
#sort -h /tmp/CDNvideo-ipv6.txt | uniq >> CDNvideo/ipv6.acl
