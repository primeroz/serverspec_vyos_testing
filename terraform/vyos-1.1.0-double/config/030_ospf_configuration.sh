#!/bin/vbash

source /opt/vyatta/etc/functions/script-template

configure

set 'interfaces' 'tunnel' 'tun1' 'ip' 'ospf' 'cost' '1'
set 'interfaces' 'tunnel' 'tun1' 'ip' 'ospf' 'dead-interval' '10'
set 'interfaces' 'tunnel' 'tun1' 'ip' 'ospf' 'hello-interval' '2'
set 'interfaces' 'tunnel' 'tun1' 'ip' 'ospf' 'priority' '1'
set 'interfaces' 'tunnel' 'tun1' 'ip' 'ospf' 'retransmit-interval' '3'
set 'interfaces' 'tunnel' 'tun1' 'ip' 'ospf' 'transmit-delay' '1'

#Redistribute dummy dum1 and dum2 into OSPF
set 'policy' 'prefix-list' 'plDummyToOspf' 'rule' '10' 'action' 'permit'
set 'policy' 'prefix-list' 'plDummyToOspf' 'rule' '10' 'description' 'Dummy dum1'
set 'policy' 'prefix-list' 'plDummyToOspf' 'rule' '10' 'prefix' "127.0.${rtr_id_mine}.1/32"
set 'policy' 'prefix-list' 'plDummyToOspf' 'rule' '20' 'action' 'permit'
set 'policy' 'prefix-list' 'plDummyToOspf' 'rule' '20' 'description' 'Dummy dum2'
set 'policy' 'prefix-list' 'plDummyToOspf' 'rule' '20' 'prefix' "127.0.${rtr_id_mine}.2/32"

set 'policy' 'route-map' 'dummyToOspf' 'rule' '10' 'action' 'permit'
set 'policy' 'route-map' 'dummyToOspf' 'rule' '10' 'match' 'ip' 'address' 'prefix-list' 'plDummyToOspf'
set 'policy' 'route-map' 'dummyToOspf' 'rule' '9999' 'action' 'deny'

set 'protocols' 'ospf' 'area' '0' 'network' "${ospf_area_0_range}"
set 'protocols' 'ospf' 'parameters' 'abr-type' 'cisco'
set 'protocols' 'ospf' 'parameters' 'router-id' "127.0.${rtr_id_mine}.1"
set 'protocols' 'ospf' 'redistribute' 'connected' 'route-map' 'dummyToOspf'

commit

