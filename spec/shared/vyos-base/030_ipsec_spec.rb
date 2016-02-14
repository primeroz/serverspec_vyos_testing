require 'spec_helper'

describe command('/tmp/vbash-show.sh show vpn ipsec status') do
  let(:disable_sudo) { true }
  its(:stdout) { should match /1 Active IPsec Tunnels/ }
end
