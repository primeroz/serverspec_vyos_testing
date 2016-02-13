shared_examples 'vyos-base-1.1.0::quagga' do

  #describe command('') do
    #it { should be_enabled   }
  #end

  describe command('/tmp/test.sh show host name') do
    let(:disable_sudo) { true }
    its(:stdout) { should match 'VyOS-AMI' }
  end


end
