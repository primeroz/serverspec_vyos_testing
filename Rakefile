require 'rspec/core/rake_task'
require 'yaml'

# VARS HERE 
terraform_version = "0.6.11"
terraform_file = "terraform_#{terraform_version}_linux_amd64.zip"
terraform_url = "https://releases.hashicorp.com/terraform/#{terraform_version}/#{terraform_file}"

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
    end
  end
end

# Generate Environment for Terraform and ServerSpec from yaml file
namespace :env do

	#:prjdir=File.expand_path File.dirname(__FILE__)
	prjdir=Dir.pwd

  directory "#{prjdir}/bin"

  file "#{prjdir}/bin/terraform" => [
		"#{prjdir}/bin",
  	] do |file|

			FileUtils.cd("#{prjdir}/bin") do
				sh %Q{wget -q #{terraform_url} && unzip #{terraform_file} && rm #{terraform_file} } do |ok, res|
        	if ! ok
          	puts "Download of Terraform : #{terraform_url} - FAILED"
          	abort("terraform download failed - FAILED")
        	end
				end
  		end
  	end

  task :init_tf do

		Rake::Task["#{prjdir}/bin/terraform"].invoke

    configs = YAML.load_file('config.yml')

		#Terraform Configuration Hash
    tf_hash = {}
    tf_hash[:ospf_area_0_range]=configs['network']['common'][:tun1_range]
    tf_hash[:internal_ip_vyos01_tun1_range]=configs['network']['vyos01'][:tun1_ip]+"/"+configs['network']['common'][:tun1_ip_nm]
    tf_hash[:internal_ip_vyos02_tun1_range]=configs['network']['vyos02'][:tun1_ip]+"/"+configs['network']['common'][:tun1_ip_nm]
    tf_hash[:internal_ip_vyos01_tun1_ip]=configs['network']['vyos01'][:tun1_ip]
    tf_hash[:internal_ip_vyos02_tun1_ip]=configs['network']['vyos02'][:tun1_ip]
    tf_hash[:internal_ip_vyos01_tun1_rtr_id]=configs['network']['vyos01'][:rtr_id]
    tf_hash[:internal_ip_vyos02_tun1_rtr_id]=configs['network']['vyos02'][:rtr_id]
    tf_hash[:vyos_version]=configs['network']['common'][:vyos_version]
    tf_hash[:ssh_username]=configs['network']['common'][:ssh_username]
    tf_hash[:ssh_keypath]=configs['network']['common'][:ssh_keypath]
    tf_hash[:ssh_keyname]=configs['network']['aws'][:ssh_keyname]
    tf_hash[:instance_type]=configs['network']['aws'][:instance_type]
    tf_hash[:region]=configs['network']['aws'][:region]
    tf_hash[:ami]=configs['network']['aws'][:ami]
    tf_hash[:subnet_id]=configs['network']['aws'][:subnet_id]

		FileUtils.cd("#{prjdir}/terraform/config") do 
			File.open("jenkins.tfvars","w") do |f|
				tf_hash.each do |key, value|
					f.puts "#{key}=\"#{value}\""
				end
			end
		end
  end

  desc "Terraform Plan"
	task :plan_tf do

		Rake::Task['env:init_tf'].invoke

		ENV['PATH']="#{prjdir}/bin:"+ENV['PATH']

    configs = YAML.load_file('config.yml')

		varlist = configs['terraform']['var_files'].length > 0 ? "-var-file=config/"+configs['terraform']['var_files'].join(" -var-file=config/") : ""

		FileUtils.cd("#{prjdir}/terraform") do
			sh %Q{terraform plan #{varlist}} do |ok, res|
      	if ! ok
        	puts "Terraform Plan - FAILED"
        	abort("terraform plan - FAILED")
      	end
			end
  	end
	end

	#task :init_spec do
#
	#end


end
