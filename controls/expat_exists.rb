title 'Tests to confirm expat exists'

plan_name = input('plan_name', value: 'expat')
plan_ident = "#{ENV['HAB_ORIGIN']}/#{plan_name}"
expat_relative_path = input('command_path', value: '/bin/xmlwf')
expat_installation_directory = command("hab pkg path #{plan_ident}")
expat_full_path = expat_installation_directory.stdout.strip + "#{ expat_relative_path}"
 
control 'core-plans-expat-exists' do
  impact 1.0
  title 'Ensure expat exists'
  desc '
  '
   describe file(expat_full_path) do
    it { should exist }
  end
end
