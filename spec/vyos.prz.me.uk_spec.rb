require 'spec_helper'

describe 'vyos.prz.me.uk' do
  include_examples 'vyos-base-1.1.0::init'
  include_examples 'vyos-base-1.1.0::quagga'
end
