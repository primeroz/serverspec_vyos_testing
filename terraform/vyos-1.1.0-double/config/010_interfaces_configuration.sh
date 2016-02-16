#!/bin/vbash

source /opt/vyatta/etc/functions/script-template

configure

set 'interfaces' 'tunnel' 'tun1' 'address' "${internal_ip_mine_range}"
set 'interfaces' 'tunnel' 'tun1' 'description' "OSPF - GRE tunnel to ${fqdn}"
set 'interfaces' 'tunnel' 'tun1' 'encapsulation' 'gre'
set 'interfaces' 'tunnel' 'tun1' 'local-ip' "${private_ip_mine}"
set 'interfaces' 'tunnel' 'tun1' 'mtu' '1280'
set 'interfaces' 'tunnel' 'tun1' 'multicast' 'enable'
set 'interfaces' 'tunnel' 'tun1' 'remote-ip' "${private_ip_peer}"

set interfaces dummy dum1 address "127.0.${rtr_id_mine}.1/32"
set interfaces dummy dum1 description 'dummy 2 - OSPF'

set interfaces dummy dum2 address "127.0.${rtr_id_mine}.2/32"
set interfaces dummy dum2 description 'dummy 2 - OSPF'

set interfaces dummy dum3 address "127.0.${rtr_id_mine}.3/32"
set interfaces dummy dum3 description 'dummy 3 - BGP'

set interfaces dummy dum4 address "127.0.${rtr_id_mine}.4/32"
set interfaces dummy dum4 description 'dummy 4 - BGP'

commit

