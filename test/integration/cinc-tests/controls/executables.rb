title 'Cinc executables'

control 'Common tests for all platforms' do
  impact 1.0
  title 'Validate basic functionnality on all platforms'
  desc 'Common test to all platforms'

  describe command 'cinc-client --version' do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /^Cinc Client:/ }
  end

  describe command 'cinc-solo --version' do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /^Cinc Client:/ }
  end

  describe command 'chef-client --version' do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /^Redirecting to cinc-client/ }
    its('stdout') { should match /^Cinc Client:/ }
  end

  describe command 'chef-solo --version' do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /^Redirecting to cinc-solo/ }
    its('stdout') { should match /^Cinc Client:/ }
  end
end

control 'cinc-*nix' do
  impact 1.0
  title 'Validate executables outputs on linux and mac'
  desc 'Outputs should not contain trademarks on linux or mac'
  only_if { os.family != 'windows' }

  describe command 'chef-solo -l info -o ""' do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /^Redirecting to cinc-solo/ }
    its('stdout') { should match /Cinc Zero/ }
    its('stdout') { should match /Cinc Client/ }
    its('stdout') { should match /Cinc-client/ }
    its('stdout') { should match %r{/etc/cinc/client.rb} }
    its('stdout') { should match %r{/var/cinc} }
    its('stdout') { should_not match /Chef Infra Zero/ }
    its('stdout') { should_not match /Chef Infra Client/ }
    its('stdout') { should_not match /Chef-client/ }
    its('stdout') { should_not match %r{/etc/chef/client.rb} }
    its('stdout') { should_not match %r{/var/chef} }
  end

  describe command '/opt/cinc/embedded/bin/cinc-zero --version' do
    its('exit_status') { should eq 0 }
  end unless ENV['HAB_TEST']

  describe command '/opt/cinc/bin/cinc-auditor version' do
    its('exit_status') { should eq 0 }
  end

  describe command '/opt/cinc/bin/cinc-auditor detect' do
    its('exit_status') { should eq 0 }
  end

  describe command '/opt/cinc/bin/inspec version' do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /^Redirecting to cinc-auditor/ }
  end

  describe command 'chef-client --version' do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /^Redirecting to cinc-client/ }
    its('stdout') { should match /^Cinc Client:/ }
  end

  describe command 'chef-solo --version' do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /^Redirecting to cinc-solo/ }
    its('stdout') { should match /^Cinc Client:/ }
  end
end
