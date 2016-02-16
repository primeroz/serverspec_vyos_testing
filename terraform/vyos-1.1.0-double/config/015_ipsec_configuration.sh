#!/bin/vbash

source /opt/vyatta/etc/functions/script-template

configure

set 'vpn' 'ipsec' 'esp-group' 'espgroup1' 'compression' 'enab;e'
set 'vpn' 'ipsec' 'esp-group' 'espgroup1' 'lifetime' '3600'
set 'vpn' 'ipsec' 'esp-group' 'espgroup1' 'mode' 'tunnel'
set 'vpn' 'ipsec' 'esp-group' 'espgroup1' 'pfs' 'enable'
set 'vpn' 'ipsec' 'esp-group' 'espgroup1' 'proposal' '1' 'encryption' 'aes256'
set 'vpn' 'ipsec' 'esp-group' 'espgroup1' 'proposal' '1' 'hash' 'sha1'

set 'vpn' 'ipsec' 'ike-group' 'ikegroup1' 'dead-peer-detection' 'action' 'restart'
set 'vpn' 'ipsec' 'ike-group' 'ikegroup1' 'dead-peer-detection' 'interval' '15'
set 'vpn' 'ipsec' 'ike-group' 'ikegroup1' 'dead-peer-detection' 'timeout' '30'
set 'vpn' 'ipsec' 'ike-group' 'ikegroup1' 'key-exchange' 'ikev1'
set 'vpn' 'ipsec' 'ike-group' 'ikegroup1' 'lifetime' '28800'
set 'vpn' 'ipsec' 'ike-group' 'ikegroup1' 'proposal' '1' 'dh-group' '2'
set 'vpn' 'ipsec' 'ike-group' 'ikegroup1' 'proposal' '1' 'encryption' 'aes256'
set 'vpn' 'ipsec' 'ike-group' 'ikegroup1' 'proposal' '1' 'hash' 'sha1'

set 'vpn' 'ipsec' 'ipsec-interfaces' 'interface' 'eth0'

set 'vpn' 'ipsec' 'nat-traversal' 'enable'

set 'vpn' 'ipsec' 'site-to-site' 'peer' "${private_ip_peer}" 'authentication' 'id' "@Tun1_${private_ip_mine}"
set 'vpn' 'ipsec' 'site-to-site' 'peer' "${private_ip_peer}" 'authentication' 'mode' 'pre-shared-secret'
set 'vpn' 'ipsec' 'site-to-site' 'peer' "${private_ip_peer}" 'authentication' 'pre-shared-secret' 'password'
set 'vpn' 'ipsec' 'site-to-site' 'peer' "${private_ip_peer}" 'authentication' 'remote-id' "@Tun1_${private_ip_peer}"
set 'vpn' 'ipsec' 'site-to-site' 'peer' "${private_ip_peer}" 'connection-type' 'initiate'
set 'vpn' 'ipsec' 'site-to-site' 'peer' "${private_ip_peer}" 'default-esp-group' 'espgroup1'
set 'vpn' 'ipsec' 'site-to-site' 'peer' "${private_ip_peer}" 'description' "OSPF IPSEC GRE to ${private_ip_peer}"
set 'vpn' 'ipsec' 'site-to-site' 'peer' "${private_ip_peer}" 'ike-group' 'ikegroup1'
set 'vpn' 'ipsec' 'site-to-site' 'peer' "${private_ip_peer}" 'local-address' "${private_ip_mine}"
set 'vpn' 'ipsec' 'site-to-site' 'peer' "${private_ip_peer}" 'tunnel' '1' 'allow-nat-networks' 'disable'
set 'vpn' 'ipsec' 'site-to-site' 'peer' "${private_ip_peer}" 'tunnel' '1' 'allow-public-networks' 'disable'
set 'vpn' 'ipsec' 'site-to-site' 'peer' "${private_ip_peer}" 'tunnel' '1' 'protocol' 'gre'


commit

