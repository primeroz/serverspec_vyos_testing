require 'spec_helper'

describe interface('tun1') do
  it { should exist }
  #it { should be_up } # Can't check status on tun interface :(
  it { should have_ipv4_address("#{property[:tun1_ip]}") }
end

describe command('/tmp/vbash-show.sh show interface tunnel tun1') do
  let(:disable_sudo) { true }
  its(:stdout) { should match /^tun1.*UP,LOWER_UP.*link\/gre #{property[:private_ip]}.*$/m }
end
