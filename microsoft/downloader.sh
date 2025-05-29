#!/bin/bash
set -euo pipefail
set -x

# Add domain in ACL file
add_domain() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/refs/heads/main/microsoft/domain.txt > /tmp/"$1"_domain.txt
dos2unix /tmp/"$1"_domain.txt
#sort /tmp/"$1"_domain.txt | uniq | grep -i \. | sort | uniq | sponge /tmp/"$1"_domain.txt
# Prepare domain
# Delete subdomain in file
cat /tmp/"$1"_domain.txt | grep -vEe '(.microsoft.com|.windowsupdate.com|.microsoft.net|.azureedge.net|.msn.com|.digicert.com|.windows.com|.akamaized.net)$' > /tmp/"$1"_domain_prepare.txt
sort -h /tmp/"$1"_domain_prepare.txt | uniq | sponge /tmp/"$1"_domain_prepare.txt && sleep 1s
sed -i 's/^www.//g' /tmp/"$1"_domain_prepare.txt
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

#get_prefix 'microsoft' || echo 'failed'

# save ipv4
#grep -v ':' /tmp/microsoft.txt | sed 's/\/32//g' > /tmp/microsoft-ipv4.txt

# save ipv6
#grep ':' /tmp/microsoft.txt > /tmp/microsoft-ipv6.txt

# Create/Prepare ACL List for Shadowsocks IPv4
echo -e "[bypass_all]\n[proxy_list]" | tee microsoft/ipv4.acl

# Create/Prepare ACL List for Shadowsocks IPv6
#echo -e "[bypass_all]\n[proxy_list]" | tee microsoft/ipv6.acl

add_domain 'microsoft' || echo 'failed'

curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/refs/heads/main/microsoft/ipv4_merged.txt | sed 's/\/32//g' >> microsoft/ipv4.acl

# sort & uniq
#sort -h /tmp/microsoft-ipv4.txt | uniq >> microsoft/ipv4.acl
#sort -h /tmp/microsoft-ipv6.txt | uniq >> microsoft/ipv6.acl
