#!/bin/bash


set -euo pipefail
set -x


# get CIDR from list
get_prefix() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv4_merged.txt > /tmp/"$1".txt
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv6_merged.txt >> /tmp/"$1".txt
}

get_prefix 'huaweicloud' || echo 'failed'

# save ipv4
grep -v ':' /tmp/huaweicloud.txt | sed 's/\/32//g' > /tmp/huaweicloud-ipv4.txt

# save ipv6
#grep ':' /tmp/huaweicloud.txt > /tmp/huaweicloud-ipv6.txt

# Create/Prepare ACL List for HuaweiCloud IPv4
echo -e "[bypass_all]\n[proxy_list]" | tee huaweicloud/ipv4.acl

# Create/Prepare ACL List for HuaweiCloud IPv6
#echo -e "[bypass_all]\n[proxy_list]" | tee huaweicloud/ipv6.acl

# sort & uniq
sort -h /tmp/huaweicloud-ipv4.txt | uniq >> huaweicloud/ipv4.acl
#sort -h /tmp/huaweicloud-ipv6.txt | uniq >> huaweicloud/ipv6.acl
