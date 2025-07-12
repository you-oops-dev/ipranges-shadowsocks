#!/bin/bash


set -euo pipefail
set -x

# Add domain in ACL file
add_domain() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/refs/heads/master/rule/Shadowrocket/LastFM/LastFM.list | sed 's/ //g' | sed -r '/^\s*$/d' | sed '/!/d' | sed '/!!/d' | sed '/#/d' | sed 's/DOMAIN-SUFFIX,//g' | sed 's/^https\?:\/\///g' | sed '/IP-CIDR/d' | sed '/@/d' | sed 's/full://g' | sed '/:/d' | sed 's/DOMAIN,//g' | sed '/DOMAIN-KEYWORD/d' > /tmp/"$1"_domain.txt
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/v2fly/domain-list-community/refs/heads/master/data/lastfm | sed 's/ //g' | sed -r '/^\s*$/d' | sed '/!/d' | sed '/!!/d' | sed '/#/d' | sed 's/DOMAIN-SUFFIX,//g' | sed 's/^https\?:\/\///g' | sed 's/full://g' | sed '/IP-CIDR/d' | sed '/@/d' | sed '/:/d' >> /tmp/"$1"_domain.txt
dos2unix /tmp/"$1"_domain.txt
sort /tmp/"$1"_domain.txt | uniq | sponge /tmp/"$1"_domain.txt
# Prepare domain
# Delete subdomain in file
#cat /tmp/"$1"_domain.txt | grep -vEe '(.openai.com|.openai.org|.openai.com.cdn.cloudflare.net|.oaistatic.com)$' > /tmp/"$1"_domain_prepare.txt
#sort -h /tmp/"$1"_domain_prepare.txt | uniq | sponge /tmp/"$1"_domain_prepare.txt
# Replace . on \.
#sed -i 's/\./\\./g' /tmp/"$1"_domain_prepare.txt
sed -i 's/\./\\./g' /tmp/"$1"_domain.txt
mv -f /tmp/"$1"_domain.txt /tmp/"$1"_domain_prepare.txt
# ipv4
for domain in $(cat /tmp/${1}_domain_prepare.txt | sed '/.tk/d'); do echo \(\?\:\^\|\\\.\)${domain}$ >> ${1}/ipv4.acl; done
# ipv6
#for domain in $(cat /tmp/${1}_domain_prepare.txt); do echo \(\?\:\^\|\\\.\)${domain}$ >> ${1}/ipv6.acl; done
}

# get CIDR from list
get_prefix() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv4_merged.txt > /tmp/"$1".txt
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/main/"$1"/ipv6_merged.txt >> /tmp/"$1".txt
}

#get_prefix 'LastFM' || echo 'failed'

# save ipv4
#grep -v ':' /tmp/LastFM.txt | sed 's/\/32//g' > /tmp/LastFM-ipv4.txt

# save ipv6
#grep ':' /tmp/LastFM.txt > /tmp/LastFM-ipv6.txt

# Create/Prepare ACL List for Shadowsocks IPv4
echo -e "[bypass_all]\n[proxy_list]" | tee LastFM/ipv4.acl

# Create/Prepare ACL List for Shadowsocks IPv6
#echo -e "[bypass_all]\n[proxy_list]" | tee LastFM/ipv6.acl

add_domain 'LastFM' || echo 'failed'

# sort & uniq
#sort -h /tmp/LastFM-ipv4.txt | uniq >> LastFM/ipv4.acl
#sort -h /tmp/LastFM-ipv6.txt | uniq >> LastFM/ipv6.acl
