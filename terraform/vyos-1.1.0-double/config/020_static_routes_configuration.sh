#!/bin/vbash

source /opt/vyatta/etc/functions/script-template

configure

#set 'protocols' 'static' 'route' "127.0.${rtr_id_peer}.0/24" 'next-hop' "${internal_ip_peer}"

commit

