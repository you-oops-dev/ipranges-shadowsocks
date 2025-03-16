#!/bin/bash


set -euo pipefail
set -x

# Add domain in ACL file
add_domain() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Shadowrocket/Adobe/Adobe.list | sed 's/ //g' | sed -r '/^\s*$/d' | sed '/!/d' | sed '/!!/d' | sed '/#/d' | sed 's/DOMAIN-SUFFIX,//g' | sed 's/^https\?:\/\///g' | sed '/IP-CIDR/d' | sed '/@/d' | sed 's/full://g' | sed '/:/d' | sed 's/DOMAIN,//g' | sed '/DOMAIN-KEYWORD/d' > /tmp/"$1"_domain.txt
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Shadowrocket/AdobeActivation/AdobeActivation.list | sed 's/ //g' | sed -r '/^\s*$/d' | sed '/!/d' | sed '/!!/d' | sed '/#/d' | sed 's/DOMAIN-SUFFIX,//g' | sed 's/^https\?:\/\///g' | sed '/IP-CIDR/d' | sed '/@/d' | sed 's/full://g' | sed '/:/d' | sed 's/DOMAIN,//g' | sed '/DOMAIN-KEYWORD/d' >> /tmp/"$1"_domain.txt

curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/v2fly/domain-list-community/master/data/adobe | sed 's/ //g' | sed -r '/^\s*$/d' | sed '/!/d' | sed '/!!/d' | sed '/#/d' | sed 's/DOMAIN-SUFFIX,//g' | sed 's/^https\?:\/\///g' | sed 's/full://g' | sed '/IP-CIDR/d' | sed '/@/d' | sed '/:/d' >> /tmp/"$1"_domain.txt
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/v2fly/domain-list-community/master/data/adobe-activation | sed 's/ //g' | sed -r '/^\s*$/d' | sed '/!/d' | sed '/!!/d' | sed '/#/d' | sed 's/DOMAIN-SUFFIX,//g' | sed 's/^https\?:\/\///g' | sed 's/full://g' | sed '/IP-CIDR/d' | sed '/@/d' | sed '/:/d' >> /tmp/"$1"_domain.txt
dos2unix /tmp/"$1"_domain.txt
sed -i 's/^www.//g' /tmp/"$1"_domain.txt
# Prepare domain
# Delete subdomain in file
cat /tmp/"$1"_domain.txt | grep -vEe '(.adobe.com|.adobe.io)$' > /tmp/"$1"_domain_prepare.txt
sort -h /tmp/"$1"_domain_prepare.txt | uniq | sponge /tmp/"$1"_domain_prepare.txt
# Replace . on \.
sed -i 's/\./\\./g' /tmp/"$1"_domain_prepare.txt
#sed -i 's/\./\\./g' /tmp/"$1"_domain.txt
#mv -f /tmp/"$1"_domain.txt /tmp/"$1"_domain_prepare.txt
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

#get_prefix 'adobe-all' || echo 'failed'

# save ipv4
#grep -v ':' /tmp/adobe-all.txt | sed 's/\/32//g' > /tmp/adobe-all-ipv4.txt

# save ipv6
#grep ':' /tmp/adobe-all.txt > /tmp/adobe-all-ipv6.txt

# Create/Prepare ACL List for Shadowsocks IPv4
echo -e "[bypass_all]\n[proxy_list]" | tee adobe-all/ipv4.acl

# Create/Prepare ACL List for Shadowsocks IPv6
#echo -e "[bypass_all]\n[proxy_list]" | tee adobe-all/ipv6.acl

add_domain 'adobe-all' || echo 'failed'

# sort & uniq
#sort -h /tmp/adobe-all-ipv4.txt | uniq >> adobe-all/ipv4.acl
#sort -h /tmp/adobe-all-ipv6.txt | uniq >> adobe-all/ipv6.acl
