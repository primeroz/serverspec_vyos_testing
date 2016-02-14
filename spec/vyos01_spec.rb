require 'spec_helper'

describe 'vyos01' do
  include_examples 'vyos-base-1.1.0::init'
  include_examples 'vyos-base-1.1.0::quagga'
end
