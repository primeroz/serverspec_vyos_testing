require 'rspec/core/rake_task'
require 'yaml'

properties = YAML.load_file('spec/properties.yml')

task :serverspec    => 'serverspec:all'
task :default => :serverspec

#desc 'a debug task to show what targets are found'
#task :targets do
#  targets = []
#  Dir.glob('spec/**/*_spec.rb').each do |file|
#    host = /(.*)_spec.rb/.match(File.basename(file))[1]
#    targets << host
#  end
#  puts targets
#end

namespace :serverspec do
  task :all => properties.keys.map {|key| 'serverspec:' + key.split('.')[0] }
  properties.keys.each do |key|
    desc "Run serverspec to #{key}"
    RSpec::Core::RakeTask.new(key.split('.')[0].to_sym) do |t|
      ENV['TARGET_HOST_NAME'] = key
      ENV['TARGET_HOST'] = properties[key][:ip]
      t.pattern = 'spec/shared/{' + properties[key][:roles].join(',') + '}/*_spec.rb'
      #t.pattern = 'spec/shared/vyos-base/010_init_spec.rb'
    end
  end
end

# Generate Environment for Terraform and ServerSpec from yaml file
namespace :env do
  task :init do
    configs = YAML.load_file('config.yml')

    # Generate jenkins.json configuration for terraform
    tf_hash = {}
    tf_hash[:ospf_area_0_range]=configs['network'][:tun1_range]
    tf_hash[:internal_ip_vyos01_range]=configs[:network][:vyos01][:tun1_ip]+"/"+configs['network'][:common][:tun1_ip_nm]
  end
end
