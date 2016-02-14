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

#namespace :serverspec do
#  targets = []
#  Dir.glob('spec/**/*_spec.rb').each do |file|
#    host = /(.*)_spec.rb/.match(File.basename(file))[1]
#    targets << host
#  end
#
#  task :all     => targets
#  task :default => :all
#
#
#  targets.each do |target|
#    desc "Run serverspec tests to #{target}"
#    RSpec::Core::RakeTask.new(target.to_sym) do |t|
#      ENV['TARGET_HOST'] = target
#      t.pattern = "#{target}_spec.rb"
#      t.verbose = false
#    end
#  end
#end
