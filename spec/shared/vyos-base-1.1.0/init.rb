shared_examples 'vyos-base-1.1.0::init' do
  #puts host_inventory['platform']
  #puts host_inventory['platform_version']
  #puts host_inventory['ec2']['ami-id']

  # BASE VYOS 1.1.0 Services and Daemons
  describe service('zebra') do
    it { should be_running   }
  end

  describe service('bgpd') do
    it { should be_running   }
  end

  describe service('ospfd') do
    it { should be_running   }
  end

  describe service('ospf6d') do
    it { should be_running   }
  end

  describe service('ripd') do
    it { should be_running   }
  end

  describe service('ripngd') do
    it { should be_running   }
  end

  describe service('vyatta-quagga') do
    it { should be_enabled   }
  end

  # BASE AWS Checks
  # Will probably fail on a non ec2 since it will miss the ec2 key. XXX REVIEW 
  describe file('/'), :if => host_inventory['ec2']['ami-id'] != nil do
    it { should be_mounted.with( :type => 'overlayfs' ) }
  end

end
