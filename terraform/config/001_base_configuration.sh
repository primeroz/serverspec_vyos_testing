#!/bin/vbash

source /opt/vyatta/etc/functions/script-template

configure
set system host-name ${short_name}

set 'firewall' 'all-ping' 'enable'
set 'firewall' 'broadcast-ping' 'disable'
set 'firewall' 'config-trap' 'disable'

set 'firewall' 'group' 'address-group' 'Peers' 'address' "${private_ip_mine}"
set 'firewall' 'group' 'address-group' 'Peers' 'address' "${private_ip_peer}"

set 'firewall' 'group' 'network-group' 'RFC1918' 'network' '10.0.0.0/8'
set 'firewall' 'group' 'network-group' 'RFC1918' 'network' '172.16.0.0/12'
set 'firewall' 'group' 'network-group' 'RFC1918' 'network' '192.168.0.0/16'

set 'firewall' 'ipv6-receive-redirects' 'disable'
set 'firewall' 'ipv6-src-route' 'disable'
set 'firewall' 'ip-src-route' 'disable'
set 'firewall' 'log-martians' 'disable'

set 'firewall' 'receive-redirects' 'disable'
set 'firewall' 'send-redirects' 'enable'
set 'firewall' 'source-validation' 'disable'
set 'firewall' 'syn-cookies' 'enable'
set 'firewall' 'twa-hazards-protection' 'disable'

set 'service' 'snmp' 'community' 'public' 'authorization' 'ro'
set 'service' 'snmp' 'community' 'public' 'client' "${private_ip_mine}"
set 'service' 'snmp' 'community' 'public' 'client' "${private_ip_peer}"
set 'service' 'snmp' 'contact' 'Here are the Dragons <dragons@wherever.com>'
set 'service' 'snmp' 'location' 'The Cave'

set 'service' 'ssh' 'port' '22'

set 'system' 'name-server' '8.8.8.8'
set 'system' 'name-server' '8.8.4.4'

set 'system' 'ntp' 'server' '0.pool.ntp.org'
set 'system' 'ntp' 'server' '1.pool.ntp.org'
set 'system' 'ntp' 'server' '2.pool.ntp.org'

set 'system' 'time-zone' 'UTC'

commit

