require 'rspec/core/rake_task'
require 'yaml'

# VARS HERE 
terraform_version = "0.6.11"
terraform_file = "terraform_#{terraform_version}_linux_amd64.zip"
terraform_url = "https://releases.hashicorp.com/terraform/#{terraform_version}/#{terraform_file}"

properties = YAML.load_file('spec/properties.yml')

task :serverspec    => 'serverspec:all'
#task :apply => :serverspec

namespace :serverspec do
  task :all => properties.keys.map {|key| 'serverspec:' + key.split('.')[0] }
  properties.keys.each do |key|
    desc "Run serverspec to #{key}"
    RSpec::Core::RakeTask.new(key.split('.')[0].to_sym) do |t|
      ENV['TARGET_HOST_NAME'] = key
      ENV['TARGET_HOST'] = properties[key][:ip]
      t.pattern = 'spec/shared/{' + properties[key][:roles].join(',') + '}/*_spec.rb'
    	puts "####################################"
    	puts "# Running serverspec to #{key}"
    	puts "####################################"
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

  task :init_tf, :version do |t, args|

		version=args[:version]

		File.exists?("config-#{version}.yml") ? true : abort("ERROR: config-#{version}.yml is missing")
		File.exists?("credentials.yml") ? true : abort("ERROR: credentials.yml is missing")

		Rake::Task["#{prjdir}/bin/terraform"].invoke

    configs = YAML.load_file("config-#{version}.yml")
    credentials = YAML.load_file('credentials.yml')

		#Terraform Configuration Hash
    tf_hash = {}
    tf_hash[:ospf_area_0_tun1_range]=configs['network']['common'][:tun1_range]
    tf_hash[:internal_ip_vyos01_tun1_range]=configs['network']['vyos01'][:tun1_ip]+"/"+configs['network']['common'][:tun1_ip_nm]
    tf_hash[:internal_ip_vyos02_tun1_range]=configs['network']['vyos02'][:tun1_ip]+"/"+configs['network']['common'][:tun1_ip_nm]
    tf_hash[:internal_ip_vyos01_tun1_ip]=configs['network']['vyos01'][:tun1_ip]
    tf_hash[:internal_ip_vyos02_tun1_ip]=configs['network']['vyos02'][:tun1_ip]
    tf_hash[:internal_ip_vyos01_tun1_rtr_id]=configs['network']['vyos01'][:rtr_id]
    tf_hash[:internal_ip_vyos02_tun1_rtr_id]=configs['network']['vyos02'][:rtr_id]
    tf_hash[:vyos_version]=configs['network']['common'][:vyos_version]
    tf_hash[:ssh_username]=configs['network']['common'][:ssh_username]
    tf_hash[:instance_type]=configs['network']['aws'][:instance_type]
    tf_hash[:region]=configs['network']['aws'][:region]
    tf_hash[:vyos_ami]=configs['network']['aws'][:ami]
    tf_hash[:subnet_id]=configs['network']['aws'][:subnet_id]
    tf_hash[:project]=configs['terraform']['common'][:project]
    tf_hash[:env]=configs['terraform']['common'][:env]

		FileUtils.cd("#{prjdir}/terraform/config") do 
			File.open("config.tfvars","w") do |f|
				tf_hash.each do |key, value|
					f.puts "#{key}=\"#{value}\""
				end
			end
		end

		#XXX Manage credentials for AWS here
		# Do Something if ENV VARS ?

    tf_credentials_hash = {}
    tf_credentials_hash[:ssh_keyname] = credentials['aws'][:key_name]
    tf_credentials_hash[:access_key] = credentials['aws'][:access_key]
    tf_credentials_hash[:secret_key] = credentials['aws'][:secret_key]
    tf_credentials_hash[:ssh_keypath]= credentials['common'][:ssh_keypath]


		FileUtils.cd("#{prjdir}/terraform/config") do 
			File.open("credentials.tfvars","w") do |f|
				tf_credentials_hash.each do |key, value|
					f.puts "#{key}=\"#{value}\""
				end
			end
		end



  end

  desc "Terraform Plan"
	task :plan_tf, :version do |t, args|

		version=args[:version]

		Rake::Task['env:init_tf'].invoke(version)

		ENV['PATH']="#{prjdir}/bin:"+ENV['PATH']

    configs = YAML.load_file("config-#{version}.yml")

		varlist = configs['terraform']['var_files'].length > 0 ? "-var-file=config/"+configs['terraform']['var_files'].join(" -var-file=config/") : ""

		FileUtils.cd("#{prjdir}/terraform") do
			sh %Q{terraform plan -var-file=config/config.tfvars #{varlist}} do |ok, res|
      	if ! ok
        	puts "Terraform Plan - FAILED"
        	abort("terraform plan - FAILED")
      	end
			end
  	end
	end

  desc "Apply Plan"
	task :apply_tf, :version do |t, args|

		version=args[:version]

		Rake::Task['env:init_tf'].invoke(version)

		ENV['PATH']="#{prjdir}/bin:"+ENV['PATH']

    configs = YAML.load_file("config-#{version}.yml")

		varlist = configs['terraform']['var_files'].length > 0 ? "-var-file=config/"+configs['terraform']['var_files'].join(" -var-file=config/") : ""

		FileUtils.cd("#{prjdir}/terraform") do
			sh %Q{terraform apply -var-file=config/config.tfvars #{varlist}} do |ok, res|
      	if ! ok
        	puts "Terraform apply - FAILED"
        	abort("terraform apply - FAILED")
      	end
			end
  	end
	end

  desc "Show Plan"
	task :show_tf, :version do |t, args|

		version=args[:version]

		Rake::Task['env:init_tf'].invoke(version)

		ENV['PATH']="#{prjdir}/bin:"+ENV['PATH']

    configs = YAML.load_file("config-#{version}.yml")

		FileUtils.cd("#{prjdir}/terraform") do
			sh %Q{terraform show } do |ok, res|
      	if ! ok
        	puts "Terraform show - FAILED"
        	abort("terraform show - FAILED")
      	end
			end
		end
	end



  desc "Destroy Plan"
	task :destroy_tf, :version do |t, args|

		version=args[:version]

		Rake::Task['env:init_tf'].invoke(version)

		ENV['PATH']="#{prjdir}/bin:"+ENV['PATH']

    configs = YAML.load_file("config-#{version}.yml")

		varlist = configs['terraform']['var_files'].length > 0 ? "-var-file=config/"+configs['terraform']['var_files'].join(" -var-file=config/") : ""

		FileUtils.cd("#{prjdir}/terraform") do
			sh %Q{terraform destroy -force -var-file=config/config.tfvars #{varlist}} do |ok, res|
      	if ! ok
        	puts "Terraform destroy - FAILED"
        	abort("terraform destroy - FAILED")
      	end
			end
  	end
	end

  task :init_spec, :version do |t, args|

		version=args[:version]

		File.exists?("config-#{version}.yml") ? true : abort("ERROR: config-#{version}.yml is missing")
		File.exists?("credentials.yml") ? true : abort("ERROR: credentials.yml is missing")

    configs = YAML.load_file("config-#{version}.yml")
    credentials = YAML.load_file('credentials.yml')

		ENV['PATH']="#{prjdir}/bin:"+ENV['PATH']

		tf_output =`terraform output -state=terraform/terraform.tfstate`
		if ! $?.success?
			abort("Terraform Output Failed. Can't init SERVERSPEC")
		end

		tf_hash = {}
		tf_output.split("\n").each do |line|
			key,value=line.split('=')
			tf_hash[key.strip()]=value.strip()
		end

		# Generate properties.yml to prepare serverspec run
		properties_file={}
		properties_file['vyos01']={}
		properties_file['vyos02']={}
		properties_file['vyos01'][:ip]=tf_hash['vyos01_public_ip']
		properties_file['vyos02'][:ip]=tf_hash['vyos02_public_ip']
		properties_file['vyos01'][:ip_peer]=tf_hash['vyos02_public_ip']
		properties_file['vyos02'][:ip_peer]=tf_hash['vyos01_public_ip']
		properties_file['vyos01'][:private_ip]=tf_hash['vyos01_private_ip']
		properties_file['vyos02'][:private_ip]=tf_hash['vyos02_private_ip']
		properties_file['vyos01'][:private_ip_peer]=tf_hash['vyos02_private_ip']
		properties_file['vyos02'][:private_ip_peer]=tf_hash['vyos01_private_ip']
    properties_file['vyos01'][:tun1_ip_range]=configs['network']['vyos01'][:tun1_ip]+"/"+configs['network']['common'][:tun1_ip_nm]
    properties_file['vyos02'][:tun1_ip_range]=configs['network']['vyos02'][:tun1_ip]+"/"+configs['network']['common'][:tun1_ip_nm]
    properties_file['vyos01'][:tun1_ip_range_peer]=configs['network']['vyos02'][:tun1_ip]+"/"+configs['network']['common'][:tun1_ip_nm]
    properties_file['vyos02'][:tun1_ip_range_peer]=configs['network']['vyos01'][:tun1_ip]+"/"+configs['network']['common'][:tun1_ip_nm]
    properties_file['vyos01'][:tun1_ip]=configs['network']['vyos01'][:tun1_ip]
    properties_file['vyos02'][:tun1_ip]=configs['network']['vyos02'][:tun1_ip]
    properties_file['vyos01'][:tun1_ip_peer]=configs['network']['vyos02'][:tun1_ip]
    properties_file['vyos02'][:tun1_ip_peer]=configs['network']['vyos01'][:tun1_ip]
    properties_file['vyos01'][:rtr_id]=configs['network']['vyos01'][:rtr_id]
    properties_file['vyos02'][:rtr_id]=configs['network']['vyos02'][:rtr_id]
    properties_file['vyos01'][:rtr_id_peer]=configs['network']['vyos02'][:rtr_id]
    properties_file['vyos02'][:rtr_id_peer]=configs['network']['vyos01'][:rtr_id]
    properties_file['vyos01'][:roles]=configs['spec_roles']
    properties_file['vyos02'][:roles]=configs['spec_roles']
    properties_file['vyos01'][:ssh_username]=configs['network']['common'][:ssh_username]
    properties_file['vyos01'][:ssh_keypath]=credentials['common'][:ssh_keypath]
    properties_file['vyos02'][:ssh_username]=configs['network']['common'][:ssh_username]
    properties_file['vyos02'][:ssh_keypath]=credentials['common'][:ssh_keypath]

		FileUtils.cd("#{prjdir}/spec/") do
			File.open("properties.yml","w") do |f|
					f.puts properties_file.to_yaml
			end
		end
  end

end
