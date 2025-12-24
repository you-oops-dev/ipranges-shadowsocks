#!/bin/bash


set -euo pipefail
set -x

# Add domain in ACL file
add_domain() {

curl -4s --max-time 90 --retry-delay 3 --retry 10 https://raw.githubusercontent.com/${NAME_ACCOUNT_GITHUB}/ipranges-singbox/refs/heads/main/$1/domain.txt > /tmp/$1_domain.txt || echo "4PDA: Getting domain failed"


dos2unix /tmp/"$1"_domain.txt
sort /tmp/"$1"_domain.txt | uniq | sponge /tmp/"$1"_domain.txt
# Prepare domain
# Delete subdomain in file
cat /tmp/"$1"_domain.txt | grep -vEe '(.4pda.ru|.4pda.ws|.4pda.to)$' > /tmp/"$1"_domain_prepare.txt
sed -i 's/^www.//g' /tmp/"$1"_domain_prepare.txt
# Replace . on \.
sed -i 's/\./\\./g' /tmp/"$1"_domain_prepare.txt
# ipv4
for domain in $(cat /tmp/${1}_domain_prepare.txt); do echo \(\?\:\^\|\\\.\)${domain}$ >> ${1}/ipv4.acl; done
# ipv6
#for domain in $(cat /tmp/${1}_domain_prepare.txt); do echo \(\?\:\^\|\\\.\)${domain}$ >> ${1}/ipv6.acl; done
}

# get CIDR from list
get_prefix() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv4_merged.txt > /tmp/"$1".txt
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv6_merged.txt >> /tmp/"$1".txt
}

#get_prefix '4pda' || echo 'failed'

# save ipv4
#grep -v ':' /tmp/4pda.txt | sed 's/\/32//g' > /tmp/4pda-ipv4.txt

# save ipv6
#grep ':' /tmp/4pda.txt > /tmp/4pda-ipv6.txt

# Create/Prepare ACL List for Shadowsocks IPv4
echo -e "[bypass_all]\n[proxy_list]" | tee 4pda/ipv4.acl

# Create/Prepare ACL List for Shadowsocks IPv6
#echo -e "[bypass_all]\n[proxy_list]" | tee 4pda/ipv6.acl

add_domain '4pda' || echo 'failed'

# sort & uniq
#sort -h /tmp/4pda-ipv4.txt | uniq >> 4pda/ipv4.acl
#sort -h /tmp/4pda-ipv6.txt | uniq >> 4pda/ipv6.acl
