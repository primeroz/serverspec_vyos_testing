require 'serverspec'
require 'pathname'
require 'net/ssh'
require 'yaml'

base_spec_dir = Pathname.new(File.join(File.dirname(__FILE__)))

set :backend, :ssh
set :disable_sudo, false

properties = YAML.load_file(base_spec_dir.join('properties.yml'))

if ENV['ASK_SUDO_PASSWORD']
  begin
    require 'highline/import'
  rescue LoadError
    fail "highline is not available. Try installing it."
  end
  set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
else
  set :sudo_password, ENV['SUDO_PASSWORD']
end

host = ENV['TARGET_HOST']
options = Net::SSH::Config.for(host)
options[:user] = properties[ENV['TARGET_HOST_NAME']][:ssh_username]
options[:keys] = [properties[ENV['TARGET_HOST_NAME']][:ssh_keypath]]

set :host,        options[:host_name] || host
set :ssh_options, options

set_property properties[ENV['TARGET_HOST_NAME']]

# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C'.

# Set PATH
# set :path, '/sbin:/usr/local/sbin:$PATH'

