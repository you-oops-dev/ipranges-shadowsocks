#!/bin/bash


set -euo pipefail
set -x

# Add domain in ACL file
add_domain() {

curl -4s --max-time 90 --retry-delay 3 --retry 10 https://raw.githubusercontent.com/antonme/ipnames/refs/heads/master/dns-youtube.txt > /tmp/"$1"_domain.txt || echo "YouTube: Getting domain failed"
curl -4s --max-time 90 --retry-delay 3 --retry 10 https://raw.githubusercontent.com/bol-van/zapret-win-bundle/refs/heads/master/zapret-winws/files/list-youtube.txt >> /tmp/"$1"_domain.txt || echo "YouTube: Getting domain 2 failed"
curl -4s --max-time 90 --retry-delay 3 --retry 10 https://raw.githubusercontent.com/antonme/ipnames/master/ext-dns-youtube.txt >> /tmp/"$1"_domain.txt || echo "YouTube: Getting domain 3 failed"
curl -4s --max-time 90 --retry-delay 3 --retry 10 https://raw.githubusercontent.com/itdoginfo/allow-domains/refs/heads/main/Services/youtube.lst >> /tmp/"$1"_domain.txt || echo "YouTube: Getting domain 4 failed source itdoginfo"

echo "img.youtube.com
ggpht.com
ytimg.com
youtu.be
youtubei.googleapis.com
googleusercontent.com
yt3.ggpht.com
googlevideo.com
gstatic.com
googleapis.com
googleusercontent.com
youtube.com
sponsor.ajay.app
sponsorblock.hankmccord.dev
returnyoutubedislike.com
returnyoutubedislikeapi.com
music.youtube.com" >> /tmp/"$1"_domain.txt
dos2unix /tmp/"$1"_domain.txt
sort /tmp/"$1"_domain.txt | uniq | sponge /tmp/"$1"_domain.txt
# Prepare domain
# Delete subdomain in file
cat /tmp/"$1"_domain.txt | grep -vEe '(.googlevideo.com|.youtube.com|.ytimg.com|.google.com|.withgoogle.com|.googleusercontent.com|.metric.gstatic.com|.googleapis.com|.ggpht.com)$' > /tmp/"$1"_domain_prepare.txt
sort -h /tmp/"$1"_domain_prepare.txt | uniq | sed '/kellykawase/d' | sed '/hatenablog.co/d' | sed '/blogspot/d' | sed '/githubusercontent/d' | sed '/appspot/d' | sed '/kilatiron/d' | sed '/.ru$/d' | sed '/.co$/d' | sed '/.download$/d' | sed '/.yolasite.com$/d' | sed '/.youtube$/d' | sed '/.info$/d' | sed '/.me$/d' | sed '/.be$/d' | sed '/.net$/d' | sed '/.io$/d' | sed '/.ua$/d' | sed '/.cn$/d' | sort | sponge /tmp/"$1"_domain_prepare.txt
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
