#!/bin/bash


set -euo pipefail
set -x

# Add domain in ACL file
add_domain() {
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/antonme/ipnames/master/dns-openai.txt > /tmp/"$1"_domain.txt
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/antonme/ipnames/master/ext-dns-openai.txt >> /tmp/"$1"_domain.txt
echo 'ab.chatgpt.com
api.openai.com
arena.openai.com
auth.openai.com
auth0.openai.com
beta.api.openai.com
beta.openai.com
blog.openai.com
cdn.oaistatic.com
cdn.openai.com
community.openai.com
contest.openai.com
debate-game.openai.com
discuss.openai.com
files.oaiusercontent.com
gpt3-openai.com
gym.openai.com
help.openai.com
ios.chat.openai.com
jukebox.openai.com
labs.openai.com
microscope.openai.com
oaistatic.com
openai.com
openai.fund
openai.org
platform.api.openai.com
platform.openai.com
spinningup.openai
chat.openai.com
chatgpt.com
featureassets.org
cdnjs.cloudflare.com
cdn.auth0.com
prodregistryv2.org' >> /tmp/"$1"_domain.txt
dos2unix /tmp/"$1"_domain.txt
sort /tmp/"$1"_domain.txt | uniq | sponge /tmp/"$1"_domain.txt
# Prepare domain
# Delete subdomain in file
cat /tmp/"$1"_domain.txt | grep -vEe '(.openai.com|.openai.org|.openai.com.cdn.cloudflare.net|.oaistatic.com)$' > /tmp/"$1"_domain_prepare.txt
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

get_prefix 'chatgpt' || echo 'failed'

# save ipv4
grep -v ':' /tmp/chatgpt.txt | sed 's/\/32//g' > /tmp/chatgpt-ipv4.txt

# save ipv6
#grep ':' /tmp/chatgpt.txt > /tmp/chatgpt-ipv6.txt

# Create/Prepare ACL List for Shadowsocks IPv4
echo -e "[bypass_all]\n[proxy_list]" | tee chatgpt/ipv4.acl

# Create/Prepare ACL List for Shadowsocks IPv6
#echo -e "[bypass_all]\n[proxy_list]" | tee chatgpt/ipv6.acl

add_domain 'chatgpt' || echo 'failed'

# sort & uniq
sort -h /tmp/chatgpt-ipv4.txt | uniq >> chatgpt/ipv4.acl
#sort -h /tmp/chatgpt-ipv6.txt | uniq >> chatgpt/ipv6.acl
