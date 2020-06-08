title 'Tests to confirm expat works as expected'

plan_origin = ENV['HAB_ORIGIN']
plan_name = input('plan_name', value: 'expat')
plan_installation_directory = command("hab pkg path #{plan_origin}/#{plan_name}")
plan_pkg_ident = ((plan_installation_directory.stdout.strip).match /(?<=pkgs\/)(.*)/)[1]
plan_pkg_version = (plan_pkg_ident.match /^#{plan_origin}\/#{plan_name}\/(?<version>.*)\//)[:version]

control 'core-plans-expat-works' do
  impact 1.0
  title 'Ensure expat works as expected'
  desc '
  Verify expat by ensuring (1) its installation directory exists and (2) that
  it successfully parses valid xml and (3) that it reports an error for invalid
  xml
  '
  
  describe plan_installation_directory do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
  end

  describe command("DEBUG=true; hab pkg exec #{plan_pkg_ident} xmlwf /hab/svc/expat/config/fixtures/valid.xml") do
    its('exit_status') { should eq 0 }
    its('stdout') { should be_empty }
    its('stderr') { should be_empty }
  end

  describe command("DEBUG=true; hab pkg exec #{plan_pkg_ident} xmlwf /hab/svc/expat/config/fixtures/mismatched-tag.xml") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /mismatched tag/ }
    its('stderr') { should be_empty }
  end

end


