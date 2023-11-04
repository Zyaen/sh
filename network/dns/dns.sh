#!/bin/sh

serial=$(cat dns | grep Serial | awk '{print $1}')
aliases=$(cat dnstemplate | grep ANAME | awk '{print $3}')
int_serial=$((serial))
((int_serial++))

sed_script=" -e 's|SERIAL|$int_serial|g' -e 's|ANAME|A|g'"

while IFS= read -r line; do
        sed_script+=" -e 's|$line|$(dig +short $line)|g'"
done <<< "$aliases"

eval "sed $sed_script \"dnstemplate\" > \"dns\""
sudo systemctl reload named.service