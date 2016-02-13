# This is a wrapper so we can run vbash commands from SERVERSPEC 

# #
#  describe command('/tmp/test.sh show host name') do
#    let(:disable_sudo) { true }
#    its(:stdout) { should match 'VyOS-AMI' }
#  end
#

#!/bin/vbash
ARGS=$@
source /opt/vyatta/etc/functions/script-template

run $ARGS
