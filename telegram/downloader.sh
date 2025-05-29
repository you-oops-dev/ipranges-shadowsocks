#!/bin/bash


set -euo pipefail
set -x


# get CIDR from list
get_prefix() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv4_merged.txt > /tmp/"$1".txt
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv6_merged.txt >> /tmp/"$1".txt
}

get_prefix 'telegram' || echo 'failed'

# save ipv4
grep -v ':' /tmp/telegram.txt | sed 's/\/32//g' > /tmp/telegram-ipv4.txt

# save ipv6
#grep ':' /tmp/telegram.txt > /tmp/telegram-ipv6.txt

# Create/Prepare ACL List for Shadowsocks IPv4
echo -e "[bypass_all]\n[proxy_list]" | tee telegram/ipv4.acl

# Create/Prepare ACL List for Shadowsocks IPv6
#echo -e "[bypass_all]\n[proxy_list]" | tee telegram/ipv6.acl

# sort & uniq
sort -h /tmp/telegram-ipv4.txt | uniq >> telegram/ipv4.acl
#sort -h /tmp/telegram-ipv6.txt | uniq >> telegram/ipv6.acl
