#!/bin/bash


set -euo pipefail
set -x

# Add domain in ACL file
add_domain() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/antonme/ipnames/master/ext-dns-youtube.txt > /tmp/"$1"_domain.txt
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/antonme/ipnames/master/dns-youtube.txt >> /tmp/"$1"_domain.txt
curl -4s --max-time 30 --retry-delay 3 --retry 10 https://raw.githubusercontent.com/antonme/ipnames/refs/heads/master/dns-youtube.txt >> /tmp/"$1"_domain.txt || echo "YouTube: Getting domain failed"
curl -4s --max-time 30 --retry-delay 3 --retry 10 https://raw.githubusercontent.com/bol-van/zapret-win-bundle/refs/heads/master/zapret-winws/files/list-youtube.txt >> /tmp/"$1"_domain.txt || echo "YouTube: Getting domain 2 failed"
echo "ggpht.com" >> /tmp/"$1"_domain.txt
dos2unix /tmp/"$1"_domain.txt
sort /tmp/"$1"_domain.txt | uniq | sponge /tmp/"$1"_domain.txt
# Prepare domain
# Delete subdomain in file
cat /tmp/"$1"_domain.txt | grep -vEe '(.googlevideo.com|.youtube.com|.ytimg.com|.google.com|.withgoogle.com|.googleusercontent.com|.metric.gstatic.com)$' > /tmp/"$1"_domain_prepare.txt
sort -h /tmp/"$1"_domain_prepare.txt | uniq | sponge /tmp/"$1"_domain_prepare.txt
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

#get_prefix 'youtube' || echo 'failed'

# save ipv4
#grep -v ':' /tmp/youtube.txt | sed 's/\/32//g' > /tmp/youtube-ipv4.txt

# save ipv6
#grep ':' /tmp/youtube.txt > /tmp/youtube-ipv6.txt

# Create/Prepare ACL List for Shadowsocks IPv4
echo -e "[bypass_all]\n[proxy_list]" | tee youtube/ipv4.acl

# Create/Prepare ACL List for Shadowsocks IPv6
#echo -e "[bypass_all]\n[proxy_list]" | tee youtube/ipv6.acl

add_domain 'youtube' || echo 'failed'

# sort & uniq
#sort -h /tmp/youtube-ipv4.txt | uniq >> youtube/ipv4.acl
#sort -h /tmp/youtube-ipv6.txt | uniq >> youtube/ipv6.acl
