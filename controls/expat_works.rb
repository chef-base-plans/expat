title 'Tests to confirm expat works as expected'

plan_name = input('plan_name', value: 'expat')
plan_ident = "#{ENV['HAB_ORIGIN']}/#{plan_name}"
expat_path = command("hab pkg path #{plan_ident}")
expat_pkg_ident = ((expat_path.stdout.strip).match /(?<=pkgs\/)(.*)/)[1]

control 'core-plans-expat-works-001' do
  impact 1.0
  title 'expat binary should exist'
  describe expat_path do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
  end
end

control 'core-plans-expat-works-002' do
  impact 1.0
  title 'expat should parse well-formed xml'
  describe command("DEBUG=true; hab pkg exec #{expat_pkg_ident} xmlwf /hab/svc/expat/config/fixtures/valid.xml") do
    its('exit_status') { should eq 0 }
    its('stdout') { should be_empty }
    its('stderr') { should be_empty }
  end
end

control 'core-plans-expat-works-003' do
  impact 1.0
  title 'should report error on malformed xml'
  describe command("DEBUG=true; hab pkg exec #{expat_pkg_ident} xmlwf /hab/svc/expat/config/fixtures/mismatched-tag.xml") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /mismatched tag/ }
    its('stderr') { should be_empty }
  end

end


